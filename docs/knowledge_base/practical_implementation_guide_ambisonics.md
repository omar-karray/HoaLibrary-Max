# Practical Implementation Guide: Spatial Audio with Ambisonics & Granular Synthesis

## Quick Start Workflows

### Workflow 1: Basic Point Source Spatialization

**Goal**: Place a mono source in 3D space with control over position and width

**Max/MSP Implementation**:
```
[adc~]                          // Input source
    |
[hoa.encoder~ 7 @channels 15]   // Encode at order 7
    | @azimuth 45               // Position (degrees)
    |
[hoa.wider~ 7]                  // Control angular width
    | @value 0.8                // 0=omni, 1=focused
    |
[hoa.rotate~ 7]                 // Rotate entire field
    | @angle 0                  // Rotation amount
    |
[hoa.optim~ 7 inPhase]          // Choose optimization
    |
[hoa.decoder~ 7 @channels 16]   // Decode for 16 speakers
    |
[dac~ 1 2 3 4 5 6 7 8 9...]     // Output to speakers
```

**Key Controls**:
- Azimuth: 0° (front), 90° (left), 180° (back), 270° (right)
- Width: 1.0 (sharp point) → 0.0 (omnidirectional blob)
- Rotation: Global sound field rotation

---

### Workflow 2: Granular Diffuse Field Synthesis

**Goal**: Create a spatially diffuse texture from a source

**Implementation Strategy A: Per-Harmonic Granulation**

```
[buffer~ source]                    // Source audio

[hoa.plug~ hoa.grain~ 7 @channels 15]
    // This applies hoa.grain~ to all 15 harmonics
    // Each harmonic gets independent granulation
    
Parameters:
    @grainsize 50               // Base grain duration (ms)
    @delay 1000                 // Maximum delay time
    @feedback 0.7               // Grain reinjection
    @rarefaction 0.3            // Density control
    
[hoa.decoder~ 7 @channels 16]
[dac~ ...]
```

**How it works**:
- Each harmonic (15 channels for order 7) gets its own grain stream
- Grain parameters vary by harmonic index:
  - Higher harmonics → shorter grains
  - Lower harmonics → longer delays
- Result: Spatially complex, enveloping texture

**Implementation Strategy B: Modulation-Based Diffusion**

```
[adc~]
    |
[hoa.encoder~ 7 @channels 15]   // First encode as point source
    |
[hoa.plug~ hoa.am~ 7]           // Amplitude modulation per harmonic
    // Each harmonic gets different LFO frequency (1-20 Hz)
    |
[hoa.decoder~ 7]
[dac~ ...]
```

**Why this works**:
- Different amplitude modulation per harmonic
- Breaks correlation between channels
- Preserves timbre better than granulation
- Creates "unstable" spatial image = diffusion

---

### Workflow 3: Transitioning Point Source ↔ Diffuse Field

**Method 1: Crossfade Approach**

```
[source~]
    |
    +---[hoa.encoder~ 7]--------+
    |                           |
    +---[hoa.encoder~ 7]        |
            |                   |
        [hoa.am~ 7]             |  // Diffuse path
            |                   |
        [* 0.~]                 |  // Crossfader
            |                   |
            +-------[+~]--------+  // Mix
                      |
                [hoa.decoder~ 7]
                      |
                   [dac~]

Crossfade control:
    [line~]  // 0. to 1. over time
    |    |
    |    [!- 1.]  // Inverted
    |    |
    +----+
```

**Method 2: Diffusion Factor Approach**

```
[source~]
    |
[hoa.encoder~ 7]
    |
[hoa.wider~ 7]          // Fractional order control
    | @value 0.5        // Intermediate resolution
    |
[hoa.plug~ effect~ 7]   // Decorrelation effect
    | @diffusion 0.3    // Amount of decorrelation
    |
[hoa.decoder~ 7]
```

**Mapping the diffusion**:
```
diffusion_factor = 0.0 → point source
    ↓ (gradually engage decorrelation per harmonic)
diffusion_factor = 1.0 → fully diffuse

Implementation:
- For each harmonic m:
    if (abs(m) / max_order) < diffusion_factor:
        apply_decorrelation(harmonic[m])
```

