# CI/CD Setup Guide

This document explains how to set up GitHub Actions CI/CD for automatic building and releasing of the Excel Converter.

## What's Included

The CI/CD pipeline automatically:
1. **Builds** the executable for multiple platforms:
   - Windows (x64)
   - macOS (Intel)
   - macOS (Apple Silicon/M1/M2/M3)
   - Linux (x64)

2. **Creates artifacts** including:
   - Compiled executables for all platforms
   - Batch script (convert.bat)
   - Documentation (README.md, HOW_TO_SHARE.md)
   - SHA256 checksums for integrity verification

3. **Publishes releases** to GitHub with all files

## Initial Setup

### Step 1: Create a GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Create a new repository: `excel-converter` (or your preferred name)
3. Choose:
   - Public or Private (public recommended for open source)
   - Do NOT initialize with README (we have one already)
4. Click "Create repository"

### Step 2: Push Code to GitHub

```bash
# Navigate to your project directory
cd /Users/cs/git/excel_helper_horizontal_to_vertical

# Add remote origin (replace USERNAME and REPO with your values)
git remote add origin https://github.com/USERNAME/REPO.git

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Excel converter with CI/CD setup"

# Push to GitHub (use 'main' as default branch)
git branch -M main
git push -u origin main
```

### Step 3: Verify GitHub Actions Setup

1. Go to your GitHub repository
2. Click the "Actions" tab
3. The "Build and Release" workflow should appear
4. No additional configuration needed - GitHub automatically enables Actions!

## How the CI/CD Pipeline Works

### Trigger Events

The workflow runs automatically when:
1. **Code is pushed to `main` or `master` branch** with changes to:
   - `main.go`
   - `go.mod` or `go.sum`
   - `.github/workflows/build-release.yml`

2. **Manually triggered** via the GitHub Actions UI

3. **A release is published** on GitHub

### Workflow Steps

1. **Checkout** - Clones the latest code
2. **Setup Go** - Installs Go 1.21
3. **Build** - Compiles executables for 4 platforms
4. **Version** - Creates version tag (from git tags or timestamp)
5. **Package** - Copies all files to release directory
6. **Create Checksums** - Generates SHA256 hashes
7. **Upload Artifacts** - Saves builds to Actions (30-day retention)
8. **Create Release** - Publishes to GitHub Releases

## Using Releases

### Finding Releases

1. Go to your GitHub repository
2. Click "Releases" on the right sidebar
3. Download files from the latest release

### Version Tags

To create a proper release version:

```bash
# Create a git tag
git tag v1.0.0

# Push the tag to GitHub
git push origin v1.0.0
```

The release will automatically use the tag name.

### Manual Release

If you want to manually trigger a build:
1. Go to "Actions" tab
2. Click "Build and Release" workflow
3. Click "Run workflow"
4. Click "Run workflow" button

## Release Assets

Each release includes:

| File | Size | Purpose |
|------|------|---------|
| excel_converter.exe | ~8.5 MB | Windows executable |
| excel_converter_macos_intel | ~8.1 MB | macOS Intel executable |
| excel_converter_macos_arm64 | ~8.1 MB | macOS Apple Silicon executable |
| excel_converter_linux | ~8.2 MB | Linux executable |
| convert.bat | ~1.4 KB | Windows batch script |
| README.md | ~6.9 KB | Usage instructions |
| HOW_TO_SHARE.md | ~6.5 KB | Distribution guide |
| SHA256SUMS | ~300 B | Checksum verification file |

## Verification

Users can verify downloaded files using checksums:

```bash
# Download SHA256SUMS from the release
# Then run:
sha256sum -c SHA256SUMS

# Expected output:
# excel_converter.exe: OK
# excel_converter_macos_intel: OK
# etc.
```

## Customization

### Changing Build Platforms

Edit `.github/workflows/build-release.yml`:

```yaml
# Add or modify build steps, e.g., for ARM64 Windows:
- name: Build Windows ARM64 executable
  run: |
    GOOS=windows GOARCH=arm64 go build -o excel_converter_arm64.exe
```

### Changing Go Version

Modify the Go version in the workflow:

```yaml
- uses: actions/setup-go@v4
  with:
    go-version: '1.22'  # Change this version
```

### Changing Release Notes

Edit the release body in the workflow file under the "Create Release" step.

### Automatic Release to Production

To deploy to a production server, add additional steps to the workflow (requires additional setup).

## Troubleshooting

### Workflow doesn't run

**Check:**
1. The workflow file is in `.github/workflows/` directory
2. You've committed and pushed changes to `main` or `master`
3. Go to "Actions" tab to see workflow runs
4. Check workflow logs for errors

### Build fails

**Check:**
1. Go version compatibility
2. Dependencies are properly listed in `go.mod`
3. Source code compiles locally with `go build`

### Release not created

**Check:**
1. Workflow ran successfully (no red errors in Actions)
2. GitHub token has proper permissions (usually automatic)
3. Repository settings allow releases

### Files missing from release

**Check:**
1. Files exist in the source code
2. File paths in the workflow are correct
3. The "Create Release" step ran successfully

## Security

### Token Permissions

The workflow uses `GITHUB_TOKEN` which is automatically provided and scoped to:
- Create releases
- Upload assets
- No access to other repositories

### Secrets

Currently, the workflow doesn't require any manual secrets. To add secrets (for deployment, etc.):

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add your secret name and value
4. Use in workflow: `${{ secrets.SECRET_NAME }}`

## Updating the Workflow

To update the workflow:

1. Edit `.github/workflows/build-release.yml`
2. Commit and push to main
3. New versions will use the updated workflow

## Next Steps

1. **Push to GitHub** - Follow "Initial Setup" section
2. **Create a Release** - Tag a commit and push:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. **Share** - Send friends the GitHub Releases URL:
   ```
   https://github.com/USERNAME/REPO/releases
   ```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Go Build Constraints](https://golang.org/doc/install/source#environment)
- [GitHub Releases API](https://docs.github.com/en/rest/releases)

---

**Questions?** Check your workflow logs in the "Actions" tab of your GitHub repository for detailed error messages.
