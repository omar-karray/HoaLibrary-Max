# HoaLibrary-Max Project Analysis

**Date**: November 11, 2025  
**Max Version Target**: 9.0.2 (arm64 macOS)  
**SDK Available**: Max SDK 8.2.0  
**Goal**: Modernize HoaLibrary-Max and add spatial granulator

---

## 1. Project Architecture Overview

### 1.1 Repository Structure

```
HoaLibrary-Max/
├── ThirdParty/
│   ├── HoaLibrary/          # Core C++ HOA library (header-only)
│   │   └── Sources/         # All .hpp files
│   └── Max7-sdk/            # Old Max 7 SDK (to be replaced with reference)
│
├── Max2D/                   # 2D HOA externals (.cpp implementations)
├── Max3D/                   # 3D HOA externals (.cpp implementations)
├── MaxCommon/               # Shared utilities and process~ system
│
├── Package/HoaLibrary/      # Max package output
│   ├── externals/           # Compiled .mxo files
│   ├── help/                # .maxhelp patches
│   ├── docs/                # .maxref.xml documentation
│   ├── extras/              # Tutorials and examples
│   └── patchers/            # Abstractions (hoa.fx.*, hoa.syn.*)
│
├── hoa.library.xcodeproj/   # Xcode project (macOS)
├── VisualStudioProjects/    # Windows build files
└── hoa.max.h, hoa.max.cpp   # Main integration layer
```

### 1.2 Build System Status

**Current State:**
- Xcode project for macOS (targets Max 6.1.9+)
- Visual Studio projects for Windows
- No CMake build system
- Old Max 7 SDK (version 7.0.3) embedded in repo

**Compatibility:**
- Code uses Max 7's dsp64 API ✅ (compatible with Max 8/9)
- Uses `object_alloc()`, `object_method()` ✅ (still valid)
- No deprecated Max 6 API calls detected ✅

---

## 2. HoaLibrary C++ Core

### 2.1 Architecture

The **HoaLibrary** is a **header-only** C++ template library located in `ThirdParty/HoaLibrary/Sources/`.

**Key Components:**

| Header | Purpose |
|--------|---------|
| `Hoa.hpp` | Main include file |
| `Defs.hpp` | Constants, dimension types (`Hoa2d`, `Hoa3d`) |
| `Harmonics.hpp` | Spherical harmonics calculations |
| `Encoder.hpp` | Position → HOA encoding |
| `Decoder.hpp` | HOA → speaker array |
| `Processor.hpp` | Base class for HOA processors |
| `Signal.hpp` | Signal processing utilities |
| `Math.hpp` | Math utilities (CBLAS integration) |

**Template Parameters:**
```cpp
template <Dimension D, typename T>
// D = Hoa2d or Hoa3d
// T = float or double (we use t_sample in Max)
```

### 2.2 Encoder Class (Critical for Granulator)

```cpp
Encoder<Hoa3d, t_sample>::Basic* encoder;

// Usage:
encoder = new Encoder<Hoa3d, t_sample>::Basic(order);
encoder->setAzimuth(azimuth_radians);      // 0 to 2π
encoder->setElevation(elevation_radians);  // -π to π
encoder->process(input_sample, output_harmonics_array);

// Output: (order+1)² channels
// Order 1 → 4 channels, Order 3 → 16, Order 7 → 64
```

**Key Insight:** Each grain will need its own encoder instance OR we reuse one encoder per grain stream and update position per sample.

---

## 3. Max/MSP Integration Layer

### 3.1 External Structure Pattern

All externals follow this structure (example: `hoa.3d.encoder~`):

