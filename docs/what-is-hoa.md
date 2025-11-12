---
layout: default
title: What is Higher Order Ambisonics?
---

# What is Higher Order Ambisonics?

[← Back to Home](index.md)

---

## Introduction

**Ambisonics** is a comprehensive set of techniques for the recording, synthesis, transformation, and restitution of sound fields. Unlike traditional surround sound that routes audio signals to specific speakers, Ambisonics is based on a **physical representation** of the sound space that allows a wide range of sound and space processing operations.

At its core, Ambisonics represents sound fields using **spherical harmonics** (for 3D) or **circular harmonics** (for 2D horizontal plane). This mathematical representation captures the complete directional information of a sound field at a single point in space, making it independent of the playback system.

**Higher Order Ambisonics (HOA)** extends basic first-order Ambisonics by using higher harmonic orders, providing dramatically increased spatial resolution and accuracy. The HoaLibrary gives you access to orders up to 35 in 2D (71 channels) and up to 10 in 3D (121 channels), though practical applications typically use orders 3-7.

### Why Ambisonics?

The separation of encoding and decoding operations is fundamental: you can synthesize and transform multiple sound fields in the harmonic domain, then decode them all with a single operation. This offers:

- **Efficient CPU usage**: Process entire spatial scenes instead of individual sources
- **Recordable sound fields**: Capture spatial audio that adapts to any playback system
- **Homogeneous resolution**: Unlike techniques like VBAP where angular resolution varies with source direction, Ambisonics provides **constant angular resolution** in all directions
- **Rich transformations**: Rotation, zooming, widening, and creative spatial effects
- **Musical potential**: New techniques for sound field synthesis and transformation

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

Ambisonics can work in two domains:

### 2D (Circular)
- **Horizontal plane only** - sources move around you in a circle
- Uses **circular harmonics** - mathematical functions describing patterns on a circle
- Channels: **(2 × order) + 1**
- More efficient for horizontal-only spatialization

**Example**: Order 3 = 7 channels (harmonic degrees: 0, -1, +1, -2, +2, -3, +3)

**Best for**:
- Music production and mixing
- Installations with speaker rings/circles
- Theater and live performance
- When vertical dimension isn't needed

### 3D (Spherical)
- **Full 3D sphere** - sources can be anywhere around and above/below you
- Uses **spherical harmonics** - mathematical functions describing patterns on a sphere
- Channels: **(order + 1)²**
- Complete spatial immersion

**Example**: Order 3 = 16 channels (significantly more spatial information)

**Best for**:
- Virtual reality and 360° video
- Dome installations and planetariums
- 3D speaker arrays (including height channels)
- Architectural acoustics simulation
- Full immersive experiences

### Domain Representations

Ambisonics allows you to work in two complementary representations:

**Harmonics Domain** (Encoding/Processing):
- Sound field represented as spherical/circular harmonic coefficients
- Each channel carries a harmonic degree/order
- Ideal for transformations (rotation, zoom, effects)
- Think of it as the "frequency domain" of space

**Planewaves Domain** (Decoding):
- Sound field represented as directional plane waves
- Each channel corresponds to a loudspeaker direction
- Used for final rendering to speakers
- Think of it as the "time domain" of space

The power of Ambisonics lies in transforming between these domains efficiently.

---

## The Mathematics Behind Ambisonics

### Spherical Harmonics: The Foundation

Ambisonics is built on **spherical harmonics** (or circular harmonics in 2D), which are mathematical functions that describe patterns on spheres. Think of them as the spatial equivalent of Fourier series in time:

- **Time domain**: Fourier series decomposes signals into sines and cosines of different frequencies
- **Space domain**: Spherical harmonics decompose spatial patterns into basis functions of different orders

Each harmonic has:
- An **order** (n): Determines the spatial frequency/resolution (0, 1, 2, 3...)
- A **degree** (m): Describes the directionality within that order (-n to +n)

For order 3 in 2D:
```
Order 0: Harmonic 0 (omnidirectional)
Order 1: Harmonics -1, +1 (dipole patterns)
Order 2: Harmonics -2, +2 (quadrupole patterns)
Order 3: Harmonics -3, +3 (sextupole patterns)
= 7 channels total
```

