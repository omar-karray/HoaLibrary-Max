# Quick Release Commands

Copy-paste these commands to push and release!

## 1️⃣ First Time Setup (if not done)

```bash
cd /Users/omarkarray/DevRepos/MaxMSP_development/HoaLibrary-Max

# Set up your GitHub remote
git remote add origin https://github.com/omar-karray/HoaLibrary-Max.git

# Or if you already have it:
git remote set-url origin https://github.com/omar-karray/HoaLibrary-Max.git
```

## 2️⃣ Quick Release (Automated with GitHub Actions)

```bash
# Add and commit all your changes
git add .
git commit -m "Release v3.0.0: Max 9 with Apple Silicon support"

# Push to your branch
git push origin fix/hoalibrary-cpp-modernization

# Create and push tag (this triggers automatic build & release!)
git tag -a v3.0.0 -m "HoaLibrary v3.0.0 for Max 9 - Universal Binary"
git push origin v3.0.0
```

**Done!** GitHub will automatically build and create the release.  
Watch progress at: https://github.com/omar-karray/HoaLibrary-Max/actions

## 3️⃣ Alternative: Push to Master First

```bash
# Add and commit
git add .
git commit -m "Release v3.0.0: Max 9 with Apple Silicon support"

# Push your branch
git push origin fix/hoalibrary-cpp-modernization

# Merge to master (via GitHub or locally)
git checkout master
git merge fix/hoalibrary-cpp-modernization
git push origin master

# Tag the release
git tag -a v3.0.0 -m "HoaLibrary v3.0.0 for Max 9"
git push origin v3.0.0
```

## 4️⃣ Manual Release (No GitHub Actions)

```bash
# Build locally
cd build && cmake --build . -j8 && cd ..

# Create release package
./create_release.sh

# Commit and push
git add .
git commit -m "Release v3.0.0"
git push origin master

# Create tag
git tag -a v3.0.0 -m "Release v3.0.0"
git push origin v3.0.0

# Then manually upload releases/HoaLibrary-Mac-v3.0.0.zip to:
# https://github.com/omar-karray/HoaLibrary-Max/releases/new
```

## ⚡️ ONE-LINER (if everything is ready)

```bash
cd /Users/omarkarray/DevRepos/MaxMSP_development/HoaLibrary-Max && \
git add . && \
git commit -m "Release v3.0.0: Max 9 with Apple Silicon support" && \
git push origin fix/hoalibrary-cpp-modernization && \
git tag -a v3.0.0 -m "HoaLibrary v3.0.0 for Max 9 - Universal Binary" && \
git push origin v3.0.0
```

## 🔧 Common Commands

### Check what will be committed
```bash
git status
git diff
```

### View existing tags
```bash
git tag -l
```

### Delete a tag (if you made a mistake)
```bash
git tag -d v3.0.0                    # Delete locally
git push origin :refs/tags/v3.0.0   # Delete on GitHub
```

### View commit history
```bash
git log --oneline -10
```

### Check remote URL
```bash
git remote -v
```

## 🎯 For Next Release (v3.0.1, v3.1.0, etc.)

```bash
# Make your changes...

# Update version numbers in:
# - create_release.sh (VERSION variable)
# - package-info.json (version field)

# Build and test
cd build && cmake --build . -j8 && cd ..
./create_release.sh

# Commit, tag, and push
git add .
git commit -m "Release v3.0.1: Bug fixes"
git tag -a v3.0.1 -m "Bug fix release"
git push origin master
git push origin v3.0.1
```

---

**Tip**: Always test locally with `./create_release.sh` before pushing a tag! ✅
