# How to Push and Release on GitHub

## Quick Start - Create Your First Release

### Step 1: Commit Your Changes

```bash
cd /Users/omarkarray/DevRepos/MaxMSP_development/HoaLibrary-Max

# Add all your changes
git add .

# Commit with a descriptive message
git commit -m "Release v3.0.0: Max 9 with Apple Silicon support

- Fixed C++ compilation for modern compilers
- Updated to Max SDK 8.2.0
- Universal Binary externals (x86_64 + arm64)
- All 37 externals building successfully
- Created modern CMake build system
- Added GitHub Actions workflow for releases"
```

### Step 2: Push to GitHub

```bash
# If you haven't set up your remote yet:
git remote add origin https://github.com/omar-karray/HoaLibrary-Max.git

# Push your branch
git push origin fix/hoalibrary-cpp-modernization
```

### Step 3: Merge to Master (if you want)

**Option A: Via GitHub UI (Recommended)**
1. Go to: https://github.com/omar-karray/HoaLibrary-Max
2. Click "Compare & pull request"
3. Review changes
4. Click "Merge pull request"
5. Confirm merge to master

**Option B: Via Command Line**
```bash
# Switch to master
git checkout master

# Pull latest changes
git pull origin master

# Merge your branch
git merge fix/hoalibrary-cpp-modernization

# Push to master
git push origin master
```

### Step 4: Create and Push a Release Tag

```bash
# Make sure you're on the branch you want to release (master or your branch)
git checkout master  # or: git checkout fix/hoalibrary-cpp-modernization

# Create an annotated tag
git tag -a v3.0.0 -m "HoaLibrary v3.0.0 for Max 9

- Universal Binary for Intel and Apple Silicon
- Max 9 and Max SDK 8.2.0 compatible
- 37 externals fully working
- Complete documentation and examples"

# Push the tag to GitHub
git push origin v3.0.0
```

**🎉 That's it!** The GitHub Action will automatically:
1. Build all externals
2. Verify they're Universal Binary
3. Create the release package
4. Create a GitHub release with the download

### Step 5: Monitor the Build

1. Go to: https://github.com/omar-karray/HoaLibrary-Max/actions
2. You'll see the workflow running
3. Wait for it to complete (takes ~10-15 minutes)
4. Once complete, check: https://github.com/omar-karray/HoaLibrary-Max/releases

## Alternative: Manual Release (No GitHub Actions)

If you want to create a release manually without the workflow:

### 1. Build and Package Locally
```bash
cd /Users/omarkarray/DevRepos/MaxMSP_development/HoaLibrary-Max

# Build everything
cd build && cmake --build . -j8 && cd ..

# Create release package
./create_release.sh
```

### 2. Commit and Tag
```bash
git add .
git commit -m "Release v3.0.0 for Max 9"
git push origin master
git tag -a v3.0.0 -m "Release v3.0.0"
git push origin v3.0.0
```

### 3. Create Release on GitHub
1. Go to: https://github.com/omar-karray/HoaLibrary-Max/releases/new
2. Select tag: `v3.0.0`
3. Title: `HoaLibrary v3.0.0 for Max 9`
4. Description: Copy from `RELEASE_NOTES.md`
5. Upload: `releases/HoaLibrary-Mac-v3.0.0.zip`
6. Click "Publish release"

## Version Numbering

For future releases:

- **Major** (v4.0.0): Breaking changes, major new features
- **Minor** (v3.1.0): New features, backward compatible
- **Patch** (v3.0.1): Bug fixes only

Examples:
```bash
# Bug fix release
git tag -a v3.0.1 -m "Fix audio processing bug"

# New features
git tag -a v3.1.0 -m "Add new 3D spatialization modes"

# Major version
git tag -a v4.0.0 -m "Complete rewrite for Max 10"
```

## Managing Releases

### List all tags
```bash
git tag -l
```

### Delete a tag (if you made a mistake)
```bash
# Delete locally
git tag -d v3.0.0

# Delete on GitHub
git push origin :refs/tags/v3.0.0
```

### Update release notes on GitHub
1. Go to: https://github.com/omar-karray/HoaLibrary-Max/releases
2. Click on your release
3. Click "Edit release"
4. Update description
5. Click "Update release"

## Troubleshooting

### If the GitHub Action fails:

1. **Check the logs**:
   - Go to: https://github.com/omar-karray/HoaLibrary-Max/actions
   - Click on the failed workflow
   - Read the error messages

2. **Common issues**:
   - Max SDK download link changed → Update in `.github/workflows/release.yml`
   - Build errors → Test locally first with `./create_release.sh`
   - Permission issues → Check repository settings

3. **Test locally first**:
   ```bash
   # Always test before pushing a tag
   ./create_release.sh
   ```

### If you need to re-release:

```bash
# Delete the tag
git tag -d v3.0.0
git push origin :refs/tags/v3.0.0

# Delete the release on GitHub (via web UI)
# Go to releases, click the release, click "Delete"

# Fix your code, commit, and create tag again
git tag -a v3.0.0 -m "Release v3.0.0"
git push origin v3.0.0
```

## What Gets Pushed

```
Your GitHub Repository
├── .github/workflows/release.yml   [GitHub Action]
├── CMakeLists.txt                  [Build config]
├── Package/HoaLibrary/             [Source package]
├── Max2D/                          [Source code]
├── Max3D/                          [Source code]
├── MaxCommon/                      [Source code]
├── ThirdParty/HoaLibrary/          [C++ library]
├── build/                          [Not pushed - in .gitignore]
├── releases/                       [Not pushed - in .gitignore]
├── BUILD.md                        [Documentation]
├── RELEASE_NOTES.md               [Documentation]
├── install.sh                     [User script]
├── create_release.sh              [Build script]
└── README.md                      [Main docs]
```

## Pro Tips

1. **Test before tagging**: Always run `./create_release.sh` locally first

2. **Use semantic versioning**: v3.0.0 is better than v3 or 3.0

3. **Write good release notes**: Users appreciate knowing what changed

4. **Tag from master**: Keep master stable, tag releases from there

5. **Keep tags permanent**: Don't delete tags once they're public

## Next Steps After Release

1. **Test the download**: Download your release and install it
2. **Announce**: Share on Max forums, social media, etc.
3. **Monitor issues**: Watch for bug reports
4. **Plan next release**: Start tracking new features/fixes

---

**Ready to release!** Just follow Step 1-4 above. 🚀