### Encoding: Source → Harmonics

When you encode a point source at angle θ and elevation φ into ambisonics, you're decomposing it into harmonic components. For a 2D encoder:

**Signal at angle θ becomes**:
- Harmonic 0: Full amplitude (omnidirectional)
- Harmonic ±1: cos(θ) and sin(θ) components
- Harmonic ±2: cos(2θ) and sin(2θ) components
- And so on...

This is like taking the spatial Fourier transform of a Dirac impulse at the source position.

### Decoding: Harmonics → Speakers

Decoding is the inverse operation. For each loudspeaker at angle θ_speaker, we compute:

```
Speaker signal = Σ (Harmonic_n × Y_n(θ_speaker))
```

Where Y_n(θ_speaker) are the circular harmonic values in that speaker's direction. This sums up all the harmonic contributions to recreate the sound field at the speaker position.

**Key insight**: The decoding operation is essentially computing **how much of each harmonic pattern** points toward each speaker.

### Why This Works

The beautiful mathematical property: 
- Encoding creates harmonic coefficients that describe the **entire sound field**
- Any number of sources can be summed in the harmonic domain
- Transformations (rotation, zoom) are simple operations on coefficients
- Decoding projects this field onto **any** speaker configuration

This separation is why Ambisonics is so powerful and flexible.

---

## Key Concepts

### Ambisonic Order & Spatial Resolution

The **order of decomposition** fundamentally affects the quality of sound field restitution. As the order increases, the number of harmonics increases, and the **spatial resolution** of the sound field increases.

**Spatial Resolution** encompasses two related concepts:

1. **Angular Resolution**: The precision with which a listener perceives the direction of a **point source**. Higher orders allow listeners to clearly define source direction.

2. **Spatial Resolution** (broader): The overall quality of spatial reproduction for complex sound fields, including diffuse fields, reverberation, and ambient sounds - not just point sources.

The order determines:
- **Low orders (1-2)**: Fast, efficient, lower resolution - good for diffuse sounds
- **Medium orders (3-5)**: Balanced quality/performance - standard for music
- **High orders (7+)**: Maximum precision, CPU intensive - critical listening

**Key insight**: The "quality" or "relevance" of ambisonic processing varies according to spatial resolution. Different applications require different orders based on the complexity of the sound field.

### Encoding: Adding Spatial Information

**Encoding gives spatial information to a sound**, allowing it to be perceived as coming from a specific point in space.

The encoding operation synthesizes harmonics based on position:

**2D Encoding** (Circular Harmonics):
- Input: Mono signal + azimuth angle θ
- Output: (2N + 1) harmonic channels
- Operation: `hoa.2d.encoder~ N` synthesizes circular harmonics Y depending on θ and order N

**3D Encoding** (Spherical Harmonics):
- Input: Mono signal + azimuth θ + elevation φ
- Output: (N + 1)² harmonic channels  
- Operation: `hoa.3d.encoder~ N` synthesizes spherical harmonics Y depending on θ, φ, and order N

**Multiple source encoding**:
- `hoa.map~` encodes multiple sources simultaneously with individual position control

### Decoding: Rendering to Speakers

After processing in the harmonics domain, the sound field is rendered into the **planewaves domain** for loudspeakers via decoding.

**Regular Decoding**: For equally-spaced circular/spherical arrays
- **Stereo**: `hoa.2d.decoder~ 3 stereo`
- **Ambisonic**: `hoa.2d.decoder~ 3 ambisonic 8` (8 speakers in circle)
- Regular decoding computes the sum of multiplication of the harmonics of the sound field with the harmonics of a dirac in each speaker direction

**Binaural Decoding**: For headphones
- **Binaural**: `hoa.2d.decoder~ 3 binaural`
- Uses HRTF (Head-Related Transfer Functions) for 3D audio on headphones

**Irregular Decoding**: For custom/non-ideal arrays
- **Irregular**: Custom speaker positions (5.1, 7.1, Atmos, etc.)
- Accommodates real-world setups that don't conform to ideal geometry

### Optimization: Compensating for Reality