---

### Workflow 4: Spatial Granular Swarm (Faust/SuperCollider)

**Goal**: Create swarm of individually spatialized grains

**Faust Structure**:
```faust
// Import ambitools
import("ambitools.lib");

N = 30;  // Number of grain streams
L = 3;   // HOA order

// For each grain stream i:
grain_stream(i) = grain_generator(i) : spatial_encoder(i)
with {
    // Generate grain with varying parameters
    grain_generator = buffer_reader, envelope, probability;
    
    // Encode at random position
    spatial_encoder = encoder(L, random_azi(i), random_ele(i), random_r(i));
};

// Sum all grain streams
process = par(i, N, grain_stream(i)) :> hoa_out(L);
```

**Key Parameters Per Grain**:
```
duration: 5-100 ms       (random within range)
read_speed: 0.5-2.0      (pitch variation)
start_pos: markers       (sync points in buffer)
direction: fwd/bwd       (read direction)
azimuth: 0-360°          (random position)
elevation: -90 to 90°    (vertical spread)
radius: 0.5-1.5          (distance from center)
probability: 0-1         (grain density)
```

**Visualization Setup** (OSC to OpenFrameworks):
```supercollider
// In SuperCollider
~granulator = Granulator.ar(L: 3, N: 30);
~granulator.sendOSC(\grainPositions, NetAddr("localhost", 7000));

// OSC Messages:
// /grain/pos i x y z amplitude
// Where i = grain index, xyz = spherical coords, amp = current level
```

---

## Detailed Techniques

### Technique 1: Creating Realistic Distance Cues

**Problem**: Standard HOA encoding places all sources on sphere surface

**Solution**: Combined approach using width and amplitude

```
distance_factor = source_distance / reference_radius

if (distance_factor < 1.0) {  // Inside sphere
    // Reduce angular resolution as source approaches center
    width = distance_factor;
    amplitude = 1.0;
    
} else {  // Outside sphere
    // Attenuate amplitude, maintain full directivity
    width = 1.0;
    amplitude = 1.0 / (distance_factor * distance_factor);  // Inverse square law
}

[hoa.encoder~ 7]
    | @azimuth angle
    |
[hoa.wider~ 7]
    | @value width
    |
[* amplitude]
```

**Enhanced with filtering**:
```
// Add air absorption for distant sources
if (distance_factor > 1.0) {
    lowpass_freq = 20000 / distance_factor;  // Simple model
    [lores~ lowpass_freq 0.7]
}
```

---

### Technique 2: Spatial Filtering and Focus

**Using plane wave decomposition**:

```
[source_hoa~ order:7]
    |
[hoa.projector~ 7 @channels 36]  // Project to 36 virtual mics
    |
    // Apply directional gains
[matrix_mixer~]  // Boost front, attenuate back, etc.
    |
[hoa.recomposer~ 7 @channels 36]  // Back to HOA
    |
[hoa.decoder~ 7]
```

**Creating a "spotlight" effect**:
```
focus_direction = 45°;  // Looking towards
focus_width = 30°;      // Cone of attention

For each plane wave at angle θ:
    angular_diff = abs(θ - focus_direction);
    if (angular_diff < focus_width/2):
        gain = 1.0;
    else:
        gain = 0.0;  // Hard cut
        // Or use cosine taper for smooth falloff
        gain = max(0, cos(angular_diff - focus_width/2));
```

---

### Technique 3: Dynamic Spatial Trajectories

**Circular trajectory**:
```
rate = 0.1;  // Hz (cycles per second)
radius = 0.8;  // Keep inside speaker circle

azimuth = (phasor~ rate) * 360.;
distance = radius;

[hoa.encoder~ 7]
    | @azimuth azimuth
```

**Figure-8 trajectory**:
```
t = phasor~ 0.05;  // Slow movement

// Lissajous curve
azimuth = sin(2πt * 2) * 180;  // 2:1 ratio
radius = 0.5 + 0.3 * cos(2πt * 3);

// Apply width modulation synchronized with position
width = (radius - 0.5) / 0.3;  // Maps 0.5-0.8 to 0-1
```

