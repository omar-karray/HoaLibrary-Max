# Quick Reference: Ambisonics & Granular Synthesis Essentials

## 🎯 Core Concepts at a Glance

### What is Ambisonics?
**Speaker-independent 3D audio encoding** that represents sound as a *field* rather than individual channels.

**Key principle**: Encode once → Decode for any speaker setup

---

## 📐 Essential Formulas

### Encoding (2D)
```
For source at angle θ:
W = signal / √2                    (order 0)
X = signal × cos(θ)                (order 1, positive)
Y = signal × sin(θ)                (order 1, negative)

General:
H(m,θ) = signal × cos(|m|×θ)  if m ≥ 0
H(m,θ) = signal × sin(|m|×θ)  if m < 0
```

### Channel Count
```
2D: channels = 2N + 1
3D: channels = (N + 1)²

Examples:
Order 1 (2D): 3 channels
Order 3 (2D): 7 channels  
Order 7 (2D): 15 channels
Order 1 (3D): 4 channels
Order 3 (3D): 16 channels
```

### Basic Decoding (per speaker)
```
speaker(φ) = W + X×cos(φ) + Y×sin(φ) + higher_orders...
```

---

## 🎚️ Key Parameters

### Angular Resolution by Order
| Order | Resolution | Use Case |
|-------|-----------|----------|
| 1 | ~90° | Testing, basic |
| 3 | ~30° | Music production |
| 7 | ~12° | High-end installations |

### Fractional Order (Width Control)
```
value = 1.0 → Maximum directivity (point source)
value = 0.5 → Intermediate width
value = 0.0 → Omnidirectional (diffuse)
```

### Distance Simulation
```
Inside speaker circle (r < 1):
  width = r          (reduce directivity)
  amplitude = 1.0

Outside speaker circle (r > 1):
  width = 1.0        (keep directional)
  amplitude = 1/r²   (inverse square law)
```

---

## 🌊 Granular Synthesis Parameters

### Essential Controls
```
Grain Duration:   5-100 ms
  Short (5-20ms)  → Dense, textural
  Long (50-100ms) → Sparse, cloud-like

Delay Time:       0-2000 ms
  Affects grain persistence and overlap

Feedback:         0-95%
  Higher = more grain reinjection

Rarefaction:      0-100%
  0%   = Maximum density
  100% = Very sparse
```

### Per-Harmonic Mapping (Order 7 example)
```
For harmonic index m (-7 to 7):

grain_size(m) = max_size × (1 - |m|/8)
  Example: m=0 → 100ms, m=7 → 12.5ms

delay_time(m) = max_delay × (|order(m)|+1)/(N+1)
  Example: m=0 → 125ms, m=7 → 1000ms
```

---

## 🔧 Common Signal Chains

### 1. Basic Point Source
```
Input → Encoder → Wider → Rotate → Optim → Decoder → Output
```

### 2. Granular Diffuse Field
```
Input → Encoder → Plug(Grain) → Decoder → Output
```

### 3. Hybrid Point/Diffuse
```
Input → Encoder ──┬─→ Direct ──┬─→ Mix → Decoder → Output
                  └─→ Diffuse ─┘
```

### 4. Spatial Processing
```
Input → Encoder → Project → Process → Recompose → Decoder → Output
```

### 5. Reverb Chain
```
Input → Encoder → [Direct + Reverb] → Decoder → Output
                      ↓
              (Decorrelation or Convolution)
```

---

## ⚙️ Optimization Types

### When to Use Each

**Basic (Sampling)**
- ✅ Listener at exact center
- ✅ Regular speaker layout
- ⚠️ Small sweet spot

**Max-rE**
- ✅ Multiple listeners
- ✅ Off-center listening
- ⚠️ Slightly less sharp localization

**In-Phase**
- ✅ Close to speakers
- ✅ Listener outside ring
- ⚠️ Requires more speakers for quality

---

## 🎨 Creative Techniques Quick List

### Spatial Effects
```
Rotation:    Global field spin
Width:       Source sharpness/diffusion  
Zoom:        Fisheye perspective (plane waves)
Filter:      Hide/reveal directions (plane waves)
Focus:       Virtual microphone pointing
Mirror:      Symmetric transformations
```

