# Building HoaLibrary-Max for Apple Silicon

This document describes how to build HoaLibrary-Max for Max 9 on Apple Silicon (arm64) and Intel (x86_64).

## Prerequisites

- **macOS 10.15+** (tested on macOS 15 Sequoia)
- **Xcode 10+** (tested with Xcode 17)
- **CMake 3.19+** 
- **Max SDK 8.2.0** (compatible with Max 8+/9+)
- **Max 9.0.2** or later (for testing)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/omar-karray/HoaLibrary-Max.git
cd HoaLibrary-Max

# Create build directory
mkdir build && cd build

# Configure with CMake (Universal Binary: x86_64 + arm64)
cmake .. -DMAX_SDK_PATH=/path/to/max-sdk

# Build all externals
cmake --build . -j8

# Or build a single external for testing
cmake --build . --target hoa_3d_encoder_tilde
```

## Configuration

### Max SDK Path

The build system needs to know where your Max SDK is located. You can specify it in three ways:

1. **Command line** (recommended):
   ```bash
   cmake .. -DMAX_SDK_PATH=/Users/yourname/DevRepos/max-sdk
   ```

2. **Environment variable**:
   ```bash
   export MAX_SDK_PATH=/Users/yourname/DevRepos/max-sdk
   cmake ..
   ```

3. **Default location**: The build system will look for `../max-sdk` relative to the project directory

### Build Options

- **Architecture**: Builds Universal Binary (x86_64 + arm64) by default
- **Deployment Target**: macOS 10.11 minimum
- **C++ Standard**: C++11
- **Optimization**: Release mode by default

### Using Xcode

You can also generate an Xcode project:

```bash
cmake .. -G Xcode -DMAX_SDK_PATH=/path/to/max-sdk
open HoaLibrary-Max.xcodeproj
```

## Build Output

Compiled externals are placed in:
```
Package/HoaLibrary/externals/
```

Each external is a `.mxo` bundle (macOS application bundle format) containing:
- Universal binary (x86_64 + arm64)
- Resources
- Info.plist

## Verification

Check that your build is a Universal Binary:

```bash
lipo -info Package/HoaLibrary/externals/hoa.3d.encoder~.mxo/Contents/MacOS/hoa.3d.encoder~
```

Expected output:
```
Architectures in the fat file: ... are: x86_64 arm64
```

## Installation

Copy the compiled externals to Max:

```bash
# Option 1: Copy to user externals folder
cp -r Package/HoaLibrary/externals/*.mxo ~/Documents/Max\ 9/Library/

# Option 2: Use the package directly
# Max will find externals if you open patches from Package/HoaLibrary/
```

## Troubleshooting

### CMake can't find Max SDK

Make sure the path points to the root of the max-sdk repository that contains:
```
max-sdk/
├── source/
│   ├── max-sdk-base/
│   │   ├── c74support/
│   │   │   ├── max-includes/
│   │   │   ├── msp-includes/
│   │   │   └── jit-includes/
```

### Compilation errors

If you see C++ compilation errors in HoaLibrary headers, make sure you're on the correct branch:
```bash
git checkout fix/hoalibrary-cpp-modernization
```

### Linking errors

The build system automatically reads linker flags from the Max SDK. If you get undefined symbol errors, verify your Max SDK version is 8.2.0 or later.

## Building Individual Externals

To build just one external for faster iteration:

```bash
# 2D externals
cmake --build . --target hoa_2d_encoder_tilde
cmake --build . --target hoa_2d_decoder_tilde

# 3D externals  
cmake --build . --target hoa_3d_encoder_tilde
cmake --build . --target hoa_3d_decoder_tilde

# Common externals
cmake --build . --target hoa_dac_tilde
cmake --build . --target hoa_gain_gui_tilde
```

## What Was Fixed

This fork modernizes HoaLibrary-Max for Apple Silicon and Max 9:

1. **C++ Standards Compliance**: Fixed nested class inheritance violations in `Encoder.hpp`, `Decoder.hpp`, and `Optim.hpp` that prevented compilation with modern compilers

2. **Modern Build System**: Replaced Xcode-only projects with CMake for cross-platform building and better CI/CD integration

3. **Universal Binary Support**: Configured for both Intel (x86_64) and Apple Silicon (arm64) architectures

4. **Max 9 Compatibility**: Updated for Max SDK 8.2.0 and Max 9.0.2+

## Contributing

If you encounter build issues, please open an issue with:
- Your macOS version
- Xcode version (`xcode-select --version`)
- CMake version (`cmake --version`)
- Max SDK version
- Full build output

## Resources

- [Max SDK Documentation](https://cycling74.com/sdk)
- [CMake Documentation](https://cmake.org/documentation/)
- [HoaLibrary Original Repository](https://github.com/CICM/HoaLibrary-Max)