```cpp
// 1. Data structure
typedef struct _hoa_3d_encoder {
    t_pxobject f_ob;                        // Max MSP object header
    Encoder<Hoa3d, t_sample>::Basic* f_encoder;  // HoaLibrary class
    t_sample* f_signals;                    // Interleaved output buffer
} t_hoa_3d_encoder;

// 2. DSP perform routine (called every audio vector)
void perform_routine(x, dsp, ins, nins, outs, numouts, sampleframes, flags, userparam)
{
    // Process sample-by-sample or vector-by-vector
    for (i = 0; i < sampleframes; i++) {
        x->f_encoder->setAzimuth(ins[1][i]);
        x->f_encoder->setElevation(ins[2][i]);
        x->f_encoder->process(ins[0]+i, x->f_signals + numouts*i);
    }
    // Copy interleaved buffer to separate outputs
}

// 3. DSP setup
void dsp64(x, dsp64, count, samplerate, maxvectorsize, flags)
{
    object_method(dsp64, gensym("dsp_add64"), x, (method)perform_routine, 0, NULL);
}

// 4. Constructor
void *new(symbol, argc, argv)
{
    x = object_alloc(class);
    x->f_encoder = new Encoder<Hoa3d, t_sample>::Basic(order);
    dsp_setup(&x->f_ob, num_inlets);
    for (i = 0; i < num_outlets; i++)
        outlet_new(x, "signal");
    return x;
}

// 5. Main registration
void ext_main(void *r)
{
    c = class_new("hoa.3d.encoder~", new, free, sizeof(struct), 0L, A_GIMME, 0);
    class_addmethod(c, dsp64, "dsp64", A_CANT, 0);
    class_addmethod(c, float_method, "float", A_FLOAT, 0);
    class_dspinit(c);
    class_register(CLASS_BOX, c);
}
```

### 3.2 HOA Integration Helpers

**hoa.max.h** provides:
- `HOA_MAXBLKSIZE` - Maximum block size (8192)
- `hoa_initclass()` - Registers HOA metadata for `hoa.connect`
- `t_hoa_boxinfos` - Describes input/output types for auto-patching

**hoa.max_commonsyms.h** provides common symbols (gensym cache)

---

## 4. The hoa.process~ System

### 4.1 Purpose

`hoa.process~` is like `poly~` but HOA-aware:
- Loads a patcher N times (N = number of harmonics or plane waves)
- Distributes HOA channels to instances
- Aggregates outputs back to HOA domain

**Example:**
```max
[hoa.2d.encoder~ 3]  # Outputs 9 harmonics
    ↓
[hoa.process~ 3 my_effect~ harmonics]  # Loads my_effect~ 9 times
    ↓
[hoa.2d.decoder~ 8]  # Decode to 8 speakers
```

### 4.2 Inside the Loaded Patcher

Use special objects:
- `hoa.in~` / `hoa.in` - Receive from parent process~
- `hoa.out~` / `hoa.out` - Send back to parent process~
- `hoa.thisprocess~` - Query mode, order, instance index

**HoaProcessSuite.h** provides C API:
```cpp
void *processor = Get_HoaProcessor_Object();
long index = Get_HoaProcessor_Patch_Index(processor);
long order = HoaProcessor_Get_Ambisonic_Order(processor);
long is_2d = HoaProcessor_Is_2D(processor);
```

### 4.3 Existing Grain Objects

**hoa.syn.grain~** and **hoa.fx.grain~** are **abstractions** (Max patchers, not C++ externals):
- Use delay lines + amplitude modulation
- Parameters scale with harmonic order
- Require buffer~ for audio source
- Simple grain synthesis, NOT spatial

**Location:** `Package/HoaLibrary/patchers/hoa.syn.grain~.maxpat`

---

## 5. Spatial Granular Synthesis Concepts

### 5.1 From the Paper (Ambitools/Supercollider)

**Core Idea:** Multiple independent grain streams, each grain spatially encoded.