### Temporal Effects in HOA
```
Granulation:     Per-harmonic grain streams
Modulation:      LFO on each harmonic (1-20 Hz)
Decorrelation:   Different delays per harmonic
Reverb:          Parallel algorithmic or convolution
```

### Transitions
```
Point ←→ Diffuse:     Crossfade or gradual decorrelation
Near ←→ Far:          Width + amplitude control
Front ←→ Everywhere:  Rotation + width modulation
```

---

## 🐛 Troubleshooting Checklist

### Sound Issues

**Thin/weak output?**
- [ ] Check gain compensation for order
- [ ] Verify all harmonics are active (use scope~)
- [ ] Ensure proper decoding (enough speakers)

**Phasey/comb filtering?**
- [ ] Use inPhase optimization
- [ ] Increase order
- [ ] Check speaker spacing

**Limited sweet spot?**
- [ ] Try max-rE optimization
- [ ] Increase order
- [ ] Add diffusion/reverb

**Unstable localization?**
- [ ] Check encoder angles (0°=front, not right!)
- [ ] Verify coordinate system matches
- [ ] Reduce fractional order value

### Technical Issues

**High CPU usage?**
- [ ] Reduce order (major impact)
- [ ] Fewer grain streams
- [ ] Simplify reverb
- [ ] Disable visualizations

**Clicks/pops in granular?**
- [ ] Use smooth envelopes (Hanning, Gaussian)
- [ ] Increase grain overlap
- [ ] Add gentle lowpass filtering

**Artificial reverb tail?**
- [ ] Ensure decorrelation (varying delays)
- [ ] Don't over-reverb (< 30% wet)
- [ ] High-pass reverb input

---

## 📊 Decision Trees

### Choosing Order
```
Start here: What's your goal?
│
├─ Just testing/learning → Order 1
│
├─ Headphone/binaural work → Order 3-5
│
├─ Music production → Order 3
│
├─ Live performance → Order 3-5
│
└─ High-end installation → Order 5-7
```

### Diffuse Field Synthesis
```
What's your priority?
│
├─ Preserve timbre → Use modulation method
│
├─ Rich texture → Use granular method
│
└─ Smooth transition → Use gradual decorrelation
```

### Speaker Layout
```
How many speakers available?
│
├─ 2 (stereo) → Use binaural decoder
│
├─ 4-5 → Order 1 or 2
│
├─ 8 → Order 3
│
├─ 12-16 → Order 5
│
└─ 16+ → Order 7
```

---

## 🔬 Testing Protocols

### Basic Functionality Test
```
1. Impulse at 0° → Should be front-center
2. Sweep 0-360° → Smooth circular motion
3. Width 1→0 → Sharp to diffuse
4. Check all optimizations → Stable playback
```

### Granular Synthesis Test
```
1. Single stream → Audible grains
2. Multiple streams → Dense texture
3. Parameter sweep → Smooth changes
4. Long duration → CPU stable
```

### Spatial Accuracy Test
```
1. Pink noise at known angles
2. Measure perceived position
3. Check frequency response (flat?)
4. Test sweet spot boundaries
```

---

## 📚 Notation Key

Throughout the documents:

**Variables**
- `N` or `order` = Ambisonic order (integer)
- `m` or `index` = Harmonic index (-N to +N)
- `θ` or `azi` = Azimuth angle (degrees or radians)
- `φ` or `ele` = Elevation angle
- `r` = Radius/distance

**Coordinate System**
- 0° = Front
- 90° = Left
- 180° = Back
- 270° = Right
- Counter-clockwise = Positive rotation

**Order Notation**
- Order 1 = First order = FOA
- Order 7 = Seventh order = HOA
- 2D vs 3D = Circular vs Spherical harmonics

---

## 🗂️ Document Navigation

This is part of a 3-document set:

1. **THIS FILE** - Quick Reference
   - Fast lookup
   - Essential formulas
   - Decision aids

2. **Knowledge Base** (Ambisonics_And_Granular_Synthesis_Knowledge_Base.md)
   - Comprehensive theory
   - Mathematical foundations
   - Conceptual explanations

