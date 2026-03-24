#!/bin/bash
# install.sh - Install PMO (Project Management Office) locally
# 
# This script ONLY clones PMO into GitProjects
# It does NOT create or touch ~/wip/ (production repository storage)
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
            echo "  --local              Create in current directory (e.g., ~/test/GitProjects/PMO)"
            echo "  --root-dir PATH      Use PATH/GitProjects/PMO (default: ~/GitProjects/PMO)"
            echo "  --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Default: Install to ~/GitProjects/PMO"
            echo "  curl -sSL https://... | bash -s"
            echo ""
            echo "  # Local: Install to ./GitProjects/PMO from current directory"
            echo "  cd ~/test && curl -sSL https://... | bash -s -- --local"
            echo ""
            echo "  # Custom: Install to ~/custom/GitProjects/PMO"
            echo "  curl -sSL https://... | bash -s -- --root-dir ~/custom"
            echo ""
            echo "NOTE: This script does NOT create ~/wip/ directories."
            echo "      Only PMO is installed to GitProjects."
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Determine GitProjects root and BASE_DIR (for wip location in --local mode)
if [[ "$USE_LOCAL" == true ]]; then
    # Use current directory
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

# WIP directories (only created in --local mode)
WIP_ROOT="$BASE_DIR/wip"

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
echo "  GitProjects root: $GITPROJECTS_ROOT"
echo "  PMO location: $PMO_DIR"
echo ""

# Check if PMO is already installed
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
print_step "Creating GitProjects directory..."
mkdir -p "$GITPROJECTS_ROOT"
print_success "Directory created: $GITPROJECTS_ROOT"

# Create WIP structure (ONLY in --local mode, never in production)
if [[ "$USE_LOCAL" == true ]]; then
    print_step "Creating WIP repository structure..."
    mkdir -p "$WIP_ROOT/priv"
    mkdir -p "$WIP_ROOT/pub"
    print_success "WIP structure created"
fi

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

echo ""
echo "=========================================="
print_success "PMO Installation Complete!"
echo "=========================================="
echo ""
echo "Installation Summary:"
echo "  PMO location: $PMO_DIR"
echo "  Git remote: $REMOTE"
echo ""

if [[ "$USE_LOCAL" == true ]]; then
    echo "Directory Structure (Isolated Test Environment):"
    echo "  $CURRENT_DIR/"
    echo "  ├── GitProjects/"
    echo "  │   └── PMO/               ← You are here"
    echo "  └── wip/"
    echo "      ├── priv/              ← Test private repos"
    echo "      └── pub/               ← Test public repos"
else
    echo "Directory Structure:"
    echo "  ~/GitProjects/"
    echo "  └── PMO/               ← You are here"
    echo ""
    echo "IMPORTANT:"
    echo "  • ~/wip/ is production data - NEVER touched by installer"
    echo "  • Repository projects are linked via newproject script"
fi
echo ""
echo "Next steps:"
echo "  1. Create a new project:"
echo "     $PMO_DIR/.scripts/newproject -n ProjectName -t nodejs -o OrgName"
echo ""
echo "  2. Check for PMO updates:"
echo "     $PMO_DIR/.scripts/update-pmo --check"
echo ""
echo "  3. View documentation:"
echo "     cat $PMO_DIR/README.md"
echo ""
echo "For more information, visit:"
echo "  https://github.com/TrustNetT/PMO"
echo ""