**Organic randomness**:
```
// Random walk with smoothing
[noise~]
    |
[lores~ 0.1 0.7]  // Very low frequency filtering
    |
[scale~ -1 1 0 360]  // Map to azimuth range
    |
[line~ 100]  // Smooth transitions
    |
[@azimuth]
```

---

### Technique 4: Multi-Source Mixing Strategies

**Challenge**: Combining multiple HOA-encoded sources

**Approach 1: Direct summation**
```
[source1~ hoa.encoder~ 7] -----+
                                |
[source2~ hoa.encoder~ 7] -----+--- [+~] --- [hoa.decoder~ 7]
                                |
[source3~ hoa.encoder~ 7] -----+
```
✓ Simple
✓ Maintains spatial accuracy
⚠ No per-source processing after encoding

**Approach 2: Mix in plane wave domain**
```
Each source → Encode → Project to plane waves
                            ↓
                    Apply per-source FX
                            ↓
                        Sum planes
                            ↓
                    Recompose to HOA
                            ↓
                    Decode to speakers
```
✓ Can process each source spatially
✓ Can apply directional EQ per source
⚠ More computationally intensive

**Approach 3: Hybrid approach**
```
Point sources → Standard HOA path
Diffuse sources → Separate decorrelation → Mix
Background → Reverb in HOA
All → Sum and decode
```

---

### Technique 5: Reverb Design in HOA

**Strategy 1: Per-harmonic algorithmic reverb**

```
[source~]
    |
[hoa.encoder~ 7]
    |
[hoa.plug~ reverb~ 7]  // Different reverb instance per harmonic
    // Parameters vary by harmonic:
    // - Higher harmonics: shorter decay, more diffusion
    // - Lower harmonics: longer decay, less diffusion
    |
[hoa.decoder~ 7]
```

**Parameters mapping**:
```
For harmonic index m (where m = -7 to 7):
    decay_time(m) = base_decay * (1 - abs(m)/14)
    diffusion(m) = base_diffusion * (abs(m)/14)
    
Example values:
    base_decay = 2.0 seconds
    base_diffusion = 0.7
    
Result:
    m=0:  decay=2.0s, diffusion=0
    m=±7: decay=1.0s, diffusion=0.7
```

**Strategy 2: Ambisonic impulse response convolution**

```
// Record or synthesize ambisonic IR
[hoa.irrecorder~ order:7 @channels 15]
    ↓
[ambisonic_ir.wav]  // 15-channel file
    ↓
[hoa.convolve~ order:7]  // FFT convolution per channel
    | @ir ambisonic_ir
    |
[hoa.decoder~ 7]
```

**Creating synthetic ambisonic IRs**:
```
1. Generate multichannel exponential decay
2. Add decorrelation (different delays per channel)
3. Apply diffusion (all-pass filters)
4. Encode late reflections as point sources
5. Combine and normalize
```

---

## Parameter Relationships Cheatsheet

### Spatial Resolution vs. Order

```
Order → Angular Resolution (approximate)
  1  →  90°   (quadrant-level)
  2  →  60°   (hex grid)
  3  →  30°   (dodecagon)
  5  →  18°   (fine)
  7  →  12°   (very fine)
```

### Grain Parameters for Different Textures

```
TEXTURE          | Grain Size | Delay  | Feedback | Rarefaction
-----------------|------------|--------|----------|-------------
Smooth cloud     | 50-100ms   | High   | 0.8-0.9  | 0.1-0.3
Rhythmic pulse   | 10-30ms    | Medium | 0.5-0.7  | 0.5-0.7
Sparse events    | 5-20ms     | Low    | 0.2-0.4  | 0.7-0.9
Dense granular   | 2-10ms     | Low    | 0.6-0.8  | 0.1-0.2
```

### Diffusion Amount Guidelines

```
Diffusion Factor | Perceptual Effect
-----------------|----------------------------------
0.0 - 0.2        | Barely noticeable widening
0.2 - 0.4        | Clear source with spatial aura
0.4 - 0.6        | Ambiguous location
0.6 - 0.8        | Mostly diffuse with hint of direction
0.8 - 1.0        | Fully enveloping, omnidirectional
```

---

## Common Problems & Solutions

### Problem 1: Thinning Sound at Higher Orders

