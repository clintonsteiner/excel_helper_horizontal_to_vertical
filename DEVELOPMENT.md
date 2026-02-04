# Development and CI/CD Guide

Complete guide for building, testing, and releasing the Excel Converter.

## Table of Contents

1. [Local Development](#local-development)
2. [Building](#building)
3. [Testing](#testing)
4. [GitHub Setup](#github-setup)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Releasing](#releasing)
7. [Troubleshooting](#troubleshooting)

---

## Local Development

### Prerequisites

- **Go 1.21+** - [Download](https://golang.org/dl/)
- **Make** (optional, but recommended)
  - macOS/Linux: Usually pre-installed
  - Windows: Use [GNU Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm) or [chocolatey](https://chocolatey.org/)
- **Git** - [Download](https://git-scm.com/)

### Setup

```bash
# Clone the repository
git clone https://github.com/USERNAME/excel-converter.git
cd excel-converter

# Download dependencies
go mod download
# or: make deps
```

### IDE Setup

**VS Code:**
- Install "Go" extension by Go Team
- Create `.vscode/settings.json`:
  ```json
  {
    "go.lintOnSave": "package",
    "[go]": {
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit"
      }
    }
  }
  ```

**GoLand/IntelliJ IDEA:**
- Built-in Go support
- Settings → Go → Enable Go Modules

---

## Building

### Using Makefile (Recommended)

```bash
# Show all available targets
make help

# Build for current platform
make build

# Build for all platforms
make build-all

# Build specific platform
make build-windows
make build-macos-intel
make build-macos-arm64
make build-linux

# Clean build artifacts
make clean

# Create packaged build directory
make package
```

### Using Scripts

**macOS/Linux:**
```bash
chmod +x build.sh
./build.sh
```

**Windows:**
```batch
build.bat
```

### Manual Go Build

```bash
# Build for current platform
go build -o excel_converter

# Build for Windows
GOOS=windows GOARCH=amd64 go build -o excel_converter.exe

# Build for macOS Intel
GOOS=darwin GOARCH=amd64 go build -o excel_converter_macos_intel

# Build for macOS Apple Silicon
GOOS=darwin GOARCH=arm64 go build -o excel_converter_macos_arm64

# Build for Linux
GOOS=linux GOARCH=amd64 go build -o excel_converter_linux
```

---

## Testing

### Run Tests

```bash
# Run all tests
make test
# or
go test ./...

# Run with verbose output
go test -v ./...

# Run with coverage
go test -cover ./...

# Generate coverage report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Format Code

```bash
# Format code
make fmt
# or
go fmt ./...

# Run Go vet (static analysis)
make vet
# or
go vet ./...
```

### Lint Code

```bash
# Run linter (requires golangci-lint)
make lint

# Install golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### Test Binary

```bash
# Build and test executable
make run

# Or manually test
./excel_converter "test_file.xlsx"
./excel_converter -output newfile "test_file.xlsx"
./excel_converter -sheet "Custom Sheet Name" "test_file.xlsx"
```

---

## GitHub Setup

### 1. Create Repository

```bash
# If starting fresh
git init
git add .
git commit -m "Initial commit"

# If repo already exists
git remote add origin https://github.com/USERNAME/excel-converter.git
git branch -M main
git push -u origin main
```

### 2. Enable GitHub Actions

No configuration needed! GitHub automatically enables Actions when it detects the workflow file.

**Verify:**
1. Go to your GitHub repository
2. Click "Actions" tab
3. Should see "Build and Release" workflow

### 3. Configure Release Permissions

The workflow uses `GITHUB_TOKEN` which is automatically configured. No additional setup required.

---

## CI/CD Pipeline

### How It Works

**Trigger Events:**
1. Push to `main` or `master` branch with code changes
2. Manual trigger via GitHub Actions UI
3. Published release (automatic)

**Workflow:**
```
Code Push
    ↓
Checkout Code
    ↓
Setup Go Environment
    ↓
Build Windows Executable
    ↓
Build macOS Executables (2)
    ↓
Build Linux Executable
    ↓
Create Version Tag
    ↓
Package Files
    ↓
Generate Checksums
    ↓
Upload Artifacts (30-day retention)
    ↓
Create GitHub Release
    ↓
Release Published
```

### Workflow File

Location: `.github/workflows/build-release.yml`

Key sections:
- **on**: Defines trigger events
- **jobs**: Build jobs
- **steps**: Individual build steps
- **release**: GitHub Release creation

### Manual Trigger

```bash
# Via GitHub CLI (if installed)
gh workflow run build-release.yml

# Or via GitHub UI:
# 1. Go to Actions tab
# 2. Click "Build and Release"
# 3. Click "Run workflow"
# 4. Select branch and click "Run"
```

---

## Releasing

### Creating a Release

#### Method 1: Git Tags (Recommended)

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to GitHub
git push origin v1.0.0

# CI/CD pipeline automatically:
# 1. Builds all platforms
# 2. Creates release with tag name
# 3. Uploads all files
```

#### Method 2: GitHub Releases UI

1. Go to repository → "Releases"
2. Click "Draft a new release"
3. Tag version: `v1.0.0`
4. Release title: `Excel Converter v1.0.0`
5. Click "Generate release notes" (auto-populate)
6. Click "Publish release"

#### Method 3: GitHub CLI

```bash
# Requires gh CLI: https://cli.github.com/

gh release create v1.0.0 \
  --title "Excel Converter v1.0.0" \
  --notes "Release notes here"
```

### Release Checklist

Before releasing:

- [ ] Code changes committed
- [ ] Tests passing locally: `make test`
- [ ] Code formatted: `make fmt`
- [ ] No linting errors: `make vet`
- [ ] Builds locally: `make build-all`
- [ ] README.md updated if needed
- [ ] Version bumped in code comments (if applicable)
- [ ] CHANGELOG updated (optional)

### Semantic Versioning

Version format: `v{MAJOR}.{MINOR}.{PATCH}`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

Examples: `v1.0.0`, `v1.2.3`, `v2.0.0-beta1`

### Release Notes Template

```markdown
# Excel Converter v1.0.0

## New Features
- Feature 1
- Feature 2

## Bug Fixes
- Fix 1
- Fix 2

## Breaking Changes
- Change 1

## Installation
Download from [releases page](https://github.com/USERNAME/excel-converter/releases)

## Files
- `excel_converter.exe` - Windows
- `excel_converter_macos_intel` - macOS (Intel)
- `excel_converter_macos_arm64` - macOS (M1/M2/M3)
- `excel_converter_linux` - Linux

Verify downloads:
```bash
sha256sum -c SHA256SUMS
```
```

---

## Troubleshooting

### Build Issues

**Error: "command not found: make"**
- Install Make (see Prerequisites section)
- Or use `go build` directly

**Error: "go: command not found"**
- Install Go 1.21+ from https://golang.org/dl/

**Build fails with "undefined: something"**
- Run `go mod tidy` to update dependencies
- Check Go version: `go version`

### GitHub Actions Issues

**Workflow doesn't run**

Check:
1. Workflow file exists: `.github/workflows/build-release.yml`
2. File is valid YAML (use online YAML validator)
3. Pushed to `main` or `master` branch
4. Code changes made to tracked files

**Release not created**

Check:
1. Workflow completed successfully (green checkmark)
2. Version tag created: `git tag -l`
3. Tag pushed to remote: `git push origin TAG_NAME`

**Missing files in release**

Check:
1. Files exist in source directory
2. File paths correct in workflow
3. Build step completed successfully

### Common Errors

**"GOOS=windows: command not found"**
- On Windows, use `set` instead of export
- Better: Use Makefile or go build directly

**"No such file or directory"**
- Check file paths in workflow
- Verify files exist: `ls -la build/`

**"Permission denied"**
- On macOS/Linux: `chmod +x build.sh`
- Ensure workflow has permission (automatic)

---

## Best Practices

### Commits

```bash
# Good commit messages
git commit -m "Add feature X"
git commit -m "Fix bug in Y"
git commit -m "Update documentation"

# Include scope if helpful
git commit -m "build: update Go to 1.22"
git commit -m "docs: add CI setup guide"
```

### Branches

```bash
# Create feature branch
git checkout -b feature/my-feature

# Work on feature
# Commit changes
# Push to GitHub
git push origin feature/my-feature

# Create Pull Request on GitHub
# After review and merge, delete branch
```

### Testing

- Always test locally before pushing
- Run `make test` before committing
- Test manual functionality with real Excel files

### Version Management

Keep semantic versioning:
1. `v0.1.0` - Initial release
2. `v0.2.0` - New features
3. `v1.0.0` - Major release
4. `v1.0.1` - Bug fix
5. `v1.1.0` - New features

---

## Development Workflow

### Daily Development

```bash
# Start of day
git pull origin main

# Make changes
# ... edit code ...

# Build and test
make build-all
make test

# Commit
git add .
git commit -m "Your commit message"

# Push
git push origin main
```

### Before Releasing

```bash
# Ensure everything is clean
make clean

# Build everything
make build-all

# Run tests
make test

# Format code
make fmt

# Check linting
make vet

# Tag and push
git tag v1.0.0
git push origin v1.0.0
```

---

## Resources

- [Go Official Documentation](https://golang.org/doc/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Makefile Tutorial](https://www.gnu.org/software/make/manual/)
- [Git Documentation](https://git-scm.com/doc)
- [Semantic Versioning](https://semver.org/)

---

## Support

For issues:
1. Check this guide's troubleshooting section
2. Review GitHub Actions logs: Go to Actions → workflow run
3. Check error messages carefully
4. Search GitHub issues in repository

---

**Happy developing!** 🚀
