#!/bin/bash
# install.sh - Install PMO (Project Management Office) locally
# Usage: curl -sSL https://github.com/TrustNetT/PMO/raw/main/install.sh | bash

set -euo pipefail

# Configuration
REPO_URL="https://github.com/TrustNetT/PMO.git"
INSTALL_DIR="${PMO_INSTALL_DIR:-$HOME/PMO}"

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

# Check if installation directory already exists
if [[ -d "$INSTALL_DIR" ]]; then
    print_error "Installation directory already exists: $INSTALL_DIR"
    read -p "Do you want to remove and reinstall? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    print_step "Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

# Create installation directory
print_step "Creating installation directory..."
mkdir -p "$INSTALL_DIR"
print_success "Directory created: $INSTALL_DIR"

# Clone repository
print_step "Cloning PMO repository..."
if git clone "$REPO_URL" "$INSTALL_DIR"; then
    print_success "Repository cloned"
else
    print_error "Failed to clone repository"
    rm -rf "$INSTALL_DIR"
    exit 1
fi

# Make scripts executable
print_step "Setting up scripts..."
cd "$INSTALL_DIR"
chmod +x .scripts/* 2>/dev/null || true
print_success "Scripts configured"

# Verify git remote is configured
print_step "Verifying repository configuration..."
if git config --get remote.origin.url &>/dev/null; then
    REMOTE=$(git config --get remote.origin.url)
    print_success "Git remote configured: $REMOTE"
else
    print_error "Git remote not configured properly"
    exit 1
fi

echo ""
echo "=========================================="
print_success "PMO Installation Complete!"
echo "=========================================="
echo ""
echo "Installation directory: $INSTALL_DIR"
echo ""
echo "Next steps:"
echo "  1. Create a new project:"
echo "     $INSTALL_DIR/.scripts/newproject -n ProjectName -t nodejs -o OrgName"
echo ""
echo "  2. Check for PMO updates:"
echo "     $INSTALL_DIR/.scripts/update-pmo --check"
echo ""
echo "  3. View documentation:"
echo "     cat $INSTALL_DIR/docs/DUAL_REPO_SCRIPTS.md"
echo ""
echo "For more information, visit:"
echo "  https://github.com/TrustNetT/PMO"
echo ""