Ambisonics ideally assumes one listener at the center of a perfect circle or sphere. Real-world situations rarely match this. Optimizations compensate for these restrictions:

**Basic** (No optimization):
- Direct decoding without modification
- **Best for**: Diffuse sound fields, ambience, reverberation
- **Not optimal for**: Point source spatialization
- Preserves original harmonic balance

**MaxRE** (Maximum Energy Vector):
- Increases the sweet spot size
- **Trade-off**: Reduced spatial resolution
- **Best for**: Multiple listeners spread across the space, installations, live performances
- Allows audience to be distributed rather than centered

**InPhase** (Phase-matched):
- Optimizes phase relationships between speakers
- Reduces phase artifacts and comb-filtering
- **Trade-off**: Some high-frequency spatial blur
- **Best for**: Off-center listening, critical monitoring

---

## Advantages of HOA

### ✅ Speaker-Independent Workflow

**Encode once, decode anywhere**. Your ambisonic sound field can be rendered to:
- **Stereo** - Standard left/right playback
- **Binaural** - 3D audio for headphones with HRTF
- **5.1 / 7.1** - Home theater and cinema formats
- **Irregular arrays** - Any custom speaker configuration
- **Large arrays** - 8, 16, 32, 100+ speakers
- **Dome systems** - Full spherical playback with height

The sound field is **format-agnostic**. You can:
- Create content once
- Deliver to multiple platforms
- Adapt to venue specifications on-site
- Archive for future playback systems that don't exist yet

### ✅ Efficient Processing & CPU Usage

**Process entire spatial scenes, not individual sources**:

Traditional approach (8 sources, 8 speakers):
```
8 sources × 8 rotations = 64 operations
8 sources × 8 delays = 64 operations
8 sources × 8 gains = 64 operations
```

Ambisonic approach:
```
1 rotation on harmonic field
1 delay on harmonic field  
1 gain on harmonic field
Then: 1 decode to 8 speakers
```

The separation of encoding/decoding means:
- Synthesize multiple sound fields
- Process them together in the harmonic domain
- **Decode with a single operation**
- Dramatically reduced CPU usage for complex scenes

### ✅ Recordable & Editable Sound Fields

**The harmonic domain is a recording format**:
- Record the ambisonic channels (7, 16, 36 channels etc.)
- The recorded file contains the **complete spatial information**
- Play back on any system by changing the decoder
- Edit spatial properties after recording

**Workflow advantages**:
- Record once, decode to venue specifications later
- Change speaker layouts without re-recording
- Apply spatial effects in post-production
- Archive spatial performances for future venues

### ✅ Homogeneous Spatial Resolution

**Constant angular resolution in all directions**:

Unlike amplitude panning techniques (VBAP, stereo panning) where:
- Resolution depends on speaker spacing
- Sources between speakers are "phantom images"
- Resolution varies with source direction

With Ambisonics:
- Resolution determined by **order**, not speaker positions
- Every direction has **identical spatial accuracy**
- No directional bias or "sweet angles"
- Mathematically uniform representation

### ✅ Sound Field Transformations

**Classical transformations**:
- **Rotation** (`hoa.rotate~`) - Spin the entire sound field
- **Zoom** (`hoa.wider~`) - Control directivity and spatial width
- **Mirror/Flip** - Reflect spatial arrangements
- **Distance** - Simulate sources entering/leaving the ambisonic space

**Creative transformations**:
- Apply effects to entire spatial scenes (`hoa.process~`)
- Granular synthesis of space (`hoa.fx.grain~`)
- Ring modulation between sound fields (`hoa.fx.ringmod~`)
- Decorrelation for diffuse fields (`hoa.fx.decorrelation~`)
- Spatial convolution (`hoa.fx.convolve~`)

**Directivity Control**:

During harmonic processing, we can change the **directivity of the sound field**:

- **Wider Effect** (`hoa.wider~`): Controls spatial width from omnidirectional (0) to highly directional (1)
- Each harmonic is multiplied by a gain depending on order, degree, and width parameter
- **Distance simulation**: Underlying operation for distance compensation algorithm
  - Sources entering the ambisonic space become more diffuse
  - Sources at the periphery remain directional
