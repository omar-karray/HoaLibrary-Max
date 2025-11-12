#!/bin/bash
#
# HoaLibrary Release Packaging Script
# Creates a distributable .zip package for GitHub releases
#

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
VERSION="3.0.0"
PACKAGE_NAME="HoaLibrary"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/Package/${PACKAGE_NAME}"
BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/build"
RELEASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/releases"
RELEASE_NAME="${PACKAGE_NAME}-Mac-v${VERSION}"
RELEASE_ZIP="${RELEASE_NAME}.zip"

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  HoaLibrary v${VERSION} - Release Packaging${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# Check if package is built
if [ ! -d "$SOURCE_DIR/externals" ] || [ -z "$(ls -A $SOURCE_DIR/externals/*.mxo 2>/dev/null)" ]; then
    echo -e "${RED}✗ Error: Package not built${NC}"
    echo ""
    echo "Please build the package first:"
    echo "  cd build"
    echo "  cmake .. && cmake --build ."
    exit 1
fi

# Create releases directory
mkdir -p "$RELEASE_DIR"

# Clean old release if it exists
if [ -f "$RELEASE_DIR/$RELEASE_ZIP" ]; then
    echo -e "${YELLOW}⚠ Removing old release package...${NC}"
    rm "$RELEASE_DIR/$RELEASE_ZIP"
fi

# Create temporary directory for packaging
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="$TEMP_DIR/$PACKAGE_NAME"
mkdir -p "$PACKAGE_DIR"

echo -e "${BLUE}→ Preparing package contents...${NC}"

# Copy package contents
cp -R "$SOURCE_DIR/"* "$PACKAGE_DIR/"

# Verify externals are Universal Binary
echo -e "${BLUE}→ Verifying Universal Binary externals...${NC}"
EXTERNAL_COUNT=0
ARM64_COUNT=0
X86_COUNT=0

for mxo in "$PACKAGE_DIR/externals"/*.mxo; do
    if [ -d "$mxo" ]; then
        BINARY="$mxo/Contents/MacOS/$(basename "$mxo" .mxo)"
        if [ -f "$BINARY" ]; then
            EXTERNAL_COUNT=$((EXTERNAL_COUNT + 1))
            ARCHS=$(lipo -info "$BINARY" 2>/dev/null | grep "Architectures" || echo "")
            if [[ "$ARCHS" == *"arm64"* ]]; then
                ARM64_COUNT=$((ARM64_COUNT + 1))
            fi
            if [[ "$ARCHS" == *"x86_64"* ]]; then
                X86_COUNT=$((X86_COUNT + 1))
            fi
        fi
    fi
done

if [ $ARM64_COUNT -ne $EXTERNAL_COUNT ] || [ $X86_COUNT -ne $EXTERNAL_COUNT ]; then
    echo -e "${RED}✗ Error: Not all externals are Universal Binary${NC}"
    echo "  Found: $EXTERNAL_COUNT externals"
    echo "  arm64: $ARM64_COUNT, x86_64: $X86_COUNT"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}  ✓ All $EXTERNAL_COUNT externals are Universal Binary (x86_64 + arm64)${NC}"

# Create INSTALL.txt for users
cat > "$PACKAGE_DIR/INSTALL.txt" << 'EOF'
HoaLibrary v3.0 for Max 9 - Installation Instructions
======================================================

REQUIREMENTS:
- Max 9.0 or higher
- macOS 10.15 (Catalina) or higher
- Compatible with Intel (x86_64) and Apple Silicon (arm64)

INSTALLATION:
1. Close Max if it's running
2. Copy the entire "HoaLibrary" folder to:
   ~/Documents/Max 9/Packages/
   
   (The full path should be: ~/Documents/Max 9/Packages/HoaLibrary/)

3. Launch or restart Max 9

4. Test the installation:
   - Create a new patcher
   - Try creating objects: hoa.2d.encoder~, hoa.3d.decoder~
   - Right-click or Cmd+Click on objects to access help files

UNINSTALLATION:
- Simply remove the HoaLibrary folder from ~/Documents/Max 9/Packages/

SUPPORT:
- GitHub: https://github.com/CICM/HoaLibrary-Max
- Report issues: https://github.com/CICM/HoaLibrary-Max/issues

This release includes:
- 37 Universal Binary externals (x86_64 + arm64)
- Complete help documentation
- Example patches and abstractions
- 2D and 3D spatial audio tools
EOF

# Create VERSION.txt
cat > "$PACKAGE_DIR/VERSION.txt" << EOF
HoaLibrary v${VERSION} for Max 9
Built on: $(date +"%Y-%m-%d")
Platform: macOS Universal Binary (x86_64 + arm64)
Min macOS: 10.15 (Catalina)
Max Version: 9.0 or higher

Changes from v2.2:
- Rebuilt for Max 9 and Apple Silicon
- Universal Binary support (Intel + Apple Silicon)
- Updated to Max SDK 8.2.0
- Fixed C++ standards compliance issues
- Modern CMake build system
- All externals tested and verified

This is an unofficial community build for Max 9.
Original HoaLibrary by CICM - Pierre Guillot, Eliott Paris, Julien Colafrancesco
EOF

# Create the release package
echo -e "${BLUE}→ Creating release archive...${NC}"
cd "$TEMP_DIR"
zip -rq "$RELEASE_DIR/$RELEASE_ZIP" "$PACKAGE_NAME"
cd - > /dev/null

# Clean up
rm -rf "$TEMP_DIR"

# Get package size
PACKAGE_SIZE=$(du -h "$RELEASE_DIR/$RELEASE_ZIP" | cut -f1)

echo ""
echo -e "${GREEN}✓ Release package created successfully!${NC}"
echo ""
echo -e "${GREEN}Release Details:${NC}"
echo "  File: $RELEASE_ZIP"
echo "  Location: $RELEASE_DIR/"
echo "  Size: $PACKAGE_SIZE"
echo "  Externals: $EXTERNAL_COUNT (all Universal Binary)"
echo ""
echo -e "${BLUE}GitHub Release Instructions:${NC}"
echo "  1. Go to: https://github.com/CICM/HoaLibrary-Max/releases/new"
echo "  2. Tag version: v${VERSION}"
echo "  3. Release title: HoaLibrary v${VERSION} for Max 9"
echo "  4. Upload: $RELEASE_DIR/$RELEASE_ZIP"
echo "  5. Add release notes (see RELEASE_NOTES.md)"
echo ""
echo -e "${YELLOW}Package structure:${NC}"
cd "$RELEASE_DIR"
unzip -l "$RELEASE_ZIP" | head -30
echo ""
