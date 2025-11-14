# Project Context: HoaLibrary-Max Spatial Granulator Extension

## Project Overview
We are forking and modernizing the **HoaLibrary-Max** library to add a new spatial granulator external for Max MSP. This project combines Higher Order Ambisonics (HOA) spatial audio with granular synthesis.

## What is HoaLibrary-Max?
- **Repository**: https://github.com/CICM/HoaLibrary-Max
- **License**: GNU Public License (GPL)
- **Status**: Unmaintained since 2015, last compatible with Max 6.1.9
- **Purpose**: Higher Order Ambisonics (HOA) implementation for Max MSP
- **Language**: C++ externals for Max MSP

## Our Goals

### Phase 1: Modernization
1. Update build system for Max 8/9 compatibility
2. Configure CMake to properly find Max SDK
3. Fix any deprecated API calls
4. Test existing objects compile and work

### Phase 2: Add Spatial Granulator
1. Create new external: `hoa.3d.granulator~`
2. Implement based on research paper: "Spatial Granular Synthesis with Ambitools and AntesCollider"
3. Integrate with existing HoaLibrary encoder infrastructure
4. Create help files and documentation

### Phase 3: Distribution
1. Package for Max 9
2. Create comprehensive documentation
3. Share with community

## Technical Background

### Higher Order Ambisonics (HOA)
- **What**: 3D spatial audio format using spherical harmonics
- **Channels**: (order + 1)² channels
  - Order 1 = 4 channels (W, X, Y, Z)
  - Order 3 = 16 channels
  - Order 7 = 64 channels
- **Encoding**: Converts position (azimuth, elevation, radius) → HOA channels
- **Decoding**: HOA channels → speaker array or binaural

### Granular Synthesis
- **Concept**: Break audio into tiny "grains" (10-100ms)
- **Parameters per grain**:
  - Duration (ms)
  - Read speed (playback rate)
  - Start position in buffer
  - Direction (forward/reverse)
  - Envelope shape
- **Probability**: Control grain density (0-1)

### Spatial Granular Synthesis
- Each grain has 3D position: azimuth, elevation, radius
- Position randomized within ranges (spherical shell sector)
- Each grain encoded separately into HOA
- Multiple grains (8-32) create "swarm" effect
- Result: immersive spatial texture

## Key Implementation Details

### From Research Paper (hal-04846653v1)
- Uses FAUST language (we're adapting to C++)
- N parallel grain streams
- Each stream generates continuous grains
- Random parameters set at grain boundaries
- Multiple envelope types: Hann, Hamming, Blackman, Triangle, Trapezoid
- Supports both file playback and live input (circular buffer)

### HoaLibrary Architecture
- **Existing objects we'll use**:
  - `hoa.3d.encoder~` - encodes mono signal with position to HOA
  - `hoa.3d.decoder~` - decodes HOA to speakers
  - `hoa.3d.scope~` - visualizes HOA energy
  
- **Our new object**:
  - `hoa.3d.granulator~` - generates spatial grain swarm

### Object Parameters
```
Grain Parameters:
- @grains (int): number of grain streams (1-32)
- @dur_min (float): minimum grain duration (ms)
- @dur_max (float): maximum grain duration (ms)
- @speed_min (float): minimum read speed
- @speed_max (float): maximum read speed
- @probability (float): grain density 0-1

Spatial Parameters:
- @hoa_order (int): HOA order (1-7)
- @radius_min (float): minimum distance
- @radius_max (float): maximum distance
- @azimuth_min (float): minimum azimuth (degrees)
- @azimuth_max (float): maximum azimuth (degrees)
- @elevation_min (float): minimum elevation (degrees)
- @elevation_max (float): maximum elevation (degrees)

Audio Source:
- @buffer (symbol): audio buffer name
- @use_input (bool): use live input vs buffer
```

### Signal Flow
```
Audio Buffer / Live Input
    ↓
Grain Generator (N streams)
    ↓
Random Parameters (duration, speed, position, direction)
    ↓
Envelope Application (Hann, Hamming, etc.)
    ↓
Spatial Encoding (azimuth, elevation → HOA)
    ↓
HOA Channels Output [(order+1)² channels]
    ↓
hoa.3d.decoder~ → Speakers/Headphones
```

## Development Environment

### Required Tools
- **Max SDK**: https://github.com/Cycling74/max-sdk
- **CMake**: Build system generator
- **Xcode** (macOS): C++ compiler
- **Visual Studio** (Windows): C++ compiler

### Directory Structure
```
HoaLibrary-Max/
├── CMakeLists.txt          # Main build configuration
├── ThirdParty/             # Dependencies (Max SDK reference)
├── Package/
│   └── HoaLibrary/
│       ├── externals/      # Compiled .mxo files
│       ├── help/           # .maxhelp files
│       └── docs/           # .maxref.xml files
├── Max3D/                  # 3D HOA objects source
│   ├── hoa.3d.encoder_tilde.cpp
│   ├── hoa.3d.granulator_tilde.cpp  # NEW!
│   └── ...
└── sources/                # Common utilities
```

## Current Task
Setting up the build system to:
1. Locate Max SDK properly
2. Build existing HoaLibrary objects
3. Verify compilation works before adding granulator

## References
- **Paper**: "Spatial Granular Synthesis with Ambitools and AntesCollider" - https://hal.science/hal-04846653v1/file/0.pdf
- **HoaLibrary-Max**: https://github.com/CICM/HoaLibrary-Max
- **Max SDK**: https://github.com/Cycling74/max-sdk
- **Ambitools**: https://sekisushai.net/ambitools

## Coding Standards
- **Language**: C++11 or newer
- **Max API**: Use Max 8/9 API conventions
- **Naming**: Follow HoaLibrary convention `hoa.3d.objectname~`
- **Memory**: Use Max's memory management (getbytes/freebytes)
- **Threading**: DSP runs in audio thread, be careful with locks

## Key Files to Reference
- `hoa.3d.encoder_tilde.cpp` - shows HOA encoding implementation
- `hoa.encoder.hpp` - encoder class we'll reuse
- `hoa.map_tilde.cpp` - shows parameter handling
- Max SDK `simplemsp~` example - basic MSP external structure

## Next Steps
1. ✅ Fork repository
2. ✅ Clone locally
3. ✅ Install Max SDK
4. 🔄 Configure CMake to find Max SDK
5. ⏳ Build existing library
6. ⏳ Implement hoa.3d.granulator~
7. ⏳ Test and debug
8. ⏳ Create documentation

---

**Note for Copilot**: When suggesting code, please follow Max MSP external conventions, use the HoaLibrary's encoder classes, and ensure thread-safe audio processing in the perform routine.