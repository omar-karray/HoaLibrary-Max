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

## 🎓 What is Higher Order Ambisonics?

**Ambisonics** is a powerful spatial audio technique that represents sound fields using spherical harmonics. Unlike traditional surround sound methods that route audio to specific speakers, Ambisonics captures the entire 3D sound field, allowing it to be decoded to any speaker arrangement.

### Core Concepts

**Higher Order Ambisonics (HOA)** extends first-order Ambisonics by using higher spherical harmonic orders, providing increased spatial resolution and accuracy:

- **Order 1**: 4 channels (W, X, Y, Z) - basic spatial information
- **Order 3**: 16 channels - good spatial resolution
- **Order 5**: 36 channels - high spatial resolution
- **Order 7+**: 64+ channels - very high precision

**The higher the order, the more precise the spatial image, but more channels are needed.**

### The HOA Workflow

1. **Encode** → Convert sound sources into the ambisonic domain
2. **Transform** → Rotate, widen, or process the sound field
3. **Decode** → Convert back to speaker signals for playback

### Basic Example: 2D Stereo Spatialization

```
[noise~]                    <- Sound source
|
[hoa.2d.encoder~ 3]        <- Encode to order 3 (7 channels)
|
[hoa.2d.rotate~ 3]         <- Rotate the sound field
|
[hoa.2d.decoder~ 3 stereo] <- Decode to stereo
|  |
[dac~ 1 2]                 <- Output
```

### Common Use Cases

**🎵 Music Production**
- Create immersive spatial mixes
- Automate 3D source movement
- Export to VR/AR platforms

**🎮 Game Audio & VR**
- Dynamic 3D soundscapes
- Head-tracked binaural output
- Scalable to any speaker setup

**🎭 Installation & Performance**
- Adapt to different venues
- Record once, play anywhere
- Process entire sound fields

**🎬 Post-Production**
- Spatial audio for 360° video
- Dolby Atmos integration
- Format-agnostic workflows

### Key Advantages

✅ **Speaker-Independent**: Encode once, decode to any configuration  
✅ **Efficient Processing**: Transform entire sound fields with single operations  
✅ **Homogeneous Resolution**: Consistent spatial accuracy in all directions  
✅ **Recordable**: Store complete 3D sound fields for later playback  
✅ **Transformable**: Rotate, zoom, mirror entire spatial scenes

### Getting Started

**Step 1**: Learn the basics with the built-in tutorials:
- Open Max → File → Open → `Package/HoaLibrary/extras/Tutorials-en/`
- Start with `Tutorial 01 - Introduction.maxpat`

**Step 2**: Understand the encoding/decoding chain:
```
Source → [hoa.2d.encoder~ order] → [hoa.2d.decoder~ order config] → Speakers
```

**Step 3**: Experiment with transformations:
- `hoa.2d.rotate~` - Spin the sound field
- `hoa.2d.wider~` - Increase spaciousness
- `hoa.process~` - Apply effects to all channels

**Step 4**: Visualize with GUI objects:
- `hoa.2d.scope~` - See the sound field in real-time
- `hoa.2d.meter~` - Monitor channel levels
- `hoa.map` - Control source positions interactively

### 📚 Learn More

- **[📚 Documentation Site](https://omar-karray.github.io/HoaLibrary-Max/)** - Complete guide with examples
- **[Interactive Tutorials](Package/HoaLibrary/extras/HoaLibrary/Tutorials-en/)** - 10 step-by-step Max patches
- **[Practical Examples](docs/examples.md)** - Ready-to-use patches for common scenarios
- **[Object Reference](docs/OBJECTS.md)** - Complete documentation of all 37 externals
- **Help Files** - Right-click any object → "Open Help"

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
