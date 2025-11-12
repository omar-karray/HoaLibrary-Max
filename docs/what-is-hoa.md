---
layout: default
title: What is Higher Order Ambisonics?
---

# What is Higher Order Ambisonics?

[← Back to Home](index.md)

---

## Introduction

**Ambisonics** is a spatial audio technique that represents sound fields using spherical harmonics. Unlike traditional surround sound that routes audio to specific speakers, Ambisonics captures the complete 3D sound field, making it independent of the playback system.

**Higher Order Ambisonics (HOA)** extends this by using higher spherical harmonic orders, providing increased spatial resolution and accuracy.

---

## How It Works

### The Mathematics (Simplified)

Ambisonics uses **spherical harmonics** - mathematical functions that describe patterns on a sphere, similar to how Fourier series describe waves in time.

Each ambisonic **order** adds more detail to the spatial representation:

| Order | Channels | Spatial Resolution |
|-------|----------|-------------------|
| 1 | 4 | Basic (W, X, Y, Z) |
| 2 | 9 | Medium |
| 3 | 16 | Good |
| 5 | 36 | High |
| 7 | 64 | Very High |

**Formula**: Number of channels = (order + 1)²

### The Physical Meaning

Think of ambisonic orders like camera resolution:
- **Order 1**: Like a 480p video - you get the general idea
- **Order 3**: Like 1080p - clear and detailed
- **Order 5+**: Like 4K - highly accurate

Higher orders capture more spatial detail but require more channels.

---

## The HOA Workflow

### 1. Encoding 🎤

Convert point sources into the ambisonic domain:

```
[noise~]              <- Your sound source
|
[hoa.2d.encoder~ 3]   <- Encode to order 3 (7 channels for 2D)
|
[7 channels]          <- Ambisonic representation
```

**What happens**: Your mono sound is decomposed into spherical harmonic coefficients that represent where the sound is coming from.

### 2. Transforming 🔄

Process the entire sound field:

```
[7 channels from encoder]
|
[hoa.2d.rotate~ 3]    <- Rotate the whole sound field
|
[hoa.2d.wider~ 3]     <- Make it more spacious
|
[hoa.process~ : effect] <- Apply effects to all channels
|
[7 channels processed]
```

**What happens**: Operations on all channels simultaneously transform the entire spatial scene.

### 3. Decoding 🔊

Convert to speaker signals:

```
[7 channels processed]
|
[hoa.2d.decoder~ 3 stereo]  <- Decode for stereo
|  |
[L] [R]                     <- Your speakers
```

**What happens**: The ambisonic field is projected onto your specific speaker arrangement.

---

## 2D vs 3D Ambisonics

### 2D (Circular)
- Horizontal plane only
- Uses **circular harmonics**
- Good for: Music, installations with speaker rings
- Channels: (2 × order) + 1

**Example**: Order 3 = 7 channels

### 3D (Spherical)
- Full 3D sphere
- Uses **spherical harmonics**
- Good for: VR, domes, 3D speaker arrays
- Channels: (order + 1)²

**Example**: Order 3 = 16 channels

---

## Key Concepts

### Ambisonic Order
The spatial resolution of your sound field:
- **Low orders (1-2)**: Fast, efficient, lower resolution
- **Medium orders (3-5)**: Balanced quality/performance
- **High orders (7+)**: Maximum precision, CPU intensive

### Encoding
Converting point sources into the ambisonic domain. In HoaLibrary:
- `hoa.2d.encoder~` for horizontal plane
- `hoa.3d.encoder~` for full sphere
- `hoa.map~` for multiple sources at once

### Decoding
Converting ambisonic channels to speaker signals. Options:
- **Stereo**: `hoa.2d.decoder~ 3 stereo`
- **Binaural**: `hoa.2d.decoder~ 3 binaural` (headphones)
- **Ambisonic**: `hoa.2d.decoder~ 3 ambisonic 8` (8 speakers)
- **Irregular**: Custom speaker positions

### Optimization
Improving sound field rendering:
- **Basic**: Standard decoding
- **MaxRE**: Increases sweet spot size
- **InPhase**: Reduces phase artifacts

---

## Advantages of HOA

### ✅ Speaker-Independent
Encode once, decode to **any** configuration:
- Stereo
- Headphones (binaural)
- 5.1 / 7.1
- Irregular arrays
- 100+ speakers in a dome

### ✅ Efficient Processing
Transform entire spatial scenes with single operations:
```
Instead of:
  8 individual rotations for 8 sources

With HOA:
  1 rotation for entire sound field
```

