#!/bin/bash
# install.sh - Install PMO (Project Management Office) locally
# 
# Usage (default - uses ~/GitProjects as root):
#   curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -s
#
# Usage (local - creates GitProjects in current directory):
#   cd ~/test && curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -s -- --local
#
# Usage (custom root directory):
#   curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -s -- --root-dir ~/custom

set -euo pipefail

# Configuration
REPO_URL="https://github.com/TrustNetT/PMO.git"
CURRENT_DIR="$(pwd)"
PMO_DIR=""
USE_LOCAL=false
ROOT_DIR=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --local)
            USE_LOCAL=true
            shift
            ;;
        --root-dir)
            ROOT_DIR="$2"
            shift 2
            ;;
        --help)
            echo "PMO Installer"
            echo ""
            echo "Usage: curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -s [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --local              Create GitProjects in current directory (e.g., ~/test/GitProjects/PMO)"
            echo "  --root-dir PATH      Use PATH/GitProjects/PMO as install location (default: ~/GitProjects/PMO)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Default: Uses ~/GitProjects/PMO and ~/wip for repos"
            echo "  curl -sSL https://... | bash -s"
            echo ""
            echo "  # Local: Creates ./GitProjects/PMO if run from ~/test"
            echo "  cd ~/test && curl -sSL https://... | bash -s -- --local"
            echo ""
            echo "  # Custom: Uses ~/mybase/GitProjects/PMO"
            echo "  curl -sSL https://... | bash -s -- --root-dir ~/mybase"
            echo ""
            echo "Directory Structure Created:"
            echo "  ./"
            echo "  ├── GitProjects/"
            echo "  │   └── PMO/               ← PMO scripts and tools"
            echo "  └── wip/"
            echo "      ├── priv/              ← Private WIP repositories"
            echo "      └── pub/               ← Public distribution repos"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Determine GitProjects root and WIP parent directory
if [[ "$USE_LOCAL" == true ]]; then
    # Use current directory for base
    BASE_DIR="$CURRENT_DIR"
    GITPROJECTS_ROOT="$CURRENT_DIR/GitProjects"
elif [[ -n "$ROOT_DIR" ]]; then
    # Use custom root directory
    ROOT_DIR="${ROOT_DIR/#\~/$HOME}"
    BASE_DIR="$ROOT_DIR"
    GITPROJECTS_ROOT="$ROOT_DIR/GitProjects"
else
    # Default to ~/GitProjects at home level
    BASE_DIR="$HOME"
    GITPROJECTS_ROOT="$HOME/GitProjects"
fi

# PMO goes INSIDE GitProjects
PMO_DIR="$GITPROJECTS_ROOT/PMO"

# WIP repos go parallel to GitProjects (same parent)
WIP_PARENT="$BASE_DIR/wip"

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

echo ""
echo "=========================================="
print_info "PMO (Project Management Office) Installer"
echo "=========================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "git is not installed. Please install git and try again."
    exit 1
fi

print_info "Installation Details:"
echo "  Current directory: $CURRENT_DIR"
echo "  Base directory: $BASE_DIR"
echo "  GitProjects root: $GITPROJECTS_ROOT"
echo "  PMO location: $PMO_DIR"
echo "  WIP repos: $WIP_PARENT"
echo ""

# Check if PMO is already cloned
if [[ -d "$PMO_DIR" ]]; then
    print_error "PMO is already installed: $PMO_DIR"
    read -p "Do you want to remove and reinstall? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    print_step "Removing existing PMO installation..."
    rm -rf "$PMO_DIR"
fi

# Create GitProjects directory structure
print_step "Creating GitProjects structure..."
mkdir -p "$GITPROJECTS_ROOT"
print_success "GitProjects created: $GITPROJECTS_ROOT"

# Clone PMO repository into GitProjects
print_step "Cloning PMO repository..."
if git clone "$REPO_URL" "$PMO_DIR"; then
    print_success "Repository cloned to: $PMO_DIR"
else
    print_error "Failed to clone repository"
    exit 1
fi

# Make scripts executable
print_step "Setting up scripts..."
cd "$PMO_DIR"
chmod +x .scripts/* 2>/dev/null || true
print_success "Scripts configured"

# Verify git remote is configured
print_step "Verifying repository configuration..."
if git config --get remote.origin.url &>/dev/null; then
    REMOTE=$(git config --get remote.origin.url)
    print_success "Git remote: $REMOTE"
else
    print_error "Git remote not configured properly"
    exit 1
fi

# Create WIP structure (parallel to GitProjects)
print_step "Setting up WIP repository structure..."
mkdir -p "$WIP_PARENT/priv"
mkdir -p "$WIP_PARENT/pub"
print_success "WIP directories created"

echo ""
echo "=========================================="
print_success "PMO Installation Complete!"
echo "=========================================="
echo ""
echo "Installation Summary:"
echo "  Base directory: $BASE_DIR"
echo "  GitProjects root: $GITPROJECTS_ROOT"
echo "  PMO location: $PMO_DIR"
echo "  WIP repos (private): $WIP_PARENT/priv"
echo "  WIP repos (public): $WIP_PARENT/pub"
echo ""
echo "Directory Structure:"
echo "  $BASE_DIR/"
echo "  ├── GitProjects/"
echo "  │   └── PMO/               ← You are here"
echo "  └── wip/"
echo "      ├── priv/              ← Private WIP repositories"
echo "      └── pub/               ← Public distribution repos"
echo ""
echo "Next steps:"
echo "  1. Create a new project:"
echo "     $PMO_DIR/.scripts/newproject -n ProjectName -t nodejs -o OrgName"
echo ""
echo "  2. Check for PMO updates:"
echo "     $PMO_DIR/.scripts/update-pmo --check"
echo ""
echo "  3. View documentation:"
echo "     cat $PMO_DIR/docs/DUAL_REPO_SCRIPTS.md"
echo ""
echo "For more information, visit:"
echo "  https://github.com/TrustNetT/PMO"
echo ""