3. **Implementation Guide** (Practical_Implementation_Guide_Spatial_Audio.md)
   - Code examples
   - Workflows
   - Detailed techniques

---

## 🎵 Starter Recipes

### Recipe 1: Simple Spatialization
```
1. Load your mono source
2. hoa.encoder~ 3 (order 3)
3. hoa.optim~ 3 maxRe
4. hoa.decoder~ 3 for your speaker count
5. Adjust azimuth to position
6. Done!
```

### Recipe 2: Granular Cloud
```
1. Load soundfile into buffer
2. hoa.plug~ hoa.grain~ 3
3. Set grain size: 50ms
4. Set delay: 1000ms
5. Set feedback: 0.7
6. hoa.decoder~ 3
7. Tweak to taste!
```

### Recipe 3: Dynamic Spatial Texture
```
1. Source → hoa.encoder~ 5
2. hoa.wider~ 5 (modulate with LFO)
3. hoa.rotate~ 5 (slow rotation)
4. hoa.plug~ [add reverb per harmonic]
5. hoa.decoder~ 5
6. Enjoy evolving soundscape!
```

---

## 💡 Pro Tips

### Workflow Efficiency
- ✨ **Start low, scale up**: Test at Order 1, then increase
- ✨ **Use binaural for monitoring**: Avoid needing full speaker array during development
- ✨ **Visualize constantly**: scope~ and meter~ catch problems early
- ✨ **Save presets**: Document successful configurations

### Creative Approaches
- 🎨 **Think layers**: Combine point sources + diffuse fields
- 🎨 **Automate width**: Makes static sounds come alive
- 🎨 **Sync to rhythm**: Modulate spatial parameters with beat
- 🎨 **Use randomness**: Small variations prevent static feel

### Performance
- ⚡ **2D over 3D**: Huge savings when height not needed
- ⚡ **Share buffers**: Multiple granulators, one buffer
- ⚡ **Offline rendering**: Maximum quality without real-time constraints
- ⚡ **Profile first**: Identify actual bottlenecks before optimizing

---

## 🚀 Next Steps

### Beginner Path
1. Install HOA Library (Max/MSP or Pure Data)
2. Work through basic tutorials
3. Experiment with encoder + decoder
4. Add one effect (rotation or width)
5. Build up complexity gradually

### Intermediate Path
1. Master all optimization types
2. Experiment with granular synthesis
3. Create custom processing with plug~
4. Build complete pieces/installations
5. Explore plane wave techniques

### Advanced Path
1. Study ambisonic microphone techniques
2. Develop custom decoders
3. Combine with other spatial techniques (WFS, VBAP)
4. Contribute to open-source tools
5. Research new artistic applications

---

## 📖 Key References

**Essential Reading**
- Gerzon (1974) - Periphony papers
- Daniel (2000) - Représentation de champs acoustiques
- Malham (1992) - Large area ambisonics

**Software Documentation**
- HOA Library: hoalibrary.mshparisnord.fr
- IEM Plugin Suite: plugins.iem.at
- Ambitools (FAUST): github.com/sekisushai/ambitools

**Online Resources**
- Ambisonics.net - Wiki and forums
- YouTube 360 Help - Spatial audio specs
- FAUST documentation - DSP programming

---

## ⚡ Emergency Quick Fixes

**No sound?**
```
1. Check order matches everywhere (encoder, effects, decoder)
2. Verify speaker count ≥ 2*order + 1
3. Check decoder type (ambisonics/binaural)
```

**Sounds wrong?**
```
1. Check coordinate system (0° = front?)
2. Try different optimization
3. Verify speaker positions match decoder config
```

**CPU maxed out?**
```
1. Reduce order (order 7 → order 3 = 50% savings)
2. Fewer grain streams
3. Disable visualizers
```

**Want better quality?**
```
1. Increase order (if CPU allows)
2. More speakers (if possible)
3. Better optimization choice
4. Add subtle reverb (masks imperfections)
```

---

*For detailed explanations, see the full Knowledge Base document. For working examples and code, see the Implementation Guide.*

**Happy spatial audio creating! 🎧🌍✨**