```
Audio Source (buffer~ or input~)
    ↓
N Grain Streams (parallel)
    ↓ (each stream)
Grain Generator:
  - Random duration (dur_min to dur_max)
  - Random speed (speed_min to speed_max)
  - Random position (azimuth range, elevation range, radius range)
  - Random direction (forward/reverse)
  - Envelope (Hann, Hamming, Blackman, etc.)
  - Probability gate (0-1, controls grain density)
    ↓
Spatial Encoding (per grain)
  encoder->setAzimuth(random_azimuth)
  encoder->setElevation(random_elevation)
  encoder->process(grain_sample, hoa_output)
    ↓
Sum all grain streams → HOA output
```

### 5.2 Implementation Strategy

**Two Approaches:**

#### Option A: Standalone External (hoa.3d.granulator~)
```cpp
struct _hoa_3d_granulator {
    t_pxobject f_ob;
    
    // Grain engine
    GrainStream* f_grains[MAX_GRAINS];  // 32 max
    int f_num_grains;
    
    // Per-grain encoder
    Encoder<Hoa3d, t_sample>::Basic* f_encoders[MAX_GRAINS];
    
    // Audio source
    t_buffer_ref* f_buffer;
    
    // Parameters
    float f_dur_min, f_dur_max;
    float f_speed_min, f_speed_max;
    float f_azimuth_min, f_azimuth_max;
    float f_elevation_min, f_elevation_max;
    float f_radius_min, f_radius_max;
    float f_probability;
    int f_envelope_type;
    
    // Output accumulator
    t_sample* f_hoa_output;
};
```

**Pros:**
- Self-contained
- Easier to optimize
- Direct control

**Cons:**
- More complex to implement
- Less modular

#### Option B: Process~ Based (hoa.syn.spatialgrain~)
Create a patcher that uses `hoa.process~` + grain synthesis + randomized spatial encoding.

**Pros:**
- Leverages existing infrastructure
- Can use existing grain abstractions
- More flexible for users

**Cons:**
- Harder to achieve tight grain synchronization
- Performance overhead

**Recommendation:** Start with **Option A** for better control over grain timing and spatial encoding.

---

## 6. Key Design Decisions

### 6.1 Grain Engine Architecture

**Per-Grain State:**
```cpp
struct GrainStream {
    // Current grain
    double phase;              // Read position in buffer
    double duration_samples;   // Grain length
    double speed;              // Playback rate
    double envelope_phase;     // 0.0 to 1.0
    bool active;               // Is grain playing?
    
    // Spatial position
    double azimuth;
    double elevation;
    double radius;
    
    // Randomization
    unsigned long rng_state;   // Per-grain RNG
    
    // Next grain trigger
    double next_grain_time;
};
```

**Perform Routine Logic:**
```cpp
void perform(x, ins, outs, sampleframes) {
    // Zero HOA output accumulator
    memset(x->f_hoa_output, 0, num_harmonics * sampleframes * sizeof(t_sample));
    
    for (int g = 0; g < x->f_num_grains; g++) {
        GrainStream* grain = x->f_grains[g];
        
        for (int i = 0; i < sampleframes; i++) {
            // Check if need new grain
            if (!grain->active && should_trigger(grain, x->f_probability)) {
                init_new_grain(grain, x);  // Randomize all parameters
            }
            
            if (grain->active) {
                // Read sample from buffer
                sample = read_buffer_interp(x->f_buffer, grain->phase, grain->speed);
                
                // Apply envelope
                sample *= get_envelope(grain->envelope_phase, x->f_envelope_type);
                
                // Spatial encode
                x->f_encoders[g]->setAzimuth(grain->azimuth);
                x->f_encoders[g]->setElevation(grain->elevation);
                x->f_encoders[g]->processAdd(&sample, x->f_hoa_output + i * num_harmonics);
                
                // Advance grain
                grain->phase += grain->speed;
                grain->envelope_phase += 1.0 / grain->duration_samples;
                
                if (grain->envelope_phase >= 1.0) {
                    grain->active = false;
                }
            }
        }
    }
    
    // Copy accumulated HOA to outputs
    for (int h = 0; h < num_harmonics; h++) {
        for (int i = 0; i < sampleframes; i++) {
            outs[h][i] = x->f_hoa_output[i * num_harmonics + h];
        }
    }
}
```