**Symptom**: More channels = less power per speaker

**Solution**:
```
// Apply compensation gain
gain_compensation = sqrt(2*order + 1) / sqrt(3)  // For 2D

[hoa.encoder~ 7]
    |
[* gain_compensation]
    |
[hoa.decoder~ 7]
```

### Problem 2: Comb Filtering with Close Speakers

**Symptom**: Audible coloration, phase cancellation

**Solution**:
- Use `inPhase` optimization
- Increase order for better speaker separation
- Space speakers more widely if possible

```
[hoa.optim~ 7 inPhase]  // Before decoder
```

### Problem 3: Limited Sweet Spot

**Symptom**: Good sound only at center

**Solutions**:
```
1. Use max-rE optimization:
   [hoa.optim~ 7 maxRe]

2. Increase order (larger sweet spot radius)

3. Add perceptual enhancements:
   - Width control for sources
   - Some diffusion/decorrelation
   - Reverb to mask localization errors
```

### Problem 4: Granular Artifacts with HOA

**Symptom**: Clicks, pops, spatial instabilities

**Solutions**:
```
1. Ensure smooth envelopes:
   - Use Hanning, Gaussian, or Tukey windows
   - Overlap grains sufficiently (50-75%)

2. Match grain parameters to order:
   - Lower orders: Longer grains, less streams
   - Higher orders: Can use more complex settings

3. Add subtle smoothing:
   [hoa.plug~ [lores~ 18000 0.7] 7]  // Gentle lowpass
```

### Problem 5: Reverb Sounds "Phasey"

**Symptom**: Artificial, unstable reverb tail

**Solutions**:
```
1. Ensure decorrelation:
   - Different delays per harmonic (avoid multiples)
   - Use all-pass filters in feedback
   - Prime number-based delay lines

2. Balance direct/reverb:
   - Don't over-reverb (< 30% wet often sufficient)
   - High-pass reverb input (< 200 Hz)

3. Use hybrid approach:
   - Early reflections: Explicit encoding
   - Late reverb: Decorrelated synthesis
```

---

## Performance Optimization Tips

### CPU Optimization

```
Strategy                    | Savings | Trade-off
----------------------------|---------|---------------------------
Lower order                 | 40-60%  | Spatial resolution
Reduce grain streams        | 30-50%  | Texture richness
Limit reverb density        | 20-40%  | Tail smoothness
Use fixed-point math        | 10-20%  | Slight precision loss
Disable unnecessary viz     | 5-10%   | Less visual feedback
```

### Memory Optimization

```
// For granular synthesis with large buffers
buffer_size = max_grain_size * max_density * safety_factor
            = 100ms * 100 grains * 2
            = 20 seconds of audio (at 44.1kHz = ~882k samples)

// Minimize by:
1. Stream from disk for long files
2. Reduce max grain size
3. Limit concurrent grain streams
4. Share buffers when possible
```

### Latency Management

```
Component           | Typical Latency
--------------------|------------------
Encoding            | ~0 samples
HOA processing      | 0-64 samples (depends on effects)
FFT-based effects   | 512-2048 samples (FFT size/2)
Binaural convolution| 128-512 samples (IR length dependent)
Decoding            | ~0 samples

Total reasonable:   | < 10ms for live performance
                    | < 50ms for installation
                    | Any for offline rendering
```

---

## Integration Examples

### Example 1: Max/MSP Concert Patch

```
// Main structure
[audio_input~]
    |
    +--[dry_encode]--+
    |                |
    +--[grain_proc]--+--[sum]--[rotate]--[decoder]--[out]
    |                |
    +--[reverb_proc]-+

Modules:
- dry_encode: hoa.encoder~ with width control
- grain_proc: hoa.plug~ with hoa.grain~ (modulated by analysis)
- reverb_proc: hoa.convolve~ with IR
- rotate: hoa.rotate~ mapped to gesture controller
- decoder: hoa.binaural~ for monitoring, hoa.decoder~ for performance
```

### Example 2: SuperCollider + Antescollider Score

