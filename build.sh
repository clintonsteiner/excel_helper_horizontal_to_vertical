#!/bin/bash

# Build script for Excel Converter
# Builds executables for all platforms

set -e

echo "🔨 Building Excel Converter for all platforms..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create output directory
mkdir -p build
rm -rf build/*

echo -e "${BLUE}Cleaning up old builds...${NC}"
rm -f excel_converter excel_converter.exe excel_converter_macos_intel excel_converter_macos_arm64 excel_converter_linux

# Windows
echo -e "${BLUE}Building for Windows (x64)...${NC}"
GOOS=windows GOARCH=amd64 go build -o build/excel_converter.exe
echo -e "${GREEN}✓ Windows build complete${NC}"
ls -lh build/excel_converter.exe

# macOS Intel
echo -e "${BLUE}Building for macOS (Intel)...${NC}"
GOOS=darwin GOARCH=amd64 go build -o build/excel_converter_macos_intel
echo -e "${GREEN}✓ macOS Intel build complete${NC}"
ls -lh build/excel_converter_macos_intel

# macOS Apple Silicon
echo -e "${BLUE}Building for macOS (Apple Silicon/M1/M2/M3)...${NC}"
GOOS=darwin GOARCH=arm64 go build -o build/excel_converter_macos_arm64
echo -e "${GREEN}✓ macOS Apple Silicon build complete${NC}"
ls -lh build/excel_converter_macos_arm64

# Linux
echo -e "${BLUE}Building for Linux (x64)...${NC}"
GOOS=linux GOARCH=amd64 go build -o build/excel_converter_linux
echo -e "${GREEN}✓ Linux build complete${NC}"
ls -lh build/excel_converter_linux

# Copy supporting files
echo -e "${BLUE}Copying supporting files...${NC}"
cp convert.bat build/
cp README.md build/
cp HOW_TO_SHARE.md build/
echo -e "${GREEN}✓ Files copied${NC}"

# Create checksums
echo -e "${BLUE}Creating SHA256 checksums...${NC}"
cd build
sha256sum * > SHA256SUMS
cd ..
echo -e "${GREEN}✓ Checksums created${NC}"

# Summary
echo ""
echo -e "${GREEN}✅ Build complete!${NC}"
echo ""
echo "Files ready in: build/"
echo ""
ls -lh build/
echo ""
echo "Checksums:"
cat build/SHA256SUMS
echo ""
echo "Ready to:"
echo "  1. Test the executables"
echo "  2. Push to GitHub: git push origin main"
echo "  3. Create a release tag: git tag v1.0.0 && git push origin v1.0.0"