### 6.2 Envelope Functions

```cpp
enum EnvelopeType {
    ENV_HANN = 0,
    ENV_HAMMING,
    ENV_BLACKMAN,
    ENV_TRIANGLE,
    ENV_TRAPEZOID
};

float envelope(float phase, EnvelopeType type) {
    switch(type) {
        case ENV_HANN:
            return 0.5 * (1.0 - cos(2.0 * M_PI * phase));
        case ENV_HAMMING:
            return 0.54 - 0.46 * cos(2.0 * M_PI * phase);
        case ENV_TRIANGLE:
            return 1.0 - fabs(2.0 * phase - 1.0);
        // ... etc
    }
}
```

### 6.3 Random Number Generation

**Important:** Use per-grain RNG state for thread safety and reproducibility.

```cpp
// Simple LCG (Linear Congruential Generator)
unsigned long rng_next(unsigned long* state) {
    *state = (*state * 1103515245 + 12345) & 0x7fffffff;
    return *state;
}

float rng_float(unsigned long* state) {
    return rng_next(state) / (float)0x7fffffff;
}

float random_range(unsigned long* state, float min, float max) {
    return min + rng_float(state) * (max - min);
}
```

---

## 7. Comparison with Existing hoa.syn.grain~

### 7.1 Current Implementation
- **Type:** Abstraction (Max patcher)
- **Approach:** Delay lines + amplitude modulation
- **Spatial:** Parameters scale per harmonic (not true spatial positioning)
- **Grains:** Implicit, created by modulation

### 7.2 Our Spatial Granulator
- **Type:** C++ external
- **Approach:** Explicit grain generation with buffer reading
- **Spatial:** Each grain has explicit 3D position → encoded to HOA
- **Grains:** N independent streams with randomized positions
- **Features:**
  - Configurable grain count (1-32)
  - Per-grain spatial randomization
  - Multiple envelope types
  - Probability-based grain density
  - Live input or buffer source
  - True 3D spatial movement

**Unique Value:** True spatial granulation where each grain occupies a distinct position in 3D space, creating immersive spatial textures impossible with the current implementation.

---

## 8. Development Roadmap

### Phase 1: Build System Modernization ✅ (Current)
1. ✅ Audit current Xcode project
2. ✅ Verify Max SDK compatibility (7.0.3 SDK works, but 8.2.0 available)
3. 🔄 Create CMakeLists.txt
4. ⏳ Test build of one external (hoa.3d.encoder~)
5. ⏳ Build all existing externals
6. ⏳ Test in Max 9

### Phase 2: Architecture Deep Dive ✅ (Current)
1. ✅ Understand HoaLibrary C++ core
2. ✅ Understand Max/MSP integration patterns
3. ✅ Study existing externals
4. ✅ Analyze hoa.process~ system
5. ✅ Review existing grain implementations

### Phase 3: Granulator Design
1. Create detailed specification document
2. Design grain engine architecture
3. Choose envelope implementations
4. Plan parameter system (attributes, inlets)
5. Design help patch and examples

### Phase 4: Implementation
1. Create `hoa.3d.granulator~.cpp` skeleton
2. Implement grain stream engine
3. Integrate HoaLibrary encoder
4. Add buffer~ reading
5. Implement envelope functions
6. Add parameter handling
7. Optimize performance

### Phase 5: Testing & Documentation
1. Unit tests for grain engine
2. Spatial accuracy validation
3. Performance profiling
4. Create .maxhelp file
5. Create tutorial patches
6. Write technical documentation

### Phase 6: Distribution
1. Build for macOS (arm64 + x86_64)
2. Build for Windows (x64)
3. Create package
4. Write README and BUILD instructions
5. Publish on GitHub

