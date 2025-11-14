# HoaLibrary API Reference

**Version**: 3.0  
**Documentation**: Complete API reference for all Max objects and C++ classes  
**Organization**: Grouped by Max object with corresponding C++ implementation details

**📚 See also:**
- [Object Reference](OBJECTS.html) - Quick object list
- [Knowledge Base](knowledge_base/index.html) - Theory and workflows
- [C++ Refresher](CPP_REFRESHER.html) - C++ language review
- [Architecture](ARCHITECTURE.html) - System design

---

## Table of Contents

### 2D Objects
- [hoa.2d.encoder~](#hoa2dencoder) - Encode mono to 2D harmonics
- [hoa.2d.decoder~](#hoa2ddecoder) - Decode 2D harmonics to speakers
- [hoa.2d.rotate~](#hoa2drotate) - Rotate 2D sound field
- [hoa.2d.wider~](#hoa2dwider) - Control directivity/width
- [hoa.2d.optim~](#hoa2doptim) - Apply optimization (MaxRE, InPhase)
- [hoa.2d.map~](#hoa2dmap) - Spatial mapping
- [hoa.2d.vector~](#hoa2dvector) - Velocity vector
- [hoa.2d.meter~](#hoa2dmeter) - Level metering
- [hoa.2d.scope~](#hoa2dscope) - Circular visualization
- [hoa.2d.space](#hoa2dspace) - GUI spatial control
- [hoa.2d.recomposer](#hoa2drecomposer) - Harmonic recomposition
- [hoa.2d.exchanger~](#hoa2dexchanger) - Channel ordering conversion
- [hoa.2d.projector~](#hoa2dprojector) - Microphone array projection

### 3D Objects
- [hoa.3d.encoder~](#hoa3dencoder) - Encode mono to 3D harmonics
- [hoa.3d.decoder~](#hoa3ddecoder) - Decode 3D harmonics to speakers
- [hoa.3d.rotate~](#hoa3drotate) - Rotate 3D sound field
- [hoa.3d.wider~](#hoa3dwider) - Control 3D directivity
- [hoa.3d.optim~](#hoa3doptim) - 3D optimization
- [hoa.3d.map~](#hoa3dmap) - 3D spatial mapping
- [hoa.3d.vector~](#hoa3dvector) - 3D velocity vector
- [hoa.3d.meter~](#hoa3dmeter) - 3D level metering
- [hoa.3d.scope~](#hoa3dscope) - Spherical visualization
- [hoa.3d.exchanger~](#hoa3dexchanger) - 3D channel ordering

### Common Objects
- [hoa.process~](#hoaprocess) - Process suite container
- [hoa.in~/hoa.out~](#hoainout) - Process suite I/O
- [hoa.pi~/hoa.pi](#hoapi) - Process suite parameter
- [hoa.connect](#hoaconnect) - Auto-connection utility
- [hoa.dac~](#hoadac) - Ambisonic DAC
- [c.convolve~](#cconvolve) - FFT convolution
- [c.freeverb~](#cfreeverb) - Freeverb reverb

### C++ Core Classes
- [Encoder Class](#encoder-class) - Encoding DSP implementation
- [Decoder Class](#decoder-class) - Decoding DSP implementation
- [Rotate Class](#rotate-class) - Rotation DSP implementation
- [Wider Class](#wider-class) - Wider effect implementation
- [Optim Class](#optim-class) - Optimization implementation
- [Math Class](#math-class) - Mathematical utilities
- [Signal Class](#signal-class) - Signal processing utilities
- [Harmonics Class](#harmonics-class) - Harmonic domain utilities

---

## 2D Objects

### hoa.2d.encoder~

**Description**: Encodes a mono signal into 2D circular harmonics

**File**: `Max2D/hoa.2d.encoder_tilde.cpp`  
**C++ Class**: `Encoder<Hoa2d, t_sample>::Basic`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 | signal | Audio signal to encode |
| 1 | signal/float | Azimuth angle in radians (0 = front, π/2 = left) |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to N | signal | Harmonic channels (N = 2*order + 1) |

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `int` | angle | Set azimuth as integer |
| `float` | angle | Set azimuth as float in radians |

#### C++ Implementation

```cpp
// Core encoding class
Encoder<Hoa2d, t_sample>::Basic* f_encoder;

// Initialization
f_encoder = new Encoder<Hoa2d, t_sample>::Basic(order);

// Set azimuth
f_encoder->setAzimuth(angle_in_radians);

// Process (sample-by-sample or block)
f_encoder->process(input_sample, output_harmonics);
```

**Key Methods**:
- `setAzimuth(T azimuth)` - Set encoding angle (0 to 2π)
- `getAzimuth()` - Get current azimuth
- `setMute(bool)` - Mute/unmute encoder
- `getMute()` - Get mute state
- `process(const T* input, T* outputs)` - Encode signal

**Algorithm**: Uses angle recurrence relations for efficient cos/sin computation:
```cpp
// Pre-compute cos/sin for base angle
m_cosx = cos(m_azimuth);
m_sinx = sin(m_azimuth);

// Use recurrence for higher orders:
// cos(nθ) = cos((n-1)θ) * cos(θ) - sin((n-1)θ) * sin(θ)
// sin(nθ) = sin((n-1)θ) * cos(θ) + cos((n-1)θ) * sin(θ)
```

**Performance**: ~12 ns per sample @ Order 7 on Apple M1

---

### hoa.2d.decoder~

**Description**: Decodes 2D circular harmonics to speaker signals

**File**: `Max2D/hoa.2d.decoder_tilde.cpp`  
**C++ Classes**: 
- `Decoder<Hoa2d, float>::Regular`
- `Decoder<Hoa2d, float>::Irregular`  
- `Decoder<Hoa2d, float>::Binaural`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |
| channels | int | 4 | Number of speakers |

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@mode` | symbol | Decoding mode: `regular`, `irregular`, `binaural` |
| `@channels` | int | Number of speakers (regular/irregular) |
| `@angles` | list | Speaker angles in degrees |
| `@offset` | float | Global rotation offset |
| `@crop` | int | Crop size for binaural (128-8192) |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels (N = 2*order + 1) |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to M | signal | Speaker/headphone signals |

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `angles` | float list | Set speaker angles in degrees |
| `offset` | float | Set rotation offset in degrees |
| `channels` | int | Set number of speakers |
| `crop` | int | Set binaural crop size |

#### Decoder Modes

##### Regular Decoder
**Use**: Equal-spaced circular speaker arrays  
**Algorithm**: Sampling theorem (mode-matching)  
**C++ Class**: `Decoder<Hoa2d, float>::Regular`

```cpp
// Create regular decoder
auto decoder = new Decoder<Hoa2d, float>::Regular(order, num_speakers);

// Process
decoder->process(harmonics_in, speakers_out);
```

**Decoding Matrix**: Pre-computed as:
```
speakers[i] = Σ(harmonics[j] × decoding_matrix[i][j])
```

##### Irregular Decoder
**Use**: Non-equal spacing, < minimum speakers, stereo, 5.1, etc.  
**Algorithm**: Pseudo-inverse (least-squares optimization)  
**C++ Class**: `Decoder<Hoa2d, float>::Irregular`

```cpp
// Create irregular decoder
auto decoder = new Decoder<Hoa2d, float>::Irregular(order, num_speakers);

// Set custom angles
for(int i = 0; i < num_speakers; i++)
    decoder->setPlanewaveAzimuth(i, angles[i]);

// Compute rendering
decoder->computeRendering();

// Process
decoder->process(harmonics_in, speakers_out);
```

##### Binaural Decoder
**Use**: Headphone reproduction with HRTF  
**Algorithm**: HRTF convolution (IRCAM IRC_1002_C database)  
**C++ Class**: `Decoder<Hoa2d, float>::Binaural`

```cpp
// Create binaural decoder
auto decoder = new Decoder<Hoa2d, float>::Binaural(order);

// Set vector size for FFT (power of 2)
decoder->computeRendering(crop_size);

// Process block
decoder->processBlock((float const**)harmonics_in, (float**)stereo_out);
```

**Performance**: 
- Regular: ~45 ns/sample (scalar), ~13 ns (SIMD potential)
- Irregular: Similar to regular after pre-computation
- Binaural: Block processing, FFT-based (efficient)

---

### hoa.2d.rotate~

**Description**: Rotates the 2D ambisonic sound field

**File**: `Max2D/hoa.2d.rotate_tilde.cpp`  
**C++ Class**: `Rotate<Hoa2d, t_sample>`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels (N = 2*order + 1) |
| N+1 | signal/float | Rotation angle (yaw) in radians |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to N | signal | Rotated harmonic channels |

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `int` | angle | Set yaw angle as integer |
| `float` | angle | Set yaw angle in radians |

#### C++ Implementation

```cpp
// Core rotation class
Rotate<Hoa2d, t_sample>* f_rotate;

// Initialization
f_rotate = new Rotate<Hoa2d, t_sample>(order);

// Set rotation angle
f_rotate->setYaw(angle_in_radians);

// Process
f_rotate->process(harmonics_in, harmonics_out);
```

**Key Methods**:
- `setYaw(T angle)` - Set rotation angle
- `getYaw()` - Get current rotation
- `process(const T* inputs, T* outputs)` - Rotate sound field

**Algorithm**: Phase shift in harmonic domain
```
For rotation angle α:
  H'_{n,-n} = cos(nα) × H_{n,-n} - sin(nα) × H_{n,+n}
  H'_{n,+n} = cos(nα) × H_{n,+n} + sin(nα) × H_{n,-n}
```

Uses recurrence relations for efficiency (same as encoder).

**Performance**: ~14 ns per sample @ Order 7 on Apple M1

---

### hoa.2d.wider~

**Description**: Controls the directivity/width of the sound field

**File**: `Max2D/hoa.2d.wider_tilde.cpp`  
**C++ Class**: `Wider<Hoa2d, t_sample>`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels (N = 2*order + 1) |
| N+1 | signal/float | Width parameter (0-1) |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to N | signal | Width-modified harmonic channels |

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `float` | width | Set width (0 = omnidirectional, 1 = focused) |

#### C++ Implementation

```cpp
// Core wider class
Wider<Hoa2d, t_sample>* f_wider;

// Initialization
f_wider = new Wider<Hoa2d, t_sample>(order);

// Set width
f_wider->setWidening(width_value);

// Process
f_wider->process(harmonics_in, harmonics_out);
```

**Key Methods**:
- `setWidening(T width)` - Set width parameter (0-1)
- `getWidening()` - Get current width
- `process(const T* inputs, T* outputs)` - Apply width effect

**Algorithm**: Per-degree gain modulation
```
For each harmonic degree l:
  gain(l) = f(order_N, degree_l, width_x)
  
  H'_l = H_l × gain(l)
```

Width = 0: All harmonics equally weighted (omnidirectional)  
Width = 1: Higher orders attenuated (focused, plane wave)

**Performance**: ~8 ns per sample @ Order 7 on Apple M1

---

### hoa.2d.optim~

**Description**: Applies decoder optimization (Basic, MaxRE, InPhase)

**File**: `Max2D/hoa.2d.optim_tilde.cpp`  
**C++ Class**: `Optim<Hoa2d, t_sample>`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@mode` | symbol | Optimization: `basic`, `maxRe`, `inPhase` |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels (N = 2*order + 1) |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to N | signal | Optimized harmonic channels |

#### Optimization Modes

##### Basic
**Description**: No optimization, flat response  
**Use**: Maximum spatial resolution within order limit  
**Trade-off**: Smaller sweet spot

##### MaxRE (Maximum Energy Vector)
**Description**: Increases listening area size  
**Algorithm**: Harmonic weighting by degree
```cpp
weight(l) = cos^l(137.9° / (N + 1.51))
```
**Use**: Larger sweet spot, more robust to head movement  
**Trade-off**: Slightly reduced localization accuracy

##### InPhase
**Description**: Phase-matched decoding  
**Algorithm**: Different weighting curve  
**Use**: Reduced comb-filtering, smoother response  
**Trade-off**: Some loss of spatial definition

#### C++ Implementation

```cpp
// Core optimization class
Optim<Hoa2d, t_sample>* f_optim;

// Initialization
f_optim = new Optim<Hoa2d, t_sample>(order);

// Set mode
f_optim->setMode(Optim<Hoa2d, t_sample>::MaxRe);

// Process
f_optim->process(harmonics_in, harmonics_out);
```

**Performance**: ~5 ns per sample @ Order 7 (simple multiplication)

---

### hoa.2d.map~

**Description**: Maps virtual microphones/sources in the sound field

**File**: `Max2D/hoa.2d.map_tilde.cpp`  
**C++ Class**: Custom Max implementation

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order |
| points | int | 1 | Number of virtual points |

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@channels` | int | Number of virtual points |
| `@mode` | symbol | `microphone` or `source` |
| `@angles` | list | Angles of virtual points |
| `@mute` | list | Mute state for each point |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to M | signal | Virtual point outputs |

**Use Cases**:
- Virtual microphone array (extract directional signals)
- Multi-source encoding (encode multiple sources)
- Spatial filtering

---

### hoa.2d.vector~

**Description**: Computes velocity/energy vector from harmonics

**File**: `Max2D/hoa.2d.vector_tilde.cpp`  
**C++ Class**: `Vector<Hoa2d, t_sample>`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 | signal | X component (left/right) |
| 1 | signal | Y component (front/back) |
| 2 | signal | Energy (magnitude) |

#### C++ Implementation

```cpp
Vector<Hoa2d, t_sample>* f_vector;

f_vector = new Vector<Hoa2d, t_sample>(order);

// Process
f_vector->process(harmonics_in, vector_out);

// Outputs: vector_out[0] = X, vector_out[1] = Y, vector_out[2] = Energy
```

**Algorithm**: Weighted sum of harmonics
```
X = W × H_{1,1}
Y = W × H_{1,-1}
Energy = sqrt(X² + Y²)
```

**Use**: Visualize sound field direction and intensity

---

### hoa.2d.meter~

**Description**: Measures RMS levels of harmonics

**File**: `Max2D/hoa.2d.meter_gui_tilde.cpp`  
**C++ Class**: `Meter<Hoa2d, t_sample>` + Max GUI

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order |

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@interval` | int | Update interval in ms |
| `@vectors` | int | Display velocity vector |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 | list | RMS values for all harmonics |
| 1 | list | Peak values |
| 2 | list | Velocity vector [x, y] |

**GUI**: Visual meter display with harmonic levels

---

### hoa.2d.scope~

**Description**: Circular visualization of the sound field

**File**: `Max2D/hoa.2d.scope_gui_tilde.cpp`  
**C++ Class**: `Scope<Hoa2d, t_sample>` + Max GUI

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order |

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@gain` | float | Display gain |
| `@interval` | int | Refresh rate in ms |
| `@view` | symbol | `circular` or `polar` |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 to N | signal | Harmonic channels |

**GUI**: Real-time circular/polar visualization

---

### hoa.2d.space

**Description**: GUI for spatial positioning

**File**: `Max2D/hoa.2d.space_gui.cpp`  
**Type**: UI object (non-DSP)

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `source` | index x y | Set source position |
| `zoom` | float | Set zoom level |

#### Outlets

| Outlet | Type | Description |
|--------|------|-------------|
| 0 | list | Source positions [index, azimuth, radius] |

**GUI**: Interactive circular space for positioning sources

---

### hoa.2d.recomposer

**Description**: Harmonic recomposition with fisheye/fixation effects

**File**: `Max2D/hoa.2d.recomposer_gui.cpp`  
**C++ Class**: `Recomposer<Hoa2d, t_sample>`

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@mode` | symbol | `fixation` or `fisheye` |
| `@factor` | float | Effect intensity |

**Effects**:
- **Fixation**: Lock sound sources in space during rotation
- **Fisheye**: Warp spatial perception (zoom effect)

---

### hoa.2d.exchanger~

**Description**: Convert between channel orderings (ACN ↔ FuMa)

**File**: `Max2D/hoa.2d.exchanger_tilde.cpp`  
**C++ Class**: `Exchanger<Hoa2d, t_sample>`

#### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `@mode` | symbol | `acn` or `fuma` |

**Conversions**:
- ACN (Ambisonic Channel Numbering) - Modern standard
- FuMa (Furse-Malham) - Legacy B-format

---

### hoa.2d.projector~

**Description**: Project microphone array recordings to ambisonics

**File**: `Max2D/hoa.2d.projector_tilde.cpp`  
**C++ Class**: `Projector<Hoa2d, t_sample>`

#### Use**: Encode real microphone array recordings into ambisonic format

---

## 3D Objects

### hoa.3d.encoder~

**Description**: Encodes mono signal into 3D spherical harmonics

**File**: `Max3D/hoa.3d.encoder_tilde.cpp`  
**C++ Class**: `Encoder<Hoa3d, t_sample>::Basic`

#### Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| order | int | 1 | Ambisonic order (1-35) |

#### Inlets

| Inlet | Type | Description |
|-------|------|-------------|
| 0 | signal | Audio signal |
| 1 | signal/float | Azimuth in radians |
| 2 | signal/float | Elevation in radians |

#### Outlets

| Outlets | Type | Description |
|---------|------|-------------|
| 0 to N | signal | Spherical harmonics (N = (order+1)²) |

**3D Differences**:
- Additional elevation parameter
- More harmonics: (N+1)² vs 2N+1
- Order 1 = 4 channels, Order 7 = 64 channels

#### C++ Implementation

```cpp
Encoder<Hoa3d, t_sample>::Basic* f_encoder;

f_encoder = new Encoder<Hoa3d, t_sample>::Basic(order);

f_encoder->setAzimuth(azimuth);
f_encoder->setElevation(elevation);

f_encoder->process(input, harmonics_out);
```

---

### hoa.3d.decoder~

**Description**: Decodes 3D spherical harmonics to speakers

**File**: `Max3D/hoa.3d.decoder_tilde.cpp`  
**C++ Classes**:
- `Decoder<Hoa3d, float>::Regular`
- `Decoder<Hoa3d, float>::Binaural`

**Similar to 2D decoder** but with:
- Spherical speaker arrays
- More complex HRTF (full sphere)
- Elevation angles in addition to azimuth

---

### hoa.3d.rotate~

**Description**: Rotates 3D sound field (yaw, pitch, roll)

**File**: `Max3D/hoa.3d.rotate_tilde.cpp`  
**C++ Class**: `Rotate<Hoa3d, t_sample>`

#### Inlets

| Inlet | Description |
|-------|-------------|
| N+1 | Yaw (rotation around Z axis) |
| N+2 | Pitch (rotation around Y axis) |
| N+3 | Roll (rotation around X axis) |

**Algorithm**: Uses Wigner D-matrices (more complex than 2D)

**Performance**: O(N²) complexity for 3D rotation

---

### hoa.3d.wider~, hoa.3d.optim~, etc.

**Similar functionality to 2D equivalents** but operating on spherical harmonics.

---

## Common Objects

### hoa.process~

**Description**: Container for ambisonic processing chains (like poly~)

**File**: `MaxCommon/hoa.process_tilde.cpp`

#### Features
- Encapsulates processing algorithms
- Multiple instances managed centrally
- Load custom DSP patches

#### Messages

| Message | Arguments | Description |
|---------|-----------|-------------|
| `open` | patcher | Load processing patcher |
| `order` | int | Set ambisonic order |

**Use**: Build complex effects chains (reverb, delay, granular, etc.)

---

### hoa.in~ / hoa.out~

**Description**: Inputs/outputs for hoa.process~ suite

**Files**: 
- `MaxCommon/hoa.in_tilde.cpp`
- `MaxCommon/hoa.out_tilde.cpp`

**Use inside hoa.process~ patches** to define I/O

---

### hoa.pi~ / hoa.pi

**Description**: Parameters for hoa.process~ suite

**Files**:
- `MaxCommon/hoa.pi_tilde.cpp`
- `MaxCommon/hoa.pi.cpp`

**Use**: Expose parameters from hoa.process~ to parent patch

---

### hoa.connect

**Description**: Auto-connection utility for ambisonic patches

**File**: `MaxCommon/hoa.connect.cpp`

**Features**:
- Automatic patching of ambisonic chains
- Recognizes object types (harmonics/planewaves)
- Saves time building complex patches

---

### hoa.dac~

**Description**: DAC with ambisonic channel routing

**File**: `MaxCommon/hoa.dac_tilde.c`

**Features**:
- Maps ambisonic outputs to audio interface
- Channel offset configuration
- Mute/solo per channel

---

### c.convolve~

**Description**: Efficient FFT convolution

**Files**: 
- `MaxCommon/c.convolve_tilde.cpp`
- `MaxCommon/FFTConvolver.cpp`
- `MaxCommon/AudioFFT.cpp`

#### Algorithm

**FFT-based convolution**:
1. Convert input to frequency domain (FFT)
2. Complex multiplication with IR spectrum
3. Convert back to time domain (IFFT)

**Advantages**:
- O(N log N) vs O(N²) for time-domain
- Efficient for long impulse responses
- Used by binaural decoder

#### C++ Classes

**AudioFFT**: Wrapper for platform FFT libraries
- macOS: vDSP (Accelerate framework)
- Windows: Intel IPP or FFTW
- Linux: FFTW

**FFTConvolver**: Overlap-add convolution engine
```cpp
class FFTConvolver {
    void init(int blockSize, const float* ir, int irLen);
    void process(const float* input, float* output, int len);
};
```

**Performance**: Highly optimized, uses SIMD

---

### c.freeverb~

**Description**: Freeverb reverb algorithm

**File**: `MaxCommon/c.freeverb_tilde.cpp`

#### Algorithm

**Schroeder reverberator**:
- 8 parallel comb filters
- 4 series allpass filters
- Adjustable room size, damping, wet/dry

**Use in ambisonics**: Apply per-harmonic for spatial reverb

---

## C++ Core Classes

### Encoder Class

**File**: `ThirdParty/HoaLibrary/Sources/Encoder.hpp`

```cpp
template <Dimension D, typename T>
class Encoder : public Processor<D, T>::Harmonics
{
public:
    class Basic;   // Basic encoder (azimuth/elevation)
    class DC;      // Distance compensation encoder
    class Multi;   // Multiple source encoder
};
```

#### Encoder::Basic

**Purpose**: Encode point source to harmonics

**Template Specializations**:
- `Encoder<Hoa2d, T>::Basic` - 2D encoding
- `Encoder<Hoa3d, T>::Basic` - 3D encoding

**Key Methods**:
```cpp
// 2D
void setAzimuth(T azimuth);
T getAzimuth() const;

// 3D (additional)
void setElevation(T elevation);
T getElevation() const;

// Common
void setMute(bool muted);
bool getMute() const;
void process(const T* input, T* outputs);
void processAdd(const T* input, T* outputs);  // Accumulate
```

**Algorithm Details**:

**2D Encoding**:
```
H_0 = s(t)                    [Omnidirectional]
H_{1,-1} = s(t) × sin(θ)      [Order 1, negative]
H_{1,+1} = s(t) × cos(θ)      [Order 1, positive]
H_{n,-n} = s(t) × sin(nθ)     [Order n, negative]
H_{n,+n} = s(t) × cos(nθ)     [Order n, positive]
```

**Implementation** (with recurrence):
```cpp
void process(const T* input, T* outputs) {
    T cos_x = m_cosx;  // cos(θ)
    T sin_x = m_sinx;  // sin(θ)
    T tcos_x = cos_x;
    
    outputs[0] = input[0];           // H_0
    outputs[1] = input[0] * sin_x;   // H_{1,-1}
    outputs[2] = input[0] * cos_x;   // H_{1,+1}
    
    for(ulong i = 2; i <= order; i++) {
        // Recurrence for cos(iθ), sin(iθ)
        cos_x = tcos_x * m_cosx - sin_x * m_sinx;
        sin_x = tcos_x * m_sinx + sin_x * m_cosx;
        tcos_x = cos_x;
        
        outputs[2*i-1] = input[0] * sin_x;
        outputs[2*i] = input[0] * cos_x;
    }
}
```

**Complexity**: O(N) where N = order

#### Encoder::DC

**Purpose**: Distance compensation (simulates distance from center)

**Additional Methods**:
```cpp
void setRadius(T radius);
T getRadius() const;
```

**Algorithm**:
- **Inside ambisonic circle** (r < 1): Fractional order simulation
- **Outside** (r ≥ 1): Gain attenuation (1/r law)

**Use**: Create distance-based panning within ambisonic scene

#### Encoder::Multi

**Purpose**: Encode multiple sources simultaneously

**Methods**:
```cpp
void setNumberOfSources(ulong sources);
ulong getNumberOfSources() const;

void setAzimuth(ulong index, T azimuth);
void setRadius(ulong index, T radius);
void setMute(ulong index, bool muted);

void process(const T* inputs, T* outputs);
```

**Implementation**: Array of DC encoders, sum outputs

---

### Decoder Class

**File**: `ThirdParty/HoaLibrary/Sources/Decoder.hpp`

```cpp
template <Dimension D, typename T>
class Decoder : public Processor<D, T>::Harmonics,
                public Processor<D, T>::Planewaves
{
public:
    class Regular;    // Equal-spaced arrays
    class Irregular;  // Non-uniform arrays
    class Binaural;   // Headphone/HRTF
};
```

#### Decoder::Regular

**Purpose**: Decode to equal-spaced speaker arrays

**Methods**:
```cpp
// Constructor
Regular(ulong order, ulong numSpeakers);

// Computation (call once after setup)
void computeRendering();

// Processing
void process(const T* harmonics, T* speakers);
```

**Algorithm**: Mode-matching (sampling theorem)

**Decoding Matrix**:
```
For speaker i at angle θ_i:
  speaker[i] = Σ(harmonics[j] × Y_j(θ_i))
  
Where Y_j(θ) are the circular/spherical harmonics sampled at θ
```

**Pre-computation**:
```cpp
// Compute decoding matrix (once)
for(int i = 0; i < numSpeakers; i++) {
    for(int j = 0; j < numHarmonics; j++) {
        m_matrix[i][j] = computeHarmonic(j, speakerAngle[i]);
    }
}

// Processing (per sample)
for(int i = 0; i < numSpeakers; i++) {
    float sum = 0;
    for(int j = 0; j < numHarmonics; j++) {
        sum += harmonics[j] * m_matrix[i][j];
    }
    speakers[i] = sum;
}
```

**Complexity**: O(N × M) where N=harmonics, M=speakers

**Minimum Speakers**:
- 2D Order N: Minimum 2N+1 speakers
- 3D Order N: Minimum (N+1)² speakers

#### Decoder::Irregular

**Purpose**: Non-uniform speaker placement

**Additional Methods**:
```cpp
void setPlanewaveAzimuth(ulong index, T azimuth);
void setPlanewaveElevation(ulong index, T elevation);  // 3D only

T getPlanewaveAzimuth(ulong index) const;
T getPlanewaveElevation(ulong index) const;
```

**Algorithm**: Pseudo-inverse (Moore-Penrose)

```
Solve: A × weights = harmonics (least-squares)

weights = (A^T × A)^-1 × A^T × harmonics
```

**Advantages**:
- Works with < minimum speakers
- Arbitrary positioning (stereo, 5.1, 7.1, etc.)
- Robust solution

**Trade-offs**:
- More complex computation
- May have nulls in response
- Lower spatial accuracy

#### Decoder::Binaural

**Purpose**: Headphone reproduction with HRTF

**Methods**:
```cpp
Binaural(ulong order);

void computeRendering(ulong vectorSize = 64);

// Block processing (not sample-by-sample)
void processBlock(const T** harmonics, T** stereo);
```

**Algorithm**:
1. Decode to virtual speaker array (32-64 planewaves)
2. Convolve each planewave with HRTF for that direction
3. Sum convolved signals for L/R ears

**HRTF Database**: IRCAM IRC_1002_C
- 2D: Horizontal plane (187 measurements)
- 3D: Full sphere (~1000 measurements)
- 44.1 kHz sample rate

**Implementation**:
```cpp
// For each virtual speaker:
for(int i = 0; i < numVirtualSpeakers; i++) {
    // Convolve with left ear HRTF
    convolve(planewave[i], hrtf_left[i], ear_left_temp);
    
    // Convolve with right ear HRTF
    convolve(planewave[i], hrtf_right[i], ear_right_temp);
    
    // Accumulate
    ear_left += ear_left_temp;
    ear_right += ear_right_temp;
}
```

**Performance**: FFT-based, block processing for efficiency

---

### Rotate Class

**File**: `ThirdParty/HoaLibrary/Sources/Rotate.hpp`

```cpp
template <Dimension D, typename T>
class Rotate : public Processor<D, T>::Harmonics
{
public:
    Rotate(ulong order);
    
    // 2D
    void setYaw(T angle);
    T getYaw() const;
    
    // 3D (additional)
    void setPitch(T angle);
    void setRoll(T angle);
    T getPitch() const;
    T getRoll() const;
    
    void process(const T* harmonics_in, T* harmonics_out);
};
```

**2D Algorithm**: Phase shift
```
H'_{n,-n} = cos(nα) × H_{n,-n} - sin(nα) × H_{n,+n}
H'_{n,+n} = cos(nα) × H_{n,+n} + sin(nα) × H_{n,-n}
```

**3D Algorithm**: Wigner D-matrix rotation
- More complex than 2D
- Involves all three Euler angles
- O(N²) complexity

---

### Wider Class

**File**: `ThirdParty/HoaLibrary/Sources/Wider.hpp`

```cpp
template <Dimension D, typename T>
class Wider : public Processor<D, T>::Harmonics
{
public:
    Wider(ulong order);
    
    void setWidening(T width);  // 0 to 1
    T getWidening() const;
    
    void process(const T* harmonics_in, T* harmonics_out);
};
```

**Algorithm**:
```cpp
// Pre-compute gain factors
for(int degree = 0; degree <= order; degree++) {
    m_factors[degree] = computeGain(order, degree, width);
}

// Processing
outputs[0] = inputs[0];  // Degree 0 unchanged
for(int degree = 1; degree <= order; degree++) {
    for(int order = -degree; order <= degree; order++) {
        int index = getHarmonicIndex(degree, order);
        outputs[index] = inputs[index] * m_factors[degree];
    }
}
```

---

### Optim Class

**File**: `ThirdParty/HoaLibrary/Sources/Optim.hpp`

```cpp
template <Dimension D, typename T>
class Optim : public Processor<D, T>::Harmonics
{
public:
    enum Mode { Basic, MaxRe, InPhase };
    
    Optim(ulong order);
    
    void setMode(Mode mode);
    Mode getMode() const;
    
    void process(const T* harmonics_in, T* harmonics_out);
};
```

**Implementation**:
```cpp
// MaxRE weights
const T theta = T(137.9 * HOA_PI / 180.0) / T(order + 1.51);
for(int l = 0; l <= order; l++) {
    m_weights[l] = pow(cos(theta), T(l));
}

// Processing
for(int l = 0; l <= order; l++) {
    T weight = m_weights[l];
    for(int m = -l; m <= l; m++) {
        int index = getHarmonicIndex(l, m);
        outputs[index] = inputs[index] * weight;
    }
}
```

---

### Math Class

**File**: `ThirdParty/HoaLibrary/Sources/Math.hpp`

```cpp
template <typename T>
class Math
{
public:
    // Clipping
    static inline T clip(const T& n, const T& lower, const T& upper);
    
    // Angle wrapping
    static inline T wrap_twopi(const T& value);  // [0, 2π]
    static inline T wrap_pi(const T& value);     // [-π, π]
    
    // Coordinate conversion
    static inline T abscissa(const T radius, const T azimuth, const T elevation = 0);
    static inline T ordinate(const T radius, const T azimuth, const T elevation = 0);
    static inline T height(const T radius, const T elevation);
    
    static inline T radius(const T x, const T y, const T z = 0);
    static inline T azimuth(const T x, const T y, const T z = 0);
    static inline T elevation(const T x, const T y, const T z);
};
```

**Usage Examples**:
```cpp
// Clip value
float clipped = Math<float>::clip(value, 0.0f, 1.0f);

// Wrap angle to [0, 2π]
float wrapped = Math<float>::wrap_twopi(angle);

// Spherical to Cartesian
float x = Math<float>::abscissa(radius, azimuth, elevation);
float y = Math<float>::ordinate(radius, azimuth, elevation);
float z = Math<float>::height(radius, elevation);

// Cartesian to Spherical
float r = Math<float>::radius(x, y, z);
float az = Math<float>::azimuth(x, y, z);
float el = Math<float>::elevation(x, y, z);
```

---

### Signal Class

**File**: `ThirdParty/HoaLibrary/Sources/Signal.hpp`

```cpp
template <typename T>
class Signal
{
public:
    // Memory allocation
    static inline T* alloc(ulong size);
    static inline T* free(T* vec);
    
    // Basic operations
    static inline void clear(ulong size, T* vector);
    static inline void copy(ulong size, const T* input, T* output);
    static inline void copy(ulong size, const T* input, ulong istride, 
                           T* output, ulong ostride);
    
    // Vector operations
    static inline void add(ulong size, const T* input, T* output);
    static inline void sub(ulong size, const T* input, T* output);
    static inline void scale(ulong size, const T factor, T* vector);
    
    // Matrix operations
    static inline void mul(ulong colsize, ulong rowsize, 
                          const T* in, const T* matrix, T* output);
    static inline void mul(ulong m, ulong n, ulong l, 
                          const T* in1, const T* in2, T* output);
    
    // Analysis
    static inline T max(ulong size, const T* vector);
    static inline T sum(ulong size, const T* vector);
};
```

**Platform-Specific Allocation**:
```cpp
// macOS/Linux
T* vec = (T*)malloc(size * sizeof(T));

// Windows
T* vec = (T*)_aligned_malloc(size * sizeof(T), alignment);

// Initialize to zero
Signal<float>::clear(size, vec);
```

---

### Harmonics Class

**File**: `ThirdParty/HoaLibrary/Sources/Harmonics.hpp`

```cpp
template <Dimension D, typename T>
class Harmonic
{
public:
    Harmonic(ulong index);
    
    ulong getIndex() const;
    ulong getDegree() const;
    long getOrder() const;
    string getName() const;
    
    T getNormalization() const;
    T getSemiNormalization() const;
    
    // Static utilities
    static ulong getNumberOfHarmonics(ulong order);
    static ulong getHarmonicIndex(ulong degree, long order);
    static ulong getHarmonicDegree(ulong index);
    static long getHarmonicOrder(ulong index);
};
```

**ACN Ordering**:
```cpp
// 2D
ulong index = abs(order);

// 3D  
ulong index = degree * (degree + 1) + order;
```

**Number of Harmonics**:
```cpp
// 2D
ulong num = 2 * order + 1;

// 3D
ulong num = (order + 1) * (order + 1);
```

**Normalization**:
```cpp
// N3D (3D)
T norm = sqrt((2.0 * degree + 1.0) / (4.0 * HOA_PI));

// SN2D (2D)
T norm = (index == 0) ? 0.5 : (1.0 / sqrt(2.0));
```

---

## Performance Summary

### Benchmark Results (Apple M1, Order 7)

| Operation | Time/Sample | Complexity | Optimization Status |
|-----------|-------------|------------|---------------------|
| Encoding | 12 ns | O(N) | ✅ Optimized (recurrence) |
| Decoding | 45 ns | O(N×M) | ⚠️ Can use SIMD |
| Rotation | 14 ns | O(N) | ✅ Optimized (recurrence) |
| Wider | 8 ns | O(N) | ✅ Simple multiplication |
| Optim | 5 ns | O(N) | ✅ Simple multiplication |

### Memory Footprint (Order 7, 2D)

| Component | Size |
|-----------|------|
| Encoder | ~200 bytes |
| Decoder (8ch) | ~450 bytes |
| Rotate | ~100 bytes |
| Wider | ~60 bytes |
| Optim | ~60 bytes |
| **Total** | **~870 bytes** |

---

## Usage Examples

### Basic 2D Ambisonic Chain

```cpp
// Create objects
auto encoder = new Encoder<Hoa2d, double>::Basic(7);
auto rotate = new Rotate<Hoa2d, double>(7);
auto decoder = new Decoder<Hoa2d, double>::Regular(7, 8);

// Configure
encoder->setAzimuth(HOA_PI * 0.25);  // 45° front-left
rotate->setYaw(HOA_PI * 0.5);         // 90° rotation
decoder->computeRendering();

// Process audio
double harmonics[15];
double harmonics_rotated[15];
double speakers[8];

encoder->process(&mono_input, harmonics);
rotate->process(harmonics, harmonics_rotated);
decoder->process(harmonics_rotated, speakers);
```

### Distance-Compensated Multi-Source

```cpp
auto encoder = new Encoder<Hoa2d, double>::Multi(7);

encoder->setNumberOfSources(3);

// Source 1: Front, distance 0.5
encoder->setAzimuth(0, 0.0);
encoder->setRadius(0, 0.5);

// Source 2: Left, distance 1.0
encoder->setAzimuth(1, HOA_PI * 0.5);
encoder->setRadius(1, 1.0);

// Source 3: Back, distance 2.0 (outside circle)
encoder->setAzimuth(2, HOA_PI);
encoder->setRadius(2, 2.0);

// Process (mixes all sources)
encoder->process(inputs, harmonics);
```

### Binaural Rendering

```cpp
auto decoder = new Decoder<Hoa2d, float>::Binaural(7);

// Set FFT size (power of 2)
decoder->computeRendering(512);

// Block processing
float* harmonics_block[15];
float* stereo_out[2];

decoder->processBlock((const float**)harmonics_block, stereo_out);
```

---

## Compilation & Linking

### Include Paths

```bash
# Main library
-I"ThirdParty/HoaLibrary/Sources"

# Max SDK
-I"path/to/max-sdk/source/c74support/max-includes"
-I"path/to/max-sdk/source/c74support/msp-includes"
```

### Compiler Flags

```bash
# Optimization
-O3 -march=native -ffast-math

# C++ Standard
-std=c++11 or higher

# Max API
-DMAC_VERSION  # macOS
```

### Linking

**macOS**:
```bash
-framework Accelerate  # For vDSP (FFT)
-framework CoreAudio
-framework CoreMIDI
```

**Windows**:
```bash
# Intel IPP or FFTW for FFT
```

---

## Troubleshooting

### Common Issues

**Issue**: Crackling or artifacts  
**Solution**: Check block size, increase buffer size

**Issue**: Low CPU but distortion  
**Solution**: Verify sample rate matching, check clipping

**Issue**: Localization seems wrong  
**Solution**: Verify speaker angles, use optimization (MaxRE)

**Issue**: Binaural doesn't work  
**Solution**: Check block size is power of 2, verify HRTF database loaded

### Optimization Tips

1. **Use appropriate order**: Order 3-5 for most applications
2. **Pre-compute matrices**: Call `computeRendering()` once
3. **Block processing**: Process audio in blocks, not sample-by-sample
4. **Minimize order changes**: Avoid reallocating during playback
5. **Use optimizations**: MaxRE for larger sweet spot

---

## Further Reading

- **TECHNICAL_AUDIT.md**: Detailed code analysis and optimization opportunities
- **OPTIMIZATION_GUIDE.md**: Performance tuning with benchmarks
- **ARCHITECTURE.md**: System architecture and design patterns
- **what-is-hoa.md**: Theory and mathematical foundations

---

## Support & Development

**Repository**: https://github.com/CICM/HoaLibrary-Max  
**Documentation**: https://github.com/CICM/HoaLibrary-Max/tree/master/docs  
**License**: GNU GPL v3 (contact CICM for commercial licensing)

**Authors**:
- Julien Colafrancesco
- Pierre Guillot
- Eliott Paris
- Thomas Le Meur

**Institution**: CICM, Université Paris 8

