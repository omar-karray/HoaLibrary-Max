---
layout: default
title: Practical Examples
---

# Practical Examples with HoaLibrary

[← Back to Home](index.md)

---

## Quick Start Patches

These are complete, copy-paste ready Max patches to get you started quickly.

---

## Example 1: Basic Stereo Spatialization

**Goal**: Pan a mono source around you and decode to stereo speakers

```
┌──────────────────────────────────────────────────────┐
│ [noise~]                 <- Audio source             │
│   |                                                   │
│ [*~ 0.3]                 <- Volume control           │
│   |                                                   │
│ [hoa.2d.encoder~ 3 0.]   <- Encode at front (0°)     │
│   |                                                   │
│ [hoa.2d.rotate~ 3]       <- Rotate the field         │
│   |                      |                           │
│   |         [phasor~ 0.1]  <- Auto-rotation (36°/s)  │
│   |              |                                    │
│   |         [* 360.]                                  │
│   |______________|                                    │
│   |                                                   │
│ [hoa.2d.scope~ 3]        <- Visualize                │
│   |                                                   │
│ [hoa.2d.decoder~ 3 stereo] <- Decode to L/R          │
│  |  |                                                 │
│ [dac~ 1 2]               <- Audio output             │
└──────────────────────────────────────────────────────┘
```

**What you'll hear**: Sound rotating smoothly around you in stereo

**Try changing**:
- `[phasor~ 0.1]` frequency for rotation speed
- `encoder~` order (1-7) to hear resolution differences
- Add `[line~]` for manual angle control

---

## Example 2: Multiple Sound Sources

**Goal**: Position and mix several sources in ambisonic space

```
┌──────────────────────────────────────────────────────┐
│ Source 1: Bass (front)                               │
│ [cycle~ 100]                                         │
│   |                                                   │
│                                                       │
│ Source 2: Mid (left)                                 │
│ [cycle~ 400]                                         │
│   |                                                   │
│                                                       │
│ Source 3: High (right)                               │
│ [cycle~ 1600]                                        │
│   |                                                   │
│       |____________|____________|                     │
│                    |                                  │
│              [hoa.2d.map~ 3]  <- Combine 3 sources   │
│         (Set positions: 0°, 270°, 90°)               │
│                    |                                  │
│              [hoa.2d.scope~ 3]  <- Visualize         │
│                    |                                  │
│        [hoa.2d.decoder~ 3 binaural] <- Headphones    │
│                 |  |                                  │
│              [dac~ 1 2]                               │
└──────────────────────────────────────────────────────┘
```

**What you'll hear**: Three tones positioned spatially around you

**Try**:
- Use `hoa.map` GUI to move sources interactively
- Add `[*~ 0.5]` before each source for individual volume
- Change decoder to `stereo` or `ambisonic 8` for speakers

---

## Example 3: Adding Spatial Width

**Goal**: Make a mono source sound wider and more spacious

```
┌──────────────────────────────────────────────────────┐
│ [adc~ 1]                 <- Microphone/line input    │
│   |                                                   │
│ [hoa.2d.encoder~ 5]      <- Encode (higher order)    │
│   |                                                   │
│ [hoa.2d.wider~ 5]        <- Widen the field          │
│   |                 |                                 │
│   |          [flonum]  <- Width amount (0-1)         │
│   |______________|                                    │
│   |                                                   │
│ [hoa.2d.decoder~ 5 stereo]                           │
│  |  |                                                 │
│ [dac~ 1 2]                                            │
└──────────────────────────────────────────────────────┘
```

**What you'll hear**: Source spreads wider as you increase width

**Parameters**:
- Width `0.0` = original point source
- Width `0.5` = moderate spread
- Width `1.0` = maximum diffusion

---

## Example 4: 3D Sound for VR/Headphones

**Goal**: Full sphere spatialization with binaural rendering

```
┌──────────────────────────────────────────────────────┐
│ [noise~]                                             │
│   |                                                   │
│ [hoa.3d.encoder~ 3]      <- 3D encoder (16 ch)       │
│   |                 |         |                       │
│   |        [0.  ]  [45. ]  <- Azimuth, Elevation     │
│   |____________|_______|                              │
│   |                                                   │
│ [hoa.3d.scope~ 3]        <- 3D visualization         │
│   |                                                   │
│ [hoa.3d.decoder~ 3 binaural] <- HRTF processing      │
│  |  |                                                 │
│ [dac~ 1 2]               <- HEADPHONES REQUIRED      │
└──────────────────────────────────────────────────────┘
```