```supercollider
// Antescollider allows synchronized score
NOTE startGranularSwarm {
    let grains = Granulator.ar(order: 3, streams: 20)
    grains.azimuthRange = [-180, 180]
    grains.elevationRange = [-30, 30]
    grains.grainDur = [10, 80].ms
    grains.density = 0.7
    
    // Synchronized with instrumental score
    after 2 beats {
        grains.density = 0.3  // Thin out
    }
    
    after 4 beats {
        grains.azimuthRange = [0, 90]  // Focus front-right
    }
}
```

### Example 3: Pure Data Installation Patch

```
// Kinect OSC input → spatial control
[netreceive 8000]
    |
[routeOSC /hand/x /hand/y /hand/z]
    |    |    |
    |    |    +--[scale 0 1 0.5 1.5]--[@radius]
    |    +-------[scale 0 1 0 360]----[@azimuth]
    +-----------[scale 0 1 0 1]-------[@diffusion]

[adc~]--[hoa.encoder~ 3]--[hoa.wider~ 3]--[hoa.decoder~ 3]--[dac~]
```

---

## Debugging & Visualization Tools

### Monitoring Your HOA Signal

```
[hoa.scope~ 7]  // Shows harmonic amplitudes and phase
                 // Each lobe represents a harmonic
                 // Size = amplitude, angle = phase

[hoa.meter~ 7 @channels 16]  // Virtual speaker levels
                              // Circular VU meters
                              // Shows actual speaker feeds

[hoa.inspector~ 7]  // Custom analyzer
    ↓
    Frequency content per harmonic
    Correlation between harmonics
    Energy distribution map
```

### Checking Spatial Accuracy

```
// Test with impulses at known positions
[metro 1000]--[click~]--[hoa.encoder~ 7 @azimuth 0]--[decoder]

Sweep azimuth from 0-360:
- Sound should follow in circle
- No amplitude dips
- Smooth transitions

If problems:
1. Check speaker positions match decoder config
2. Verify optimization type
3. Ensure all harmonics are present (scope~)
```

---

## Further Exploration

### Advanced Topics to Study

1. **Mixed-order ambisonics** - Different orders for different frequency bands
2. **Ambisonics with WFS** - Combining techniques for large venues
3. **Parametric ambisonics** - DirAC and similar analysis-synthesis
4. **Ambisonic microphone arrays** - Recording real sound fields
5. **VBAP/Ambisonics hybrids** - Best of both worlds

### Suggested Experiments

1. **Mapping gestures to spatial parameters**
   - Use sensors, controllers, or audio analysis
   - Control width, rotation, diffusion simultaneously

2. **Generative spatial composition**
   - L-systems for trajectory generation
   - Stochastic processes for grain swarms
   - Machine learning for spatial effects

3. **Interactive installations**
   - Multiple participants controlling different aspects
   - Real-time spatial mixing and morphing
   - Responsive environments

4. **Multichannel recording workflows**
   - Capture ambisonic fields from acoustic spaces
   - Process and remix in HOA domain
   - Export to various formats (binaural, 5.1, stereo)

---

## Quick Command Reference

### Max/MSP HOA Objects

```
hoa.encoder~     - Encode point source
hoa.decoder~     - Decode to speakers/binaurall
hoa.wider~       - Control angular width (fractional order)
hoa.rotate~      - Rotate sound field
hoa.optim~       - Apply decoding optimization
hoa.map~         - 2D source positioning with distance
hoa.scope~       - Visualize harmonics
hoa.meter~       - Circular VU meters
hoa.plug~        - Parallel processing on harmonics
hoa.projector~   - Convert to plane waves
hoa.recomposer~  - Convert from plane waves
hoa.grain~       - Granular synthesis per harmonic
hoa.convolve~    - Ambisonic convolution
hoa.binaural~    - Binaural decoding
hoa.stereo~      - Stereo downmix
```

### FAUST Ambitools Functions

```
encoder(N, azi, ele)          - Point source encoder
decoder(N, config)            - Speaker array decoder
rotator(N, angle)             - Rotation operator
optimWeight(N, type)          - Decoding optimization
projector(N, numPlanes)       - Project to plane waves
recomposer(N, numPlanes)      - Recompose from planes
```

---

*This practical guide complements the theoretical knowledge base. Start simple, build up gradually, and always trust your ears!*