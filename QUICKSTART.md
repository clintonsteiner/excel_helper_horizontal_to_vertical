# Quick Start - CI/CD Setup

Get your Excel Converter builds automated on GitHub in 5 minutes.

## 📋 What You Have

✅ Complete Go application (main.go)
✅ GitHub Actions CI/CD pipeline (.github/workflows/build-release.yml)
✅ Automated builds for Windows, macOS (Intel & ARM64), and Linux
✅ Makefile for local building
✅ Pre-built executables ready to use

## 🚀 Get Started (3 Steps)

### Step 1: Create GitHub Repository

```bash
# Go to https://github.com/new
# Name: excel-converter
# Description: Excel format converter (horizontal to vertical)
# Public (so others can use it)
# Don't initialize with README
```

### Step 2: Push Your Code

```bash
cd /Users/cs/git/excel_helper_horizontal_to_vertical

# Configure git
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Initialize and push
git add .
git commit -m "Initial commit: Excel converter with CI/CD"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/excel-converter.git
git push -u origin main
```

### Step 3: Verify GitHub Actions

1. Go to your GitHub repository
2. Click "Actions" tab
3. Should see "Build and Release" workflow
4. That's it! ✅

## 📦 Create Your First Release

### Option A: Quick Release (Recommended)

```bash
# Tag your release
git tag v1.0.0

# Push the tag
git push origin v1.0.0

# Wait 2-3 minutes...
# Release automatically created on GitHub!
```

### Option B: Manual Release on GitHub

1. Go to repository → "Releases" → "Draft a new release"
2. Tag: `v1.0.0`
3. Title: `Excel Converter v1.0.0`
4. Click "Publish release"

## 🔨 Build Locally (Optional)

Build all platforms on your computer:

```bash
# Build for all platforms
make build-all

# Clean up
make clean

# See all options
make help
```

## 📥 Download Releases

Share this link with friends:
```
https://github.com/YOUR_USERNAME/excel-converter/releases
```

## 📋 Release Contents

Each release includes:
- Windows executable (.exe)
- macOS executables (Intel & Apple Silicon)
- Linux executable
- Batch script (convert.bat)
- Documentation (README.md)
- SHA256 checksums

## 🔄 Workflow

Every time you:
1. Push code to `main` branch
2. Or create a release tag (v1.0.0, v1.0.1, etc.)

GitHub Actions automatically:
1. ✅ Builds for all 4 platforms
2. ✅ Creates release
3. ✅ Uploads all files
4. ✅ Generates checksums

No more manual builds! 🎉

## 📝 Making Updates

To release an update:

```bash
# Make changes
# ... edit code ...

# Test locally
make build

# Commit
git add .
git commit -m "Fix: improve performance"

# Push
git push origin main

# Create new release
git tag v1.0.1
git push origin v1.0.1

# Done! Release created automatically
```

## 📂 Project Structure

```
excel-converter/
├── main.go                  # Application source
├── go.mod                   # Dependencies
├── go.sum                   # Dependency checksums
├── Makefile                 # Build automation
├── convert.bat              # Windows batch script
├── README.md                # Usage instructions
├── HOW_TO_SHARE.md          # Sharing guide
├── CI_SETUP.md              # CI/CD detailed guide
├── DEVELOPMENT.md           # Development guide
├── .github/
│   └── workflows/
│       └── build-release.yml # GitHub Actions CI/CD
└── .gitignore               # Git ignore rules
```

## 🛠️ Common Tasks

### Build locally
```bash
make build-all
```

### Clean artifacts
```bash
make clean
```

### Test code
```bash
make test
```

### Format code
```bash
make fmt
```

### See all commands
```bash
make help
```

## 🔗 Share with Friends

Send them one of these links:

**Direct download:**
```
https://github.com/YOUR_USERNAME/excel-converter/releases/latest
```

**Releases page:**
```
https://github.com/YOUR_USERNAME/excel-converter/releases
```

## ✅ Verify Setup

Run this to verify everything works:

```bash
# Check make is installed
make --version

# Check Go is installed
go version

# List project files
ls -la

# Verify Makefile works
make help

# See .gitignore
cat .gitignore
```

## 🚨 Troubleshooting

**Workflow doesn't run:**
- Check it's committed: `git log --oneline | head`
- Check it's pushed: `git status`
- Wait a moment, refresh Actions tab

**Build fails:**
- Check Go version: `go version` (should be 1.21+)
- Test locally: `make build`
- Check error in Actions tab logs

**Release not created:**
- Check tag was created: `git tag -l`
- Check tag was pushed: `git push origin TAG_NAME`
- Check workflow completed (green checkmark in Actions)

## 📚 Learn More

- See **DEVELOPMENT.md** for detailed development guide
- See **CI_SETUP.md** for detailed CI/CD guide
- See **README.md** for usage instructions

## 🎉 You're Done!

Your Excel Converter now has:
- ✅ Automated builds
- ✅ Cross-platform support
- ✅ Easy releases
- ✅ Shareable downloads

Push code → Builds automatically → Share releases!

---

**Next steps:**
1. Make a test push
2. Create your first release tag
3. Share the releases link with friends

Happy coding! 🚀
