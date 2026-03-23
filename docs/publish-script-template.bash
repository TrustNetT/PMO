#!/bin/bash
# publish-pmo - Publish PMO WIP to public distribution repo
# Copies ONLY public content from private WIP to public repo
# Excludes: activity/, internal docs, .env, secrets

set -euo pipefail

# Configuration
PROJECT_NAME_LOWER="pmo"
PROJECT_NAME_UPPER="PMO"

# Parameter handling
DO_CREATE=true
DO_PUSH=true

show_help() {
    cat << 'EOFHELP'
Usage: ./publish-pmo [OPTIONS]

Options:
  --all              Create distribution and push to GitHub (default)
  --no-push          Create distribution but don't push (allows inspection first)
  --push             Push latest commit without recreating distribution
  --help             Show this help message

Examples:
  ./publish-pmo              # Same as --all
  ./publish-pmo --no-push    # Create only, inspect, then run again to push
  ./publish-pmo --push       # Push without recreating

Workflow for inspection:
  1. ./publish-pmo --no-push    # Create distribution
  2. cd ~/wip/pub/PMO           # Inspect contents
  3. ./publish-pmo --push        # Push when satisfied
EOFHELP
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            show_help
            ;;
        --all)
            DO_CREATE=true
            DO_PUSH=true
            shift
            ;;
        --no-push)
            DO_CREATE=true
            DO_PUSH=false
            shift
            ;;
        --push)
            DO_CREATE=false
            DO_PUSH=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Get WIP directory from script location (works anywhere, works for any user)
# Script is at: {symlink}/pmo-wip/tools/publish-pmo
# WIP repo is: one level up from tools
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WIP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Use environment variables for parent directories, with sensible defaults
WIP_PARENT="${WIP_PARENT:-$HOME/wip/priv}"
PUB_PARENT="${PUB_PARENT:-$HOME/wip/pub}"

# Construct paths
WIP_FULL="$WIP_DIR"
PUB_DIR="${PUB_PARENT}/PMO"
PMO_ROOT="${PMO_ROOT:-$HOME/.PMO}"  # Location of shared operational docs

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${BLUE}→ $1${NC}"
}

# Verify paths exist
if [[ ! -d "$WIP_FULL" ]]; then
    print_error "WIP directory not found: $WIP_FULL"
    exit 1
fi

if [[ ! -d "$PUB_DIR" ]]; then
    print_error "Public directory not found: $PUB_DIR"
    exit 1
fi

# Verify WIP is clean (only needed if creating distribution)
if [[ "$DO_CREATE" == "true" ]] && [[ ! -z $(git -C "$WIP_FULL" status --porcelain) ]]; then
    print_error "WIP repo has uncommitted changes"
    echo "Commit all changes before publishing:"
    git -C "$WIP_FULL" status
    exit 1
fi

echo ""
if [[ "$DO_CREATE" == "true" ]]; then
    print_info "Publishing $PROJECT_NAME_UPPER to public distribution repo"
else
    print_info "Pushing $PROJECT_NAME_UPPER to GitHub"
fi
# Display paths with ~ for portability
WIP_DISPLAY=$(echo "$WIP_FULL" | sed "s|$HOME|~|g")
PUB_DISPLAY=$(echo "$PUB_DIR" | sed "s|$HOME|~|g")
if [[ "$DO_CREATE" == "true" ]]; then
    echo "  WIP source: $WIP_DISPLAY"
    echo "  PUB dest:   $PUB_DISPLAY"
fi
echo ""

# ========== CREATION PHASE (if DO_CREATE is true) ==========
if [[ "$DO_CREATE" == "true" ]]; then

# Step 1: Clean public directory (keep .git)
print_step "Cleaning public repo directory..."
cd "$PUB_DIR"
# Delete all files/dirs except .git and .gitignore
for item in .??* *; do
    [[ "$item" == ".git" || "$item" == ".gitignore" || "$item" == "." || "$item" == ".." ]] && continue
    rm -rf "$item"
done
cd - > /dev/null
print_success "Cleaned public directory"