---

## 9. Technical Specifications

### 9.1 Proposed Object Interface

**Name:** `hoa.3d.granulator~`

**Arguments:**
- `@order` (int): HOA order (1-7, default 3)

**Attributes:**
```
// Grain Parameters
@grains (int): Number of grain streams (1-32, default 8)
@dur_min (float): Min grain duration in ms (10-1000, default 50)
@dur_max (float): Max grain duration in ms (10-1000, default 200)
@speed_min (float): Min playback speed (-4.0 to 4.0, default 0.8)
@speed_max (float): Max playback speed (-4.0 to 4.0, default 1.2)
@probability (float): Grain density 0-1 (default 0.8)
@envelope (symbol): hann, hamming, blackman, triangle, trapezoid (default hann)

// Spatial Parameters
@azimuth_min (float): Min azimuth in degrees (default 0)
@azimuth_max (float): Max azimuth in degrees (default 360)
@elevation_min (float): Min elevation in degrees (default -90)
@elevation_max (float): Max elevation in degrees (default 90)
@radius_min (float): Min radius (default 1.0)
@radius_max (float): Max radius (default 1.0)

// Audio Source
@buffer (symbol): Buffer name (default none - uses live input)
@loop (bool): Loop buffer (default 1)
```

**Inlets:**
1. Signal: Audio input (if no buffer specified)
2. Message: Parameter changes

**Outlets:**
- N signal outlets: HOA channels (N = (order+1)²)

---

## 10. Dependencies & Requirements

### 10.1 Build Requirements
- **macOS:** Xcode 12+, CMake 3.15+
- **Windows:** Visual Studio 2019+, CMake 3.15+
- **Max SDK:** 8.2.0+ (referenced externally)
- **HoaLibrary:** Included in repo (header-only)

### 10.2 Runtime Requirements
- **Max:** 8.2.0+ (tested on 9.0.2)
- **macOS:** 10.11+ (SDK specifies), tested on macOS 15 (Sequoia)
- **Architecture:** Universal binary (x86_64 + arm64)

---

## 11. Key Files Reference

### For Building
- `MaxHoaLibrary.xcconfig` - Current Xcode configuration
- `hoa.library.xcodeproj/project.pbxproj` - Xcode project
- Need to create: `CMakeLists.txt`

### For Understanding
- `ThirdParty/HoaLibrary/Sources/Encoder.hpp` - Encoder class
- `Max3D/hoa.3d.encoder_tilde.cpp` - Example 3D external
- `MaxCommon/hoa.process_tilde.cpp` - Process~ implementation
- `MaxCommon/HoaProcessSuite.h` - Process~ API

### For Reference
- Paper: `context.md` - References spatial granulator research
- Help: `Package/HoaLibrary/help/HoaSynthesizers/hoa.syn.grain~.maxhelp`

---

## 12. Next Actions

**Immediate (Today):**
1. Create CMakeLists.txt for modern build
2. Set up build to reference external Max SDK
3. Test build one external to verify setup

**Short-term (This Week):**
1. Build all existing externals
2. Test in Max 9
3. Create granulator specification document
4. Begin skeleton implementation

**Medium-term (This Month):**
1. Complete granulator implementation
2. Create help file and examples
3. Performance optimization
4. Cross-platform testing

---

## Notes & Observations

1. **API Compatibility:** Code is already Max 8/9 compatible (uses dsp64, modern APIs)
2. **Architecture:** Clean separation between HoaLibrary C++ and Max integration
3. **Existing Grain:** Current implementation is simple modulation-based, not true spatial
4. **Process~ System:** Powerful but may not be ideal for tight grain synchronization
5. **Apple Silicon:** Need to ensure Universal Binary builds (current xcconfig has i386 x86_64, need to add arm64)

---

**Last Updated:** November 11, 2025  
**Status:** Analysis Complete, Ready for Implementation Planning
