# Comprehensive Knowledge Base: Ambisonics & Granular Synthesis

## Table of Contents
1. [Core Ambisonics Concepts](#core-ambisonics-concepts)
2. [B-Format and Higher Order Ambisonics](#b-format-and-higher-order-ambisonics)
3. [Spatial Encoding & Decoding](#spatial-encoding--decoding)
4. [HOA Library Architecture](#hoa-library-architecture)
5. [Granular Synthesis in Spatial Audio](#granular-synthesis-in-spatial-audio)
6. [Plane Wave Decomposition](#plane-wave-decomposition)
7. [Practical Implementation Strategies](#practical-implementation-strategies)
8. [Advanced Techniques](#advanced-techniques)

---

## Core Ambisonics Concepts

### What is Ambisonics?

**Ambisonics is a full-sphere surround sound technique** that represents audio as a sound field rather than as individual speaker feeds. Key characteristics:

- **Speaker-independent representation** - Ambisonics encodes audio in B-format, which is decoded for specific speaker layouts
- **Scalable spatial resolution** - Higher orders provide better localization
- **Horizontal + vertical coverage** - Full 3D sound field (or 2D for horizontal-only systems)
- **Mathematical foundation** - Based on spherical/circular harmonic decomposition

### Fundamental Differences from Channel-Based Audio

| Ambisonics | Traditional Multichannel |
|------------|-------------------------|
| Speaker-independent | One channel = one speaker |
| Scalable resolution | Fixed channels |
| Rotation/transformation friendly | Difficult to manipulate |
| Requires decoding stage | Direct playback |

### Core Mathematical Representation

**Circular Harmonics** (2D):
- B-format signals represent sound field as weighted sum of spatial functions
- **W** component: Omnidirectional (order 0)
- **X, Y** components: Figure-8 patterns (order 1)
- Higher orders: More directional patterns (clover-leaf shapes)

**Order and Channel Count**:
- **2D systems**: Number of channels = 2N + 1 (where N = order)
  - Order 1: 3 channels
  - Order 3: 7 channels
  - Order 7: 15 channels
- **3D systems**: Number of channels = (N + 1)²
  - Order 1: 4 channels
  - Order 3: 16 channels

---

## B-Format and Higher Order Ambisonics

### First-Order B-Format (FOA)

**Standard B-format** (horizontal plane):
- **W**: Omni component (0° order)
- **X**: Front-back (cos θ)
- **Y**: Left-right (sin θ)
- **Z**: Up-down (for 3D)

### Encoding Point Sources

For encoding a point source at angle θ:

```
W(θ) = s(t) / √2
X(θ) = s(t) × cos(θ)
Y(θ) = s(t) × sin(θ)
```

Where s(t) is the source signal.

**General formula for any order**:
- If index ≥ 0: `H(m,θ) = s(t) × cos(m×θ)`
- If index < 0: `H(m,θ) = s(t) × sin(|m|×θ)`

### Angular Resolution

**Spatial resolution improves with order**:
- Higher orders = more precise source localization
- The "sweet spot" (accurate listening area) enlarges with order
- Order required for frequency f: `N ≈ 2πf × r / c`
  - r = listener distance
  - c = speed of sound

**Practical limits**:
- Order 1: Basic directional cues (~90° resolution)
- Order 3: Good localization for music (~30° resolution)
- Order 7: Very precise imaging (~15° resolution)

---

## Spatial Encoding & Decoding

### Encoding Strategies

**1. Point Source Encoding**
- Place monophonic sources at specific angles
- Control angular resolution using fractional orders
- Simulate distance through amplitude and resolution manipulation

**2. Fractional Orders**
- Interpolate between integer orders
- Creates "source widening" effect
- Value 0 = omnidirectional, Value 1 = full directivity
- Formula: `H'(m, w) = (1-w) × gain_factor × H(m)`

**3. Distance Simulation**
- **Inside circle**: Reduce angular resolution as source approaches center
- **Outside circle**: Attenuate amplitude (1/r² law)
- Combined approach gives perceptual distance cues

### Decoding Methods

**1. Basic/Sampling Decoder**
- Projects harmonics onto speaker positions
- Optimal for centered listener
- Formula for speaker at angle φ:
  ```
  speaker(φ) = W + X×cos(φ) + Y×sin(φ) + ...
  ```

**2. Max-rE Decoder**
- Optimizes for off-center listening positions
- Better for larger listening areas
- Sacrifices some localization for energy spread

**3. In-Phase Decoder**
- Phase-aligned decoding
- Critical when listeners are very close to or outside speaker ring
- Prevents comb filtering artifacts

**4. Binaural Decoding**
- Virtual speaker approach using HRTFs
- Requires many virtual speakers for quality (e.g., 178 positions)
- Matrix convolution approach for efficiency
- HOA Library uses CIPIC HRIR database

---

## HOA Library Architecture

### Design Philosophy

**"By musicians, for musicians"** - The HOA Library (High Order Ambisonics) developed at CICM/University Paris 8 focuses on:
- Musical applications over acoustic accuracy
- Modular architecture
- Real-time performance
- Educational interfaces

### Core C++ Architecture

**Multi-platform approach**:
```
C++ Core Classes
    ├── FAUST implementation
    ├── Max/MSP objects
    ├── Pure Data objects
    ├── VST plugins
    └── Unity integration
```

**Key optimization strategies**:
- Use of Apple Accelerate framework (Mac)
- Intel MKL for matrix operations
- BLAS/FFTW for cross-platform compatibility
- Macro system for float/double precision adaptation

### Coordinate System

**HOA Standard**:
- **0° = Front** (not right, as in math)
- **90° = Left**
- **180° = Back**
- **270° = Right**
- **Rotation = Counter-clockwise**

### Essential Objects & Modules

**Encoding/Decoding**:
- `hoa.encoder~` - Point source encoding
- `hoa.decoder~` - Multi-type decoding
- `hoa.wider~` - Fractional order control
- `hoa.optim~` - Optimization type selection

**Spatial Processing**:
- `hoa.rotate~` - Rotate entire sound field
- `hoa.map~` - Position sources on 2D plane with distance
- `hoa.projector~` - Project to plane waves
- `hoa.recomposer~` - Recompose from plane waves

**Effects**:
- `hoa.plug~` - Apply parallel processing to all harmonics
- `hoa.grain~` - Granular synthesis per harmonic
- `hoa.decorrelation~` - Create diffuse fields
- `hoa.convolve~` - Ambisonic convolution reverb

**Visualization**:
- `hoa.scope~` - Visualize harmonic contributions
- `hoa.meter~` - Circular VU meters for speakers
- `hoa.control` - Interactive harmonic visualization

---

## Granular Synthesis in Spatial Audio

### Historical Context

**Pioneer work**:
- Dennis Gabor (1947) - "Acoustical quanta"
- Iannis Xenakis (1971) - Formalized music with granular concepts
- Curtis Roads - Comprehensive documentation and techniques

### Quasi-Synchronous Granular Synthesis (QSGS)

**Principle** - Generate grains at irregular intervals using:
1. **Delay lines with feedback**
2. **Envelope shaping**
3. **Stochastic parameter variation**

**Key parameters**:
- **Grain duration** (typically 1-100ms)
- **Delay time**
- **Feedback amount** (reinjection)
- **Rarefaction** (density control)
- **Envelope shape** (Gaussian, sine, sinc, etc.)

### Spatial Granular Implementation Strategies

**Approach 1: HOA Per-Harmonic Granulation**
```
For each circular harmonic (m = -N to N):
    Create independent grain stream
    Map parameters based on harmonic index
    Result: Diffuse spatial field
```

**Parameter mapping example** (Order 7):
```python
# Grain size decreases with higher orders
grain_size(m) = max_size × (1 - abs(m)/(N+1))

# Delay increases with order
delay_time(m) = max_delay × (|order_of_m| + 1)/(N+1)
```

**Approach 2: Swarm Spatialization (Ambitools)**
```
For each grain stream (N streams):
    Generate grain with random parameters
    Spatialize at random position (r, θ, φ)
    Encode as HOA point source
    Result: Grain swarm in 3D space
```

### Diffuse Field Synthesis

**Acoustic definition**: A diffuse field has:
- Equal energy from all directions
- No predominant source direction
- Sensation of envelopment

**Synthesis methods**:

**1. Granular per harmonic**
```
Advantages:
+ Natural decorrelation
+ Rich textures
+ Order-dependent spatial behavior

Challenges:
- Parameter count increases with order
- Requires careful envelope design
- Mass depends on order
```

**2. Modulation per harmonic**
```
Process:
1. Encode point source
2. Apply different LFO (1-20 Hz) to each harmonic
3. Creates unstable, moving field

Advantages:
+ Preserves timbre better than granular
+ Simpler parameter set
+ Smoother transitions

Characteristics:
- Source seems to come from multiple places
- Less "grainy" than QSGS
- Good for crossfading with point sources
```

**3. Temporal Decorrelation**
```
Method:
- Apply different delay times to each harmonic
- Use all-pass filters to preserve spectrum
- Avoid simple delays that create flanging

Result:
- Diffuse sensation
- Minimal timbral change
- Works well for reverb applications
```

---

## Plane Wave Decomposition

### Concept

**Alternative representation**: Instead of harmonics, represent sound field as sum of plane waves.

**Relationship to decoding**:
- Ambisonic decoding = projecting onto plane wave basis
- Each "virtual speaker" represents a plane wave direction
- Number of plane waves increases with order

### Use Cases

**1. Directional Filtering**
```
Workflow:
1. Project HOA → plane waves
2. Apply gains to specific directions
3. Optionally recompose to HOA

Application: Hide/reveal parts of sound scene
```

**2. Perspective Distortion (Fisheye Effect)**
```
Process:
1. Project to plane waves (virtual speakers)
2. Remap speaker positions (e.g., compress front, expand back)
3. Recompose to HOA

Musical use: Zoom in/out of spatial scene
```

**3. Spatial Focus**
```
Implementation:
- Create virtual cardioid microphone in HOA
- Point in desired direction
- Isolate sources in that direction

Formula (Order 1):
focused = W + X×cos(θ) + Y×sin(θ)
```

---

## Practical Implementation Strategies

### HOA Workflow Design

**Modular chain architecture**:
```
Input Sources
    ↓
Encoding (hoa.encoder~)
    ↓
Processing (hoa.plug~, effects)
    ↓
Spatial Transform (rotate, wider, etc.)
    ↓
Optimization (hoa.optim~)
    ↓
Decoding (hoa.decoder~ or hoa.binaural~)
    ↓
Speakers/Headphones
```

### CICM Wrapper (Pure Data)

**Key innovations** for PD interface development:
- Widget-based approach (creates canvas in canvas)
- Automatic attribute/property system
- Layer-based drawing with clipping
- Full event handling (mouse, keyboard)
- Matrix transformations for graphics

**Benefits**:
- Consistent UI across objects
- Automatic property windows
- Resizable objects
- Cross-platform (no additional dependencies)

### Performance Optimization

**Computational considerations**:

**Order vs. complexity**:
```
2D: Channels = 2N + 1 (linear)
3D: Channels = (N+1)² (quadratic!)

Processing cost ∝ number of channels
```

**Strategies**:
1. **Use 2D when possible** - Much more efficient
2. **Start low order, scale up** - Test at Order 1-3 first
3. **Optimize per-harmonic processing** - Use SIMD, vectorization
4. **Consider compilation time** - FAUST compilation grows exponentially

**Binaural optimization**:
- Matrix approach vs. per-speaker convolution
- FIR filters with vectorized operations
- Typical CPU usage (Order 7): ~12%

### Real-Time Control

**Automation strategies**:
1. **Direct harmonic access** - Control individual channels
2. **Global parameters** - Rotate, widen, etc.
3. **Trajectory generation** - `hoa.map` for source paths
4. **OSC integration** - External control (sensors, tablets)

---

## Advanced Techniques

### Hybrid Spatial Approaches

**Crossfading between point sources and diffuse fields**:
```
Strategy 1: Parallel paths
- Path A: Point source encoding
- Path B: Diffuse field synthesis
- Mix with crossfader

Strategy 2: Diffusion factor
- Encode point source
- Apply increasing decorrelation to harmonics
- Creates gradual diffusion
```

**Diffusion factor implementation**:
```
For harmonic index m:
    If |m| × diffusion_factor > threshold:
        Apply decorrelation
    Else:
        Pass through
        
Result: Gradual spread from point to diffuse
```

### Near-Field Compensation

**Challenge**: Standard HOA assumes sources on sphere surface (far-field)

**Approaches**:
1. **Daniel's NFC filters** - Frequency-dependent filters per order
   - Accurate but computationally expensive
   - Strong bass boost at close distances
   
2. **Perceptual approach (HOA Library)**:
   - Outside circle: Amplitude attenuation (1/r)
   - Inside circle: Reduce angular resolution
   - Combined: Convincing distance impression

### Reverb in Ambisonics

**Three strategies**:

**1. Per-harmonic algorithmic reverb**
```
Apply Freeverb-style reverb to each harmonic
Different parameters per harmonic
Result: Spatially rich reverb
```

**2. Convolution with ambisonic IRs**
```
Record ambisonic impulse responses
Convolve each harmonic with corresponding IR channel
Most acoustically accurate
```

**3. Hybrid approach**
```
Early reflections: Explicit encoding
Late reverb: Decorrelation/diffuse synthesis
Balance direct/reverb ratio
```

### Advanced Spatial Effects

**Spatial filtering (hao.halo)**:
- Reveal/hide angular sectors
- Time-varying spatial masks
- Useful for mix automation

**Mirror effects**:
- Manipulate negative vs. positive harmonics
- Create symmetries in sound field
- Artistic spatial transformations

**Microphone emulation**:
- Combine harmonics with specific patterns
- Virtual Blumlein pairs
- Coincident arrays of any pattern

---

## Implementation Checklist

### Starting a New Ambisonic Project

1. **Choose Order**:
   - Order 1: Basic testing, headphones, simple systems
   - Order 3: Good music production quality
   - Order 5-7: High-end installations, precise imaging

2. **Speaker Configuration**:
   - Minimum speakers = 2N + 1 (2D) or (N+1)² (3D)
   - Regular spacing preferred for basic decoder
   - Irregular possible with advanced decoders

3. **Processing Chain**:
   ```
   Dry sources → Encoder → Effects (in HOA) → Decoder
   ```

4. **Optimization Selection**:
   - **Basic**: Centered listening only
   - **Max-rE**: Larger listening area
   - **In-phase**: Close to speakers

5. **Monitoring**:
   - Use binaural decode for headphone monitoring
   - Visualize with `hoa.scope~` or `hoa.meter~`
   - Check harmonic balance with `hoa.mixer~`

### Common Pitfalls

❌ **Don't**:
- Mix HOA orders without recomposing
- Decode then re-encode (loses information)
- Use standard stereo effects on B-format
- Ignore optimization choices
- Place listener far outside speaker ring

✅ **Do**:
- Process in HOA domain when possible
- Use binaural for headphone work
- Test with multiple optimization types
- Consider listener position in space
- Use visualization tools during development

---

## Resources & Tools

### Software Ecosystems

**Max/MSP**: HOA Library, SPAT~, ICST Ambisonics
**Pure Data**: HOA Library, IEM Plugin Suite
**FAUST**: HOA Library FAUST, Ambitools
**SuperCollider**: SC-HOA, ATK, Antescollider
**DAWs**: Reaper (excellent multichannel), ProTools, Nuendo

### File Formats

**AmbiX** (current standard):
- `.caf` or `.wav` container
- SN3D normalization
- ACN channel ordering
- YouTube 360 compatible

**FuMa** (legacy):
- `.amb` format
- Up to 3rd order
- 4GB file limit

### Further Reading

**Foundational Papers**:
- Gerzon (1974) - "The Design of Precisely Coincident Microphone Arrays"
- Daniel (2000) - "Representation de champs acoustiques..."
- Malham (1992) - "Experience with Large Area 3D Ambisonics"

**Practical Guides**:
- HOA Library documentation
- Ambisonics.net wiki
- IEM documentation
- Faust documentation

---

## Quick Reference Tables

### Order Selection Guide

| Order | Channels (2D) | Min Speakers | Use Case |
|-------|---------------|--------------|----------|
| 1 | 3 | 4 | Basic testing, education |
| 2 | 5 | 6 | Small rooms, installations |
| 3 | 7 | 8 | Music production standard |
| 5 | 11 | 12 | High-quality immersive |
| 7 | 15 | 16 | Research, premium installations |

### Parameter Ranges

| Parameter | Typical Range | Notes |
|-----------|---------------|-------|
| Grain size | 5-100 ms | Shorter = more texture |
| LFO frequency | 0.1-20 Hz | For modulation decorrelation |
| Reinjection | 0-95% | Feedback for grain延 |
| Rarefaction | 0-100% | Grain density |
| Diffusion factor | 0-1 | Point to diffuse |

---

## Conclusion

This knowledge base covers the essential concepts for working with ambisonics and spatial granular synthesis. The key takeaways:

1. **Ambisonics is a scene-based approach** - Think sound fields, not channels
2. **Order determines resolution** - Higher order = better localization
3. **Granular synthesis in HOA** - Rich textures through per-harmonic or swarm approaches
4. **Plane waves offer intuitive processing** - Directional filtering and spatial effects
5. **Diffuse fields extend creative palette** - From point sources to envelopment
6. **Implementation requires optimization** - Balance quality vs. computational cost

The HOA Library philosophy of "by musicians, for musicians" demonstrates that ambisonics can be both technically rigorous and musically expressive. Experiment, listen critically, and let your ears guide the process!

---

*Compiled from: Wikipedia Ambisonics article, HOA Library documentation, CICM research papers (Guillot, Paris, Colafrancesco, Sèdes, Bonardi), and Ambitools/Antescollider documentation (Lecomte, Fernandez)*