- Fine control over perceived spatial character: from diffuse ambience to localized point sources

**Musical potential**: The harmonic representation enables **new techniques of sound field synthesis and transformation** with high musical and creative potential.

---

## Limitations & Trade-offs

Understanding the constraints helps you work effectively with Ambisonics:

### ⚠️ Sweet Spot & Listener Position

**The Challenge**:
- The listener should ideally be placed at the **center of the loudspeaker array**
- Off-center listening causes sound field distortion
- This creates a "sweet spot" limitation

**The Solutions**:
- **MaxRE optimization**: Increases the sweet spot size at the cost of spatial resolution
- **InPhase optimization**: Reduces phase artifacts, improving off-center listening
- These optimizations allow an **audience spread all over the circle/sphere** rather than a single central position
- See the `hoa.optim~` object and Tutorial 08 for practical implementation

### ⚠️ Decomposition Order Restrictions

**System Requirements**:
- Number of loudspeakers must be **≥ number of harmonic channels**
- Loudspeakers should be placed on a circle/sphere at **equal distances** from the center
- Each loudspeaker should be **equidistant from adjacent speakers**

**Practical Reality**:
These restrictions can be bypassed in practice, though with some quality trade-offs:
- Stereo playback works (with reduced spatial accuracy)
- Irregular configurations (5.1, 7.1, Atmos) are supported
- Binaural decoding for headphones is possible
- Custom speaker arrays can be accommodated
- The `hoa.decoder~` irregular mode handles non-ideal setups

### ⚠️ Channel Count & CPU

**Computational Cost**:
- High orders require many channels
  - Order 5 in 2D = 11 channels
  - Order 7 in 2D = 15 channels
  - Order 7 in 3D = **64 channels**!
- Each process operates on all channels simultaneously
- Can be CPU intensive with many effects

**Optimization Strategies**:
- Start with lower orders (3-5) and increase as needed
- Use `hoa.process~` to apply effects efficiently to all channels
- 2D requires far fewer channels than 3D for the same order
- Modern computers handle orders 5-7 comfortably for real-time

### ⚠️ Spatial Aliasing

At high frequencies, lower orders can exhibit **spatial aliasing**:
- Aliasing frequency ≈ (order × 343 m/s) / (2π × radius)
- Order 1: Aliasing above ~700 Hz (for 1m radius)
- Order 3: Aliasing above ~2100 Hz
- Order 5: Aliasing above ~3500 Hz
- Higher orders extend accurate spatial reproduction to higher frequencies

**Rule of thumb**: Order 3 is good for most music applications, Order 5+ for critical listening or large arrays.

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

## Ambisonics in Practice: Real-World Considerations

### Order Selection Guidelines

**Order 1** (4 channels in 2D, 4 channels in 3D):
- Basic spatial reproduction
- Good for: wide diffuse sounds, ambience
- Not recommended for: precise source localization
- Use case: Background atmospheres, reverb tails

**Order 3** (7 channels in 2D, 16 channels in 3D):
- **Sweet spot for music production**
- Good balance of quality and efficiency
- Accurate localization for most applications
- Standard for many commercial ambisonic products

**Order 5** (11 channels in 2D, 36 channels in 3D):
- High-quality spatial resolution
- Critical listening applications
- Large speaker arrays
- Minimal spatial aliasing up to ~3.5 kHz

**Order 7+** (15+ channels in 2D, 64+ channels in 3D):
- Research and specialized applications
- Very large dome/sphere installations
- Maximum spatial accuracy
- Requires significant CPU and channel count

### Speaker Array Recommendations

**Minimum**: Number of speakers ≥ Number of harmonics
- Order 3 in 2D → Minimum 7 speakers
- Order 3 in 3D → Minimum 16 speakers

**Optimal**: 1.5× to 2× the number of harmonics
- Order 3 in 2D → 10-14 speakers (better reconstruction)
- Reduces decoding artifacts
- Improves off-center listening