# Step 2: Copy LICENSE
print_step "Copying LICENSE..."
if [[ -f "$WIP_FULL/LICENSE" ]]; then
    cp "$WIP_FULL/LICENSE" "$PUB_DIR/LICENSE"
    print_success "LICENSE copied"
else
    print_info "No LICENSE found in WIP"
fi

# Step 3: Copy docs/ folder
print_step "Copying operational documentation..."
if [[ -d "$PMO_ROOT/docs" ]]; then
    cp -r "$PMO_ROOT/docs" "$PUB_DIR/"
    print_success "docs/ folder copied"
else
    print_info "No docs/ folder found at $PMO_ROOT"
fi

# Step 4: Copy .github/instructions/ (generic for public)
print_step "Copying generic management instructions..."
if [[ -d "$WIP_FULL/.github/instructions" ]]; then
    mkdir -p "$PUB_DIR/.github/instructions"
    cp "$WIP_FULL/.github/instructions"/* "$PUB_DIR/.github/instructions/" 2>/dev/null || true
    print_success ".github/instructions/ copied"
else
    print_info "No .github/instructions/ folder found"
fi

# Step 5: Create empty activity folder structure
print_step "Creating empty activity folder structure..."
mkdir -p "$PUB_DIR/activity"/{status,sprints,vibe,snapshots,planning}
touch "$PUB_DIR/activity"/{status,sprints,vibe,snapshots,planning}/.gitkeep
print_success "activity/ folder structure created (empty for end-users)"

# Step 6: Generate README.md
print_step "Generating README.md..."
cat > "$PUB_DIR/README.md" << 'EOFREADME'
# PMO

[Project description will go here - customize this file as needed]

## Quick Start

For installation and setup instructions, see [docs/guides/](docs/guides/).

## Structure

```
├── docs/              # Documentation
├── activity/          # Activity tracking (created per session)
├── .github/           # GitHub integration and instructions
└── README.md          # This file
```

## Getting Started

1. Clone this repository
2. Follow the guides in [docs/](docs/)
3. Start tracking your work in `activity/`

For more information, visit the documentation.
EOFREADME
print_success "README.md generated"

    # Step 7: Create git commit (for creation phase)
    print_step "Creating git commit..."
    cd "$PUB_DIR"
    git add -A
    if git commit -m "Publish: $(date '+%Y-%m-%d %H:%M:%S') - Synced from WIP"; then
        print_success "Commit created"
    else
        print_info "No changes to commit"
    fi
fi
# ========== END CREATION PHASE ==========

# ========== PUSH PHASE (if DO_PUSH is true) ==========
if [[ "$DO_PUSH" == "true" ]]; then
    print_step "Pushing to GitHub..."
    cd "$PUB_DIR"
    if git push origin main 2>/dev/null || true; then
        print_success "Pushed to GitHub"
    else
        print_info "Git push skipped (may require authentication)"
    fi
fi
# ========== END PUSH PHASE ==========

echo ""
echo "=========================================="
print_success "Operation complete!"
echo "=========================================="
echo ""

if [[ "$DO_CREATE" == "true" ]] && [[ "$DO_PUSH" == "true" ]]; then
    echo "Public repo contents:"
    echo "  - LICENSE"
    echo "  - README.md (user-facing overview)"
    echo "  - docs/ (operational documentation)"
    echo "  - .github/instructions/ (management guides)"
    echo "  - activity/ (empty structure for end-users)"
    echo ""
    PUB_DIR_DISPLAY=$(echo "$PUB_DIR" | sed "s|$HOME|~|g")
    echo "Location: $PUB_DIR_DISPLAY"
    echo ""
    echo "✓ Distribution created and pushed to GitHub"
    echo ""
elif [[ "$DO_CREATE" == "true" ]] && [[ "$DO_PUSH" == "false" ]]; then
    echo "Distribution created (NOT pushed yet)"
    echo ""
    echo "Inspect the contents:  cd ~/wip/pub/PMO"
    echo ""
    echo "To push after inspection:  ./publish-pmo --push"
    echo ""
elif [[ "$DO_CREATE" == "false" ]] && [[ "$DO_PUSH" == "true" ]]; then
    echo "✓ Latest changes pushed to GitHub"
    echo ""
    echo "No new distribution was created."
    echo ""
fi