**What you'll hear**: Sound positioned in 3D space with elevation

**Try**:
- Animate azimuth (0-360°) and elevation (-90° to 90°)
- Use order 5+ for more precise localization
- Connect to head tracker for VR

---

## Example 5: Recording & Playback

**Goal**: Record ambisonic field, play back on different system

### Recording Phase

```
┌──────────────────────────────────────────────────────┐
│ [Multiple sources...]                                │
│         |                                             │
│   [hoa.2d.map~ 5]        <- Encode multiple sources  │
│         |                                             │
│   [hoa.2d.scope~ 5]      <- Monitor while recording  │
│         |                                             │
│   [sfrecord~ 11]         <- Record 11 ch (order 5)   │
│     open myfield.aif                                  │
└──────────────────────────────────────────────────────┘
```

### Playback Phase

```
┌──────────────────────────────────────────────────────┐
│ [sfplay~ 11]             <- Play 11-channel file     │
│         |                                             │
│   [hoa.2d.rotate~ 5]     <- Can still transform!     │
│         |                                             │
│   [hoa.2d.decoder~ 5 ambisonic 16] <- Decode to 16 spk │
│         | (16 outputs)                                │
│   [hoa.dac~ 1-16]        <- Multichannel output      │
└──────────────────────────────────────────────────────┘
```

**Benefits**:
- Record once, decode anywhere
- Apply transformations in post
- Archive complete spatial scenes

---

## Example 6: Effects Processing

**Goal**: Apply reverb to entire ambisonic field

```
┌──────────────────────────────────────────────────────┐
│ [hoa.2d.map~ 3]          <- Encoded sources          │
│         |                                             │
│   [hoa.process~ hoa.fx.freeverb~ @order 3 @args 0.5] │
│         |                                             │
│         |  <- Reverb applied to whole field          │
│         |                                             │
│   [hoa.2d.decoder~ 3 stereo]                         │
│      |  |                                             │
│   [dac~ 1 2]                                          │
└──────────────────────────────────────────────────────┘
```

**Available Effects**:
- `hoa.fx.freeverb~` - Reverb
- `hoa.fx.delay~` - Multichannel delay
- `hoa.fx.gain~` - Level control
- `hoa.fx.decorrelation~` - Diffusion
- `hoa.fx.grain~` - Granular synthesis

---

## Example 7: Speaker Array Optimization

**Goal**: Decode to 8 speakers with optimization

```
┌──────────────────────────────────────────────────────┐
│ [hoa.2d.map~ 5]          <- Your spatial mix         │
│         |                                             │
│   [hoa.2d.optim~ 5 maxRe] <- Optimization            │
│         |                                             │
│   [hoa.2d.decoder~ 5 ambisonic 8] <- 8 speakers      │
│         | (8 outputs)                                 │
│   [hoa.dac~ 1-8]         <- To your speaker array    │
└──────────────────────────────────────────────────────┘
```

**Optimization Types**:
- `basic` - Standard decoding
- `maxRe` - Larger sweet spot, wider listening area
- `inPhase` - Better phase coherence

---

## Example 8: Interactive Source Control

**Goal**: Move sources with mouse/GUI control

```
┌──────────────────────────────────────────────────────┐
│ [saw~ 200]  [cycle~ 440]  [noise~]  <- 3 sources    │
│     |            |            |                       │
│     |____________|____________|                       │
│                  |                                    │
│            [hoa.map 3]       <- GUI for positioning  │
│                  |                                    │
│            [hoa.2d.map~ 3]   <- Audio encoder        │
│                  |                                    │
│            [hoa.2d.scope~ 3] <- Visualize            │
│                  |                                    │
│       [hoa.2d.decoder~ 3 stereo]                     │
│              |  |                                     │
│           [dac~ 1 2]                                  │
└──────────────────────────────────────────────────────┘
```

**Features**:
- Click and drag to position sources
- Visual feedback in real-time
- Save/recall positions

---

## Example 9: Send/Receive Architecture

**Goal**: Centralized ambisonic bus for multiple sources

