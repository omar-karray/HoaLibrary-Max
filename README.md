# HoaLibrary for Max

[![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Max](https://img.shields.io/badge/Max-9.0%2B-orange.svg)](https://cycling74.com/products/max)
[![Architecture](https://img.shields.io/badge/architecture-Universal%20Binary-green.svg)](https://developer.apple.com/documentation/apple-silicon)
[![License](https://img.shields.io/badge/license-GPL%20v3-blue.svg)](LICENSE.txt)

> **High Order Ambisonics library for Max - Now with Max 9 and Apple Silicon support!**

A comprehensive suite of externals and patches for 2D and 3D spatial audio processing using circular and spherical harmonics.

![HoaLibrary](https://raw.github.com/CICM/HoaLibrary-Max/master/misc/HoaLibrary-v2.2-beta.png)

## 🎵 What's New in v3.0

- ✅ **Apple Silicon Native**: Universal Binary externals (x86_64 + arm64)
- ✅ **Max 9 Compatible**: Updated for Max SDK 8.2.0
- ✅ **37 Externals Working**: All fully tested and verified
- ✅ **Modern Build System**: CMake-based compilation

## 📥 Quick Start

### Download & Install

1. **Download**: [Latest Release (v3.0.0)](https://github.com/omar-karray/HoaLibrary-Max/releases/latest)
2. **Extract** the zip file
3. **Copy** the `HoaLibrary` folder to: `~/Documents/Max 9/Packages/`
4. **Restart Max** and you're ready!

### Try It Out

Create a new Max patcher and try:
```
hoa.2d.encoder~ 3
hoa.3d.decoder~ 3 ambisonic 8
hoa.map
```

See [complete installation guide →](docs/INSTALLATION.md)

## 🎯 Features

### 2D Ambisonics
- `hoa.2d.encoder~` - Encode sources to 2D ambisonic field
- `hoa.2d.decoder~` - Decode 2D field to speakers
- `hoa.2d.rotate~` - Rotate sound field
- `hoa.2d.scope~` - Visualize sound field
- And more...

### 3D Ambisonics
- `hoa.3d.encoder~` - Encode sources to 3D ambisonic field
- `hoa.3d.decoder~` - Decode 3D field to speakers
- `hoa.3d.scope~` - Visualize 3D sound field
- And more...

### Processing Tools
- `hoa.process~` - Host processing chains
- `hoa.map` - Interactive source mapping GUI
- `c.convolve~` / `c.freeverb~` - Effects processing

[See all 37 externals →](docs/OBJECTS.md)

## 💻 Compatibility

- **Max**: 9.0 or higher
- **macOS**: 10.15 (Catalina) or higher
- **Processors**: Intel (x86_64) and Apple Silicon (arm64)
- **Architecture**: Universal Binary

## 🔧 Building from Source

```bash
# Clone repository
git clone https://github.com/omar-karray/HoaLibrary-Max.git
cd HoaLibrary-Max

# Build
mkdir build && cd build
cmake .. -DMAX_SDK_PATH=~/path/to/max-sdk
cmake --build . -j8

# Install
cd .. && ./install.sh
```

See [BUILD.md](BUILD.md) for detailed instructions.

## 📚 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Step-by-step installation
- **[Build Instructions](BUILD.md)** - How to compile from source
- **[Object Reference](docs/OBJECTS.md)** - Complete list of externals
- **[Release Notes](RELEASE_NOTES.md)** - What's new in v3.0
- **Help Files** - Right-click any object in Max → "Open Help"

## 👥 Credits

### Original Authors (v1.0 - v2.2, 2012-2015)
- **Pierre Guillot**
- **Eliott Paris**
- **Julien Colafrancesco**

**CICM - Centre de Recherche Informatique et Création Musicale**  
Université Paris 8, France

### v3.0 Modernization (2025)
- **Omar Karray** - Current Maintainer
  - Apple Silicon support
  - Max 9 compatibility
  - Modern build system
  - [GitHub Repository](https://github.com/omar-karray/HoaLibrary-Max)

## 📄 License

This project is licensed under the [GNU General Public License v3.0](LICENSE.txt).

For commercial licensing inquiries (avoiding GPL restrictions):
- **v3.0+ modifications**: Contact [Omar Karray](https://github.com/omar-karray)
- **Original code**: Contact [CICM](http://cicm.mshparisnord.org/)

## 🔗 Links

- **Original HoaLibrary**: http://www.mshparisnord.fr/hoalibrary/
- **CICM**: http://cicm.mshparisnord.org/
- **Max/MSP**: https://cycling74.com/

### Other Implementations
- [HoaLibrary-PD](https://github.com/CICM/HoaLibrary-PD) - Pure Data version
- [ofxHoa](https://github.com/CICM/ofxHoa) - openFrameworks version
- [HoaLibrary-Faust](https://github.com/CICM/HoaLibrary-Faust) - Faust version

## 🐛 Issues & Support

- **Report bugs**: [GitHub Issues](https://github.com/omar-karray/HoaLibrary-Max/issues)
- **Discussions**: [GitHub Discussions](https://github.com/omar-karray/HoaLibrary-Max/discussions)

---

**Made with ❤️ for the Max community**
