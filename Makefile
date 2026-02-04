.PHONY: help build build-windows build-macos build-macos-intel build-macos-arm64 build-linux build-all clean test install

# Default target
help:
	@echo "Excel Converter Build Targets"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help              Show this help message"
	@echo "  build             Build for current platform"
	@echo "  build-all         Build for all platforms (Windows, macOS, Linux)"
	@echo "  build-windows     Build for Windows (x64)"
	@echo "  build-macos       Build for macOS (both Intel and Apple Silicon)"
	@echo "  build-macos-intel Build for macOS (Intel x64)"
	@echo "  build-macos-arm64 Build for macOS (Apple Silicon/M1/M2/M3)"
	@echo "  build-linux       Build for Linux (x64)"
	@echo "  clean             Remove build artifacts"
	@echo "  test              Run Go tests"
	@echo "  install           Install executable locally"
	@echo "  package           Create build directory with all files"
	@echo "  checksums         Generate SHA256 checksums"
	@echo ""
	@echo "Examples:"
	@echo "  make build-all                # Build for all platforms"
	@echo "  make build-windows            # Build Windows executable only"
	@echo "  make clean                    # Remove all build artifacts"

# Build for current platform
build:
	@echo "Building Excel Converter for current platform..."
	go build -o excel_converter
	@echo "✓ Build complete"

# Build for all platforms
build-all: clean build-windows build-macos-intel build-macos-arm64 build-linux package
	@echo ""
	@echo "✅ All builds complete!"
	@echo ""
	@echo "Files ready in: build/"
	@ls -lh build/
	@echo ""
	@echo "Checksums:"
	@cat build/SHA256SUMS

# Build for Windows
build-windows:
	@echo "Building for Windows (x64)..."
	@GOOS=windows GOARCH=amd64 go build -o build/excel_converter.exe
	@ls -lh build/excel_converter.exe
	@echo "✓ Windows build complete"

# Build for macOS (both versions)
build-macos: build-macos-intel build-macos-arm64

# Build for macOS Intel
build-macos-intel:
	@echo "Building for macOS (Intel)..."
	@GOOS=darwin GOARCH=amd64 go build -o build/excel_converter_macos_intel
	@ls -lh build/excel_converter_macos_intel
	@echo "✓ macOS Intel build complete"

# Build for macOS Apple Silicon
build-macos-arm64:
	@echo "Building for macOS (Apple Silicon/M1/M2/M3)..."
	@GOOS=darwin GOARCH=arm64 go build -o build/excel_converter_macos_arm64
	@ls -lh build/excel_converter_macos_arm64
	@echo "✓ macOS Apple Silicon build complete"

# Build for Linux
build-linux:
	@echo "Building for Linux (x64)..."
	@GOOS=linux GOARCH=amd64 go build -o build/excel_converter_linux
	@ls -lh build/excel_converter_linux
	@echo "✓ Linux build complete"

# Package all files
package: clean build-windows build-macos-intel build-macos-arm64 build-linux
	@echo "Packaging files..."
	@mkdir -p build
	@cp convert.bat build/
	@cp README.md build/
	@cp HOW_TO_SHARE.md build/
	@cp CI_SETUP.md build/
	@echo "✓ All files packaged"

# Generate checksums
checksums:
	@echo "Creating SHA256 checksums..."
	@cd build && sha256sum * > SHA256SUMS && cd ..
	@echo "✓ Checksums created:"
	@cat build/SHA256SUMS

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -f excel_converter excel_converter.exe excel_converter_macos_* excel_converter_linux
	@rm -rf build
	@echo "✓ Clean complete"

# Run tests
test:
	@echo "Running tests..."
	@go test -v ./...
	@echo "✓ Tests complete"

# Install executable locally
install: build
	@echo "Installing excel_converter..."
	@go install
	@echo "✓ Installation complete"
	@echo "You can now run: excel_converter <file.xlsx>"

# Development target - build with race detector
dev: clean
	@echo "Building with race detector..."
	@go build -race -o excel_converter
	@echo "✓ Development build complete"

# Format code
fmt:
	@echo "Formatting code..."
	@go fmt ./...
	@echo "✓ Code formatted"

# Run linter (requires golangci-lint)
lint:
	@echo "Running linter..."
	@golangci-lint run ./... || echo "Note: golangci-lint not installed"

# Vet code
vet:
	@echo "Running go vet..."
	@go vet ./...
	@echo "✓ Vet complete"

# Build and run with test file
run: build
	@echo "Running excel_converter..."
	@./excel_converter -h

# Show Go version
version:
	@echo "Go version:"
	@go version

# Download dependencies
deps:
	@echo "Downloading dependencies..."
	@go mod download
	@echo "✓ Dependencies downloaded"

# Update dependencies
update-deps:
	@echo "Updating dependencies..."
	@go get -u ./...
	@go mod tidy
	@echo "✓ Dependencies updated"

# Generate GitHub release notes
release-notes:
	@echo "Creating release notes..."
	@echo "# Excel Converter Release Notes" > RELEASE_NOTES.md
	@echo "" >> RELEASE_NOTES.md
	@echo "## Files Included" >> RELEASE_NOTES.md
	@echo "- excel_converter.exe - Windows executable" >> RELEASE_NOTES.md
	@echo "- excel_converter_macos_intel - macOS Intel executable" >> RELEASE_NOTES.md
	@echo "- excel_converter_macos_arm64 - macOS Apple Silicon executable" >> RELEASE_NOTES.md
	@echo "- excel_converter_linux - Linux executable" >> RELEASE_NOTES.md
	@echo "- convert.bat - Windows batch script" >> RELEASE_NOTES.md
	@echo "- README.md - Usage instructions" >> RELEASE_NOTES.md
	@echo "- HOW_TO_SHARE.md - Distribution guide" >> RELEASE_NOTES.md
	@echo "- SHA256SUMS - Checksums for verification" >> RELEASE_NOTES.md
	@cat RELEASE_NOTES.md
	@echo "✓ Release notes created"

.DEFAULT_GOAL := help
