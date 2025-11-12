# HoaLibrary v3.0 for Max 9

[![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Max](https://img.shields.io/badge/Max-9.0%2B-orange.svg)](https://cycling74.com/products/max)
[![Architecture](https://img.shields.io/badge/architecture-Universal%20Binary-green.svg)](https://developer.apple.com/documentation/apple-silicon)

> **High Order Ambisonics library for Max 9 - Now with Apple Silicon support!**

## 🎵 What's New in v3.0

This is a **community-maintained release** of HoaLibrary rebuilt for **Max 9** and **Apple Silicon**.

### Key Improvements
- ✅ **Apple Silicon Native**: Universal Binary externals (x86_64 + arm64)
- ✅ **Max 9 Compatible**: Updated for Max SDK 8.2.0
- ✅ **Modern Build System**: CMake-based compilation
- ✅ **All Externals Working**: 37 externals fully tested and verified
- ✅ **C++ Standards Compliant**: Fixed legacy code issues

## 📦 What's Included

- **37 Universal Binary externals** supporting both Intel and Apple Silicon Macs
- **Complete documentation** with help files for all objects
- **Example patches** demonstrating spatial audio techniques
- **2D and 3D ambisonic tools**: encoding, decoding, transformation, optimization

### Core Externals

**2D Ambisonics:**
- `hoa.2d.encoder~` - Encode sources to 2D ambisonic field
- `hoa.2d.decoder~` - Decode 2D ambisonic field to speakers
- `hoa.2d.rotate~` - Rotate 2D sound field
- `hoa.2d.wider~` - Adjust 2D sound field width
- `hoa.2d.optim~` - Optimize 2D decoding
- `hoa.2d.scope~` - Visualize 2D sound field
- `hoa.2d.map~` - Map sources in 2D space

**3D Ambisonics:**
- `hoa.3d.encoder~` - Encode sources to 3D ambisonic field
- `hoa.3d.decoder~` - Decode 3D ambisonic field to speakers
- `hoa.3d.wider~` - Adjust 3D sound field width
- `hoa.3d.optim~` - Optimize 3D decoding
- `hoa.3d.scope~` - Visualize 3D sound field
- `hoa.3d.map~` - Map sources in 3D space

**Processing & Utilities:**
- `hoa.process~` - Host processing chains
- `hoa.map` - Interactive source mapping GUI
- `hoa.connect` - Manage ambisonic connections
- `hoa.in~` / `hoa.out~` - I/O for hoa.process~
- `c.convolve~` / `c.freeverb~` - Effects processing

[See full object list →](Package/HoaLibrary/docs/)

## 💾 Installation

### Requirements
- **Max**: 9.0 or higher
- **macOS**: 10.15 (Catalina) or higher
- **Architecture**: Intel (x86_64) or Apple Silicon (arm64)

### Quick Install

1. **Download** the latest release: [`HoaLibrary-Mac-v3.0.0.zip`](https://github.com/CICM/HoaLibrary-Max/releases/latest)

2. **Extract** the archive

3. **Copy** the `HoaLibrary` folder to:
   ```
   ~/Documents/Max 9/Packages/
   ```

4. **Restart Max** (if running)

5. **Test** by creating a new patcher and adding objects like:
   - `hoa.2d.encoder~`
   - `hoa.3d.decoder~`
   - `hoa.map`

### Verify Installation

Open Max's Console (Window → Max Console) and look for:
```
Package: HoaLibrary v3.0 loaded
```

## 🚀 Quick Start

### Basic 2D Ambisonic Setup

```
[adc~]                          <- Audio input
  |
[hoa.2d.encoder~ 3]            <- Encode to order 3 (16 channels)
  |
[hoa.2d.rotate~ 3 @ramp 100]   <- Rotate sound field
  |
[hoa.2d.decoder~ 3 ambisonic 8] <- Decode to 8 speakers
  |
[dac~ 1 2 3 4 5 6 7 8]         <- Output to speakers
```

### Interactive Mapping

```
[hoa.map @inputs 8 @outputs 8]  <- GUI for source positioning
```

Check the `help` and `extras` folders for complete examples!

## 🔧 Building from Source

If you want to build the externals yourself:

### Prerequisites
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install CMake (via Homebrew)
brew install cmake
```

### Build Steps
```bash
# Clone the repository
git clone https://github.com/CICM/HoaLibrary-Max.git
cd HoaLibrary-Max

# Create build directory
mkdir build && cd build

# Configure (adjust path to your Max SDK)
cmake .. -DMAX_SDK_PATH=~/DevRepos/MaxMSP_development/max-sdk

# Build all externals
cmake --build . -j8

# Install to Max Packages
cd ..
./install.sh
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## 📚 Documentation

- **Help Files**: Right-click any HoaLibrary object in Max and select "Open Help"
- **Reference**: See `docs/` folder for detailed XML references
- **Examples**: Check `extras/` and `patchers/` folders
- **Original Documentation**: [HoaLibrary Website](http://www.mshparisnord.fr/hoalibrary/)

## 🐛 Known Issues & Support

### Reporting Issues
Found a bug? Please [open an issue](https://github.com/CICM/HoaLibrary-Max/issues) with:
- Max version and macOS version
- Processor type (Intel or Apple Silicon)
- Steps to reproduce
- Console error messages

### Common Issues

**Objects not found after installation:**
- Verify the package is in `~/Documents/Max 9/Packages/HoaLibrary/`
- Restart Max completely
- Check Max Console for error messages

**Performance issues:**
- Ensure you're running the native version for your processor
- Verify with: Max Console should show "arm64" on Apple Silicon

## 👥 Credits

### Original Authors (HoaLibrary v2.2)
- **Pierre Guillot**
- **Eliott Paris** 
- **Julien Colafrancesco**

**CICM - Centre de recherche Informatique et Création Musicale**  
Université Paris 8

### v3.0 Modernization
This release was rebuilt for Max 9 and Apple Silicon by the community.

## 📄 License

The HoaLibrary is distributed under the [GNU General Public License v3](LICENSE.txt).

If you'd like to avoid the restrictions of the GPL and use HoaLibrary for a closed-source product, please contact [CICM](http://cicm.mshparisnord.org/).

## 🔗 Links

- **Website**: http://www.mshparisnord.fr/hoalibrary/
- **GitHub**: https://github.com/CICM/HoaLibrary-Max
- **CICM**: http://cicm.mshparisnord.org/
- **Max**: https://cycling74.com/

---

**Feedback and bug reports are welcome!** 🎶

