# GitHub Actions Workflows

This directory contains automated workflows for building and releasing HoaLibrary.

## Workflows

### `release.yml` - Build and Release

**Triggers:**
- Automatically when you push a version tag (e.g., `v3.0.0`)
- Manually from the Actions tab

**What it does:**
1. Checks out the repository
2. Downloads Max SDK 8.2.0
3. Builds all externals with CMake
4. Verifies all externals are Universal Binary (x86_64 + arm64)
5. Creates release package (.zip)
6. Creates GitHub release with downloadable package

**How to use:**
```bash
# Create and push a tag
git tag -a v3.0.0 -m "Release v3.0.0"
git push origin v3.0.0

# Watch the build at:
# https://github.com/YOUR_USERNAME/HoaLibrary-Max/actions
```

## Testing Locally

Before pushing a tag, test the build locally:

```bash
./create_release.sh
```

This runs the same steps as the GitHub Action.

## Troubleshooting

### Build fails in GitHub Actions

1. **Check the logs**: Click on the failed workflow run
2. **Common issues**:
   - Max SDK URL changed → Update `release.yml`
   - Build errors → Test locally first
   - Missing dependencies → Check step outputs

### Max SDK Download Issues

If the Max SDK URL in the workflow is outdated:

1. Find the current SDK URL at: https://cycling74.com/downloads
2. Update in `.github/workflows/release.yml`:
   ```yaml
   - name: Download Max SDK
     run: |
       curl -L -o max-sdk.zip https://NEW_SDK_URL_HERE
   ```

### Manual Workflow Trigger

You can trigger the build manually without creating a tag:

1. Go to: https://github.com/YOUR_USERNAME/HoaLibrary-Max/actions
2. Click "Build and Release HoaLibrary"
3. Click "Run workflow"
4. Select branch
5. Click "Run workflow"

This will build but won't create a release (useful for testing).

## Workflow Status Badge

Add this to your README.md to show build status:

```markdown
[![Build Status](https://github.com/YOUR_USERNAME/HoaLibrary-Max/actions/workflows/release.yml/badge.svg)](https://github.com/YOUR_USERNAME/HoaLibrary-Max/actions)
```

## Customizing the Workflow

### Change Max SDK Version

Edit the "Download Max SDK" step:
```yaml
curl -L -o max-sdk.zip https://cycling74.com/download/max-sdk-X.Y.Z
```

### Add Windows Build

Add a new job:
```yaml
build-windows:
  runs-on: windows-latest
  steps:
    # Similar steps but for Windows
```

### Test Before Release

Add a test job before releasing:
```yaml
test:
  needs: build-macos
  runs-on: macos-latest
  steps:
    - name: Download artifact
      uses: actions/download-artifact@v4
    - name: Test installation
      run: |
        # Add test commands
```

## Secrets and Permissions

The workflow uses `GITHUB_TOKEN` which is automatically provided by GitHub.

No additional secrets needed! ✅

## Build Times

Typical build times:
- **Total**: ~10-15 minutes
- Max SDK download: ~2 minutes
- CMake configure: ~30 seconds
- Build all externals: ~5-8 minutes
- Package creation: ~1 minute
- Upload: ~1 minute

## Cost

GitHub Actions is **free** for public repositories! 🎉

- Unlimited build minutes for public repos
- 2000 minutes/month for private repos

---

For more details, see [HOW_TO_RELEASE.md](../HOW_TO_RELEASE.md)