### ✅ Recordable & Editable
- Save complete 3D sound fields
- Edit later for different venues
- Mix in ambisonic domain

### ✅ Homogeneous Resolution
- Consistent spatial accuracy in all directions
- Unlike VBAP where resolution varies

### ✅ Sound Field Transformations
- Rotate entire scenes
- Zoom in/out spatially
- Mirror/flip spaces
- Creative spatial effects

---

## Limitations & Trade-offs

### ⚠️ Sweet Spot
- Listener should be at center of speaker array
- Quality degrades off-center
- (Can be mitigated with MaxRE optimization)

### ⚠️ Channel Count
- High orders = many channels
- Order 7 in 3D = 64 channels!
- Can be CPU intensive

### ⚠️ Speaker Requirements
- Ideal: Speakers in circle/sphere at equal distances
- More speakers than channels needed for best results
- Irregular arrays work but with reduced quality

---

## Practical Examples

### Example 1: Simple 2D Panning

```
[saw~ 440]                    <- Sawtooth wave
|
[hoa.2d.encoder~ 5 0]        <- Encode at angle 0° (front)
|
[hoa.2d.rotate~ 5]           <- Rotate (automate for movement)
|
[hoa.2d.scope~ 5]            <- Visualize the field
|
[hoa.2d.decoder~ 5 stereo]   <- Decode to stereo
|  |
[dac~ 1 2]
```

### Example 2: Multiple Sources

```
[noise~] [saw~ 200] [saw~ 300]
   |         |          |
   |-------[hoa.2d.map~ 3]-------|
                |
         [hoa.2d.wider~ 3]      <- Add spaciousness
                |
         [hoa.2d.decoder~ 3 binaural]
                |  |
            [dac~ 1 2]          <- Binaural headphones
```

### Example 3: Sound Field Recording

```
[hoa.2d.encoder~ 7] × N sources
         |
    [sfrecord~ 15]             <- Record 15 channels (order 7 2D)
    
Later:
[sfplay~ 15]
    |
[hoa.2d.decoder~ 7 ambisonic 16] <- Decode to different system!
```

---

## Learning Path

### 🎯 Beginner
Start with 2D, low orders:
1. `hoa.2d.encoder~ 3` / `hoa.2d.decoder~ 3`
2. Decode to stereo first
3. Use `hoa.2d.scope~` to visualize

### 🎯 Intermediate
Explore transformations:
1. `hoa.2d.rotate~` for movement
2. `hoa.2d.map~` for multiple sources
3. `hoa.process~` for effects
4. Try different decoder types

### 🎯 Advanced
Push the boundaries:
1. Move to 3D with `hoa.3d.*`
2. Use high orders (5-7)
3. Custom speaker arrays
4. Build complex spatial processors

---

## Use Cases

### 🎵 Music Production
```
Traditional Stereo Panning → HOA Workflow
- Limited to L/R            → Full 360° spatial field
- Fixed to stereo           → Decode to any system
- Per-source effects        → Sound field processing
```

### 🎮 Game Audio & VR
```
- Dynamic head tracking
- Scalable audio scenes
- Platform-independent assets
- Efficient CPU usage
```

### 🎭 Installation & Performance
```
- Adapt to venue on-site
- Consistent creative vision
- Archive for future venues
- Explore spatial composition
```

### 🎬 Post-Production
```
- 360° video audio
- Atmos deliverables
- Future-proof masters
- Cross-platform distribution
```

---

## Further Reading

### Academic Resources
- [Daniel, J. - "Spatial Sound Encoding"](https://tel.archives-ouvertes.fr/tel-00004001/)
- [Malham, D. - "Higher Order Ambisonic Systems"](http://www.muse.demon.co.uk/ref/speakers.html)

### Online Resources
- [Ambisonics on Wikipedia](https://en.wikipedia.org/wiki/Ambisonics)
- [Ambisonics.info](http://www.ambisonics.info/)
- [IEM Symposium Papers](https://plugins.iem.at/)

### HoaLibrary Specific
- [Built-in Tutorials](tutorials.md) - 10 interactive Max patches
- [Object Reference](OBJECTS.md) - All externals documented
- Help Files - Right-click any object → "Open Help"

---

## Next Steps

Ready to start? Check out:
- **[Installation Guide](INSTALLATION.md)** - Get HoaLibrary set up
- **[Tutorials](tutorials.md)** - Learn with interactive patches
- **[Object Reference](OBJECTS.md)** - Explore all objects

[← Back to Home](index.md)
