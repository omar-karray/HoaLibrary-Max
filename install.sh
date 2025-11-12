#!/bin/bash
#
# HoaLibrary Installation Script for Max 9
# Installs the HoaLibrary package to ~/Documents/Max 9/Packages/
#

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
PACKAGE_NAME="HoaLibrary"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/Package/${PACKAGE_NAME}"
TARGET_DIR="${HOME}/Documents/Max 9/Packages/${PACKAGE_NAME}"

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  HoaLibrary v3.0 - Max 9 Installation${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}✗ Error: Source directory not found:${NC}"
    echo "  $SOURCE_DIR"
    echo ""
    echo "Please build the package first using CMake:"
    echo "  cd build"
    echo "  cmake .. && cmake --build ."
    exit 1
fi

# Check if Max 9 Packages directory exists
if [ ! -d "${HOME}/Documents/Max 9/Packages" ]; then
    echo -e "${YELLOW}⚠ Max 9 Packages directory not found${NC}"
    echo "  Creating: ${HOME}/Documents/Max 9/Packages"
    mkdir -p "${HOME}/Documents/Max 9/Packages"
fi

# Remove old version if it exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠ Removing old installation...${NC}"
    rm -rf "$TARGET_DIR"
fi

# Copy package
echo -e "${BLUE}→ Installing HoaLibrary to Max 9 Packages...${NC}"
cp -R "$SOURCE_DIR" "$TARGET_DIR"

# Verify installation
if [ -d "$TARGET_DIR" ]; then
    # Count externals
    EXTERNAL_COUNT=$(find "$TARGET_DIR/externals" -name "*.mxo" -type d | wc -l | tr -d ' ')
    
    echo ""
    echo -e "${GREEN}✓ Installation successful!${NC}"
    echo ""
    echo -e "${GREEN}Package Location:${NC}"
    echo "  $TARGET_DIR"
    echo ""
    echo -e "${GREEN}Installed Components:${NC}"
    echo "  • ${EXTERNAL_COUNT} externals (Universal Binary: x86_64 + arm64)"
    echo "  • Help files and documentation"
    echo "  • Example patches and abstractions"
    echo "  • Init files for Max integration"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  1. Launch or restart Max 9"
    echo "  2. Create a new patcher"
    echo "  3. Try creating objects like: hoa.2d.encoder~, hoa.3d.decoder~"
    echo "  4. Check help files (Cmd+Click on object)"
    echo ""
    echo -e "${YELLOW}Note:${NC} This build is for Max 9 on macOS (10.15+)"
    echo "      Supports both Intel (x86_64) and Apple Silicon (arm64)"
    echo ""
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
