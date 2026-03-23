#!/bin/bash
# install.sh - Install PMO (Project Management Office) locally
# 
# Usage (default - uses ~/GitProjects as root):
#   curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash
#
# Usage (local - creates GitProjects in current directory):
#   cd ~/test && curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -- --local
#
# Usage (custom root directory):
#   curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash -- --root-dir ~/custom

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
            echo "Usage: curl -sSL https://raw.githubusercontent.com/TrustNetT/PMO/main/install.sh | bash [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --local              Create GitProjects in current directory (e.g., ~/test/GitProjects)"
            echo "  --root-dir PATH      Use PATH/GitProjects as root (default: ~/GitProjects)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Default: Uses ~/GitProjects and clones PMO here"
            echo "  curl -sSL https://... | bash"
            echo ""
            echo "  # Local: Creates ~/test/GitProjects if run from ~/test"
            echo "  cd ~/test && curl -sSL https://... | bash -- --local"
            echo ""
            echo "  # Custom: Uses ~/mybase/GitProjects"
            echo "  curl -sSL https://... | bash -- --root-dir ~/mybase"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Determine where to put PMO (always in current directory)
PMO_DIR="$CURRENT_DIR/PMO"

# Determine GitProjects root
if [[ "$USE_LOCAL" == true ]]; then
    # Use current directory/GitProjects
    GITPROJECTS_ROOT="$CURRENT_DIR/GitProjects"
elif [[ -n "$ROOT_DIR" ]]; then
    # Use custom root
    ROOT_DIR="${ROOT_DIR/#\~/$HOME}"
    GITPROJECTS_ROOT="$ROOT_DIR/GitProjects"
else
    # Default to ~/GitProjects
    GITPROJECTS_ROOT="$HOME/GitProjects"
fi

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
echo "  PMO clone location: $PMO_DIR"
echo "  GitProjects root: $GITPROJECTS_ROOT"
echo ""

# Check if PMO already cloned here
if [[ -d "$PMO_DIR" ]]; then
    print_error "PMO is already cloned in this directory: $PMO_DIR"
    read -p "Do you want to remove and reinstall? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    print_step "Removing existing PMO installation..."
    rm -rf "$PMO_DIR"
fi

# Clone PMO repository into current directory
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

# Create GitProjects structure (WIP and Public repos)
print_step "Setting up GitProjects structure..."
WIP_PARENT="$GITPROJECTS_ROOT/../wip/priv"
PUB_PARENT="$GITPROJECTS_ROOT/../wip/pub"

mkdir -p "$GITPROJECTS_ROOT"
mkdir -p "$WIP_PARENT"
mkdir -p "$PUB_PARENT"
print_success "GitProjects directories created"

echo ""
echo "=========================================="
print_success "PMO Installation Complete!"
echo "=========================================="
echo ""
echo "Installation Summary:"
echo "  PMO directory: $PMO_DIR"
echo "  GitProjects root: $GITPROJECTS_ROOT"
echo "  WIP repos: $WIP_PARENT"
echo "  Public repos: $PUB_PARENT"
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