**Practical configurations**:
- **Stereo**: Works but limited (use Order 1-3 max)
- **Quad**: 4 speakers in square (Order 1-2)
- **Octagon**: 8 speakers (Order 3 optimal)
- **16-channel ring**: (Order 5-7)
- **Dome/Sphere**: Requires 3D encoding

### Optimization Types Explained

When decoding, three optimization modes are available:

**Basic** (No optimization):
- Direct decoding without modification
- Best for: **Diffuse sound fields**, ambience, reverb
- Not optimal for: Point sources
- Maintains original harmonic balance

**MaxRE** (Maximum Energy Vector):
- Increases the sweet spot size
- **Allows audience spread over the entire space**
- Trade-off: Reduced spatial resolution
- Best for: Live performances, installations with multiple listeners
- Recommended when off-center listening is important

**InPhase** (Phase-matched decoding):
- Optimizes phase relationships between speakers
- Reduces comb-filtering artifacts
- Better localization for off-center listening
- Trade-off: Some high-frequency spatial blur
- Best for: High-quality monitoring, critical listening

See **Tutorial 08 - Optimization** for interactive demonstrations of these techniques.

---

## Academic Foundations

HoaLibrary is based on rigorous research in spatial audio. Key contributions:

### Theoretical Foundations

**Jérôme Daniel (2001)** - Ph.D. Thesis, Université Paris 6  
*"Représentation de champs acoustiques, application à la transmission et à la reproduction de scènes sonores complexes dans un contexte multimédia"*

This comprehensive work established:
- Mathematical foundation for Higher Order Ambisonics
- Encoding and decoding theory
- Optimization techniques (Basic, MaxRE, InPhase)
- Practical implementation considerations
- [Download (French)](https://tel.archives-ouvertes.fr/tel-00004001/)

### HoaLibrary Research

**Guillot, Paris, Colafrancesco (2014)**  
*"HOA Library, A Set of C++ Classes for High Order Ambisonics"*  
ICMC-SMC Joint Conference, Athens

This paper describes:
- Real-time HOA processing architecture
- 2D and 3D implementations
- Cross-platform design (Max, PD, OpenFrameworks, Faust)
- Performance optimization strategies
- Sound field transformation techniques

### Related Research

**Franz Zotter & Matthias Frank** - Modern ambisonic decoding approaches  
**Fons Adriaensen** - Practical decoder implementation  
**Dave Malham** - Early HOA system development

See the [References page](references.md) for complete citations and additional resources.

---

## Further Reading

### HoaLibrary Resources
- **[Built-in Tutorials](tutorials.md)** - 10 interactive Max patches covering all concepts
- **[Object Reference](OBJECTS.md)** - Complete documentation of all 37 externals
- **[Examples](examples.md)** - 10 ready-to-use patch examples
- **Help Files** - Right-click any object → "Open Help"

### Academic Papers
- [Daniel, J. - "Spatial Sound Encoding"](https://tel.archives-ouvertes.fr/tel-00004001/) - Essential HOA theory
- [Guillot et al. - "HOA Library"](http://hoalibrary.mshparisnord.fr/) - Implementation paper
- [Malham, D. - "Higher Order Ambisonic Systems"](http://www.muse.demon.co.uk/ref/speakers.html) - Early research

### Online Resources
- [Ambisonics on Wikipedia](https://en.wikipedia.org/wiki/Ambisonics) - Good overview
- [Spherical Harmonics](https://en.wikipedia.org/wiki/Spherical_harmonics) - Mathematical foundation
- [Ambisonics.info](http://www.ambisonics.info/) - Community resources
- [IEM Plugins & Papers](https://plugins.iem.at/) - Modern ambisonic tools and research

### Research Institutions
- **CICM** - Université Paris 8 (HoaLibrary origins)
- **IEM** - Graz, Austria (Advanced ambisonic research)
- **IRCAM** - Paris, France (Spatial audio pioneer)
- **CCRMA** - Stanford (Computer music research)

---

## Next Steps

Ready to start? Check out:
- **[Installation Guide](INSTALLATION.md)** - Get HoaLibrary set up
- **[Tutorials](tutorials.md)** - Learn with interactive patches
- **[Object Reference](OBJECTS.md)** - Explore all objects

[← Back to Home](index.md)