```
┌──────────────────────────────────────────────────────┐
│ SUBPATCHER 1:                                        │
│ [saw~ 100]                                           │
│   |                                                   │
│ [hoa.2d.encoder~ 3]                                  │
│   |                                                   │
│ [hoa.send~ ambi_bus 3]   <- Send to bus              │
│                                                       │
│ SUBPATCHER 2:                                        │
│ [cycle~ 440]                                         │
│   |                                                   │
│ [hoa.2d.encoder~ 3]                                  │
│   |                                                   │
│ [hoa.send~ ambi_bus 3]   <- Send to same bus        │
│                                                       │
│ MAIN OUTPUT:                                         │
│ [hoa.receive~ ambi_bus 3] <- Receive combined        │
│   |                                                   │
│ [hoa.2d.decoder~ 3 stereo]                           │
│  |  |                                                 │
│ [dac~ 1 2]                                            │
└──────────────────────────────────────────────────────┘
```

**Use case**: Complex patches with many spatial sources

---

## Example 10: Dynamic Order Switching

**Goal**: Compare different ambisonic orders live

```
┌──────────────────────────────────────────────────────┐
│ [noise~]                                             │
│   |                                                   │
│   |-----[hoa.2d.encoder~ 1]--[gate~ 7 1]             │
│   |                                |                  │
│   |-----[hoa.2d.encoder~ 3]--[gate~ 7 2]             │
│   |                                |                  │
│   |-----[hoa.2d.encoder~ 5]--[gate~ 7 3]             │
│                                    |                  │
│          [umenu: Order 1, Order 3, Order 5]          │
│                         |                             │
│                    [gate~ 7]  <- Select order        │
│                         |                             │
│              [hoa.2d.decoder~ 5 stereo]              │
│                      |  |                             │
│                   [dac~ 1 2]                          │
└──────────────────────────────────────────────────────┘
```

**Educational use**: Hear the difference in spatial resolution

---

## Real-World Application Examples

### 🎵 Music Production Setup

```
Studio Monitoring Chain:
- Multiple instrument tracks
- Each encoded at source position
- Combined in ambisonic domain
- Effects in HOA domain (reverb, delay)
- Decode to studio monitors
- Also decode to binaural for headphone monitoring
- Export ambisonic stems for VR/AR
```

### 🎮 Game Audio Engine

```
Dynamic 3D Scene:
- Player at center (listener position)
- Enemies/objects encode at their 3D positions
- Sounds follow object movement
- Global reverb in ambisonic domain
- Head-tracked binaural output
- Scales to any speaker count
```

### 🎭 Live Performance

```
Concert Setup:
- Musicians/instruments at fixed positions
- Electronic sources spatially animated
- Field manipulations (rotation, widening)
- Decode to dome or surround array
- Real-time visualization for audience
```

---

## Performance Tips

### Choosing the Right Order

| Application | Recommended Order | Why |
|-------------|------------------|-----|
| Stereo output | 3 | Good balance, not overkill |
| Binaural | 5-7 | Higher = better localization |
| 8 speakers | 3-5 | Match speakers ≥ channels |
| 16+ speakers | 5-7 | Utilize full array |
| Real-time game | 1-3 | CPU efficiency |
| Music production | 3-5 | Professional quality |

### CPU Optimization

```
LOW CPU:
- Use 2D instead of 3D when possible
- Lower orders (1-3)
- Fewer sources
- Decode only at final output

HIGH QUALITY:
- Use 3D for true immersion
- Higher orders (5-7)
- Process in HOA domain
- Multiple decode options
```

---

## Common Workflows

### Workflow 1: Live Spatialization
1. Sources → `hoa.2d.map~`
2. Transformations → `hoa.2d.rotate~`, `hoa.2d.wider~`
3. Effects → `hoa.process~`
4. Decode → match your playback system

### Workflow 2: Studio Production
1. Record sources with spatial metadata
2. Mix in ambisonic domain
3. Apply spatial effects
4. Export ambisonic stems (future-proof)
5. Decode to delivery formats

### Workflow 3: Installation
1. Create content at any order
2. Bring to venue
3. Decode to venue's speaker setup
4. Optimize for room acoustics
5. Done!

---

## Next Steps

**Ready to dive deeper?**
- [Interactive Tutorials](tutorials.md) - 10 built-in Max patches
- [Object Reference](OBJECTS.md) - All 37 externals documented
- [What is HOA?](what-is-hoa.md) - Theoretical background

**Build your own patches!**
- Start with Example 1 or 2
- Modify parameters and listen
- Combine techniques from multiple examples
- Share your creations!

---

[← Back to Home](index.md) | [Tutorials →](tutorials.md) | [Objects →](OBJECTS.md)
