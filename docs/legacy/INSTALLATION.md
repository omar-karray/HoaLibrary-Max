---
layout: default
title: Installation Guide
---

# Installation Guide - HoaLibrary for Max 9

## Quick Installation

### 1. Download

Download the latest release from:
**https://github.com/omar-karray/HoaLibrary-Max/releases/latest**

File: `HoaLibrary-Mac-v3.0.0.zip` (5.6 MB)

### 2. Extract

Double-click the zip file to extract it. You'll get a folder named `HoaLibrary`.

### 3. Install

Copy the `HoaLibrary` folder to:
```
~/Documents/Max 9/Packages/
```

Full path should be:
```
~/Documents/Max 9/Packages/HoaLibrary/
```

### 4. Restart Max

If Max is already running, quit and restart it.

### 5. Verify Installation

1. Open Max Console: **Window → Max Console**
2. Look for: `Package: HoaLibrary v3.0 loaded`
3. Create a new patcher
4. Type `n` and search for `hoa.2d.encoder~`
5. Object should be found and created

## System Requirements

- **Max**: 9.0 or higher
- **macOS**: 10.15 (Catalina) or higher
- **Processor**: Intel (x86_64) or Apple Silicon (arm64)
- **Disk Space**: ~50 MB

## Troubleshooting

### Objects not found

**Problem**: Max can't find HoaLibrary objects

**Solution**:
1. Check the folder is in the correct location:
   ```bash
   ls ~/Documents/Max\ 9/Packages/HoaLibrary/
   ```
2. Verify `externals` folder exists and contains .mxo files
3. Restart Max completely (Quit, not just close windows)
4. Check Max Console for error messages

### Package not loading

**Problem**: No message in Max Console about HoaLibrary

**Solution**:
1. Check `package-info.json` exists in the HoaLibrary folder
2. Verify folder permissions (should be readable)
3. Try Max → Options → File Preferences → Check "Refresh" packages

### Performance issues

**Problem**: Audio crackling or high CPU usage

**Solution**:
- Increase audio buffer size (Options → Audio Status)
- Check you're running native architecture (Console should show "arm64" on Apple Silicon)
- Reduce ambisonic order if using high orders (7+)

## Uninstallation

Simply remove the folder:
```bash
rm -rf ~/Documents/Max\ 9/Packages/HoaLibrary/
```

Then restart Max.

## Next Steps

- Open help files: Right-click any HoaLibrary object → "Open Help"
- Browse examples: `Package/HoaLibrary/extras/`
- Read [Object Reference](OBJECTS.md) for complete list of externals

---

Need help? [Open an issue](https://github.com/omar-karray/HoaLibrary-Max/issues)
