---
layout: default
title: Getting Started Guide
---

# Getting Started with HoaLibrary

[← Back to Home](index.md)

A step-by-step guide to start working with Higher Order Ambisonics in Max.

---

## 🎯 What You'll Learn

By the end of this guide, you'll be able to:
- ✅ Understand the basic ambisonic workflow
- ✅ Create your first spatial audio patch
- ✅ Position and move sound sources in space
- ✅ Decode to different speaker configurations
- ✅ Apply spatial transformations

**Time needed**: 30-45 minutes

---

## Prerequisites

### Required
- ✅ Max 9.0+ installed
- ✅ HoaLibrary v3.0+ installed ([Installation Guide](INSTALLATION.md))
- ✅ Basic Max knowledge (objects, patching, audio)

### Recommended
- 🎧 Headphones for binaural testing
- 🔊 Stereo speakers for initial experiments
- 📖 Read [What is HOA?](what-is-hoa.md) for theory

---

## Step 1: Understanding the Workflow

### The Three Stages

Every ambisonic patch follows this pattern:

```
┌─────────┐      ┌────────────┐      ┌─────────┐
│ ENCODE  │  →   │ TRANSFORM  │  →   │ DECODE  │
└─────────┘      └────────────┘      └─────────┘
   Sources      Rotate, Widen,         Speakers
  to HOA        Effects, etc.          or Phones
```

**Why this matters**: 
- You can record at ENCODE stage (format-independent)
- You can swap DECODE for any speaker setup
- TRANSFORM operations work on entire sound field

---

## Step 2: Your First Ambisonic Patch

### 2.1 Create Basic Encoder/Decoder

Open Max and create this patch:

```max
┌─────────────────────────────────────┐
│ [noise~]                            │
│   |                                 │
│ [*~ 0.3]        <- Volume control   │
│   |                                 │
│ [hoa.2d.encoder~ 3]  <- ORDER 3     │
│   |                                 │
│ [hoa.2d.decoder~ 3 stereo]          │
│  |  |                               │
│ [dac~ 1 2]                          │
└─────────────────────────────────────┘
```

**💡 Tip**: Start with order 3 - it's the sweet spot for learning.

### 2.2 What Just Happened?

- `hoa.2d.encoder~ 3` = Converts mono to 7 channels (2×3+1)
- `hoa.2d.decoder~ 3 stereo` = Converts 7 channels to L/R
- Sound is now "spatialized" but static at front (0°)

### 2.3 Test It

1. Lock patch (⌘E)
2. Turn on audio (click speaker icon)
3. You should hear white noise in stereo

**Congratulations!** You just encoded and decoded your first ambisonic signal.

---

## Step 3: Add Movement

### 3.1 Add Rotation

Modify your patch:

```max
┌─────────────────────────────────────┐
│ [noise~]                            │
│   |                                 │
│ [*~ 0.3]                            │
│   |                                 │
│ [hoa.2d.encoder~ 3]                 │
│   |                                 │
│ [hoa.2d.rotate~ 3]  <- NEW!         │
│   |               |                 │
│   |     [phasor~ 0.1]  <- 0.1 Hz    │
│   |           |                     │
│   |      [* 360.]  <- 360°          │
│   |___________|                     │
│   |                                 │
│ [hoa.2d.decoder~ 3 stereo]          │
│  |  |                               │
│ [dac~ 1 2]                          │
└─────────────────────────────────────┘
```

### 3.2 What Changed?

- `phasor~ 0.1` = Ramp from 0-1 every 10 seconds
- `* 360.` = Convert to 0-360 degrees
- `hoa.2d.rotate~` = Spins the entire sound field

**Listen**: Sound now rotates smoothly around you!

### 3.3 Experiment

Try changing:
- `phasor~ 0.1` → `phasor~ 0.5` (faster rotation)
- `phasor~ 0.1` → `phasor~ 0.05` (slower rotation)
- Replace phasor with `[line~]` for manual control

---

## Step 4: Visualize the Sound Field

### 4.1 Add Scope

Insert visualization:

```max
┌─────────────────────────────────────┐
│ [noise~]                            │
│   |                                 │
│ [*~ 0.3]                            │
│   |                                 │
│ [hoa.2d.encoder~ 3]                 │
│   |                                 │
│ [hoa.2d.rotate~ 3]                  │
│   |                                 │
│ [hoa.2d.scope~ 3]  <- NEW!          │
│   |                                 │
│ [hoa.2d.decoder~ 3 stereo]          │
│  |  |                               │
│ [dac~ 1 2]                          │
└─────────────────────────────────────┘
```

### 4.2 What You See

The scope shows:
- **White dot** = Sound source position
- **Circular pattern** = Energy distribution
- **Brightness** = Amplitude level

**Watch**: The dot rotates as the sound moves!

---

## Step 5: Multiple Sources

### 5.1 Using hoa.map~

Create a patch with 3 sources:

```max
┌─────────────────────────────────────┐
│ [cycle~ 200]  <- Bass               │
│      |                              │
│ [cycle~ 600]  <- Mid                │
│      |                              │
│ [cycle~ 1200] <- High               │
│      |                              │
│      |________|___________|         │
│                |                    │
│         [hoa.2d.map~ 3]  <- NEW!    │
│                |                    │
│         [hoa.2d.scope~ 3]           │
│                |                    │
│    [hoa.2d.decoder~ 3 binaural]     │
│             |  |                    │
│          [dac~ 1 2]                 │
└─────────────────────────────────────┘
```

### 5.2 Position Sources

1. Double-click `hoa.2d.map~ 3`
2. Inspector → Set number of sources: 3
3. Lock patch
4. You'll see GUI with 3 source markers
5. Click and drag each source to position:
   - Source 1 (red): 0° (front)
   - Source 2 (green): 120° (back-left)
   - Source 3 (blue): 240° (back-right)

### 5.3 Interactive Control

**While patch is running**:
- Drag sources around
- Hear spatial positions change in real-time
- See scope update

**💡 Tip**: Use binaural decoding with headphones for best 3D effect.

---

## Step 6: Add Spatial Width

### 6.1 Using hoa.wider~

Enhance your patch:

```max
┌─────────────────────────────────────┐
│ [cycle~ 440]                        │
│      |                              │
│ [hoa.2d.encoder~ 5]  <- Higher order│
│      |                              │
│ [hoa.2d.wider~ 5]  <- NEW!          │
│      |          |                   │
│      |    [flonum]  <- 0.0 to 1.0   │
│      |__________|                   │
│      |                              │
│ [hoa.2d.scope~ 5]                   │
│      |                              │
│ [hoa.2d.decoder~ 5 stereo]          │
│      |  |                           │
│   [dac~ 1 2]                        │
└─────────────────────────────────────┘
```

### 6.2 Experiment with Width

Try these values in the flonum:
- `0.0` = Point source (focused)
- `0.3` = Slight spread
- `0.6` = Wide image
- `1.0` = Maximum diffusion

**Listen**: Higher values make sound more spacious and immersive.

---

## Step 7: Different Decoder Modes

### 7.1 Decoder Options

Replace your decoder with these options:

**For Headphones** (Binaural):
```max
[hoa.2d.decoder~ 3 binaural]
```
- Uses Head-Related Transfer Function (HRTF)
- Best 3D localization with headphones

**For Stereo Speakers**:
```max
[hoa.2d.decoder~ 3 stereo]
```
- Standard stereo panning
- Works with any L/R setup

**For 8 Speakers in Circle**:
```max
[hoa.2d.decoder~ 3 ambisonic 8]
```
- Decodes to 8 equally-spaced speakers
- Requires `hoa.dac~` or multichannel audio interface

**For 5.1 System**:
```max
[hoa.2d.decoder~ 3 irregular]
```
- Custom speaker positions (see help file)

### 7.2 Choosing the Right Decoder

| Situation | Use This | Why |
|-----------|----------|-----|
| Working alone | `binaural` | Best localization with headphones |
| Studio monitoring | `stereo` | Standard stereo workflow |
| Installation with circle | `ambisonic N` | Pure ambisonic decode |
| Home theater | `irregular` | Match your actual setup |

---

## Step 8: Record Your Work

### 8.1 Recording Ambisonic Fields

**DON'T** record decoded audio.  
**DO** record the ambisonic field:

```max
┌─────────────────────────────────────┐
│ [Your spatial mix...]               │
│         |                           │
│ [hoa.2d.map~ 3]  <- 7 channels      │
│         |                           │
│ [sfrecord~ 7]    <- Record HERE     │
│         |                           │
│ [hoa.2d.scope~ 3]  <- Monitor       │
│         |                           │
│ [hoa.2d.decoder~ 3 stereo]          │
└─────────────────────────────────────┘
```

### 8.2 Why Record in Ambisonic Domain?

**Advantages**:
- ✅ Decode to ANY speaker setup later
- ✅ Apply transformations in post
- ✅ Future-proof your work
- ✅ VR/AR ready
- ✅ Re-mix for different venues

**File Format**: Use WAV or AIFF, multi-channel

---

## Step 9: Add Effects

### 9.1 Using hoa.process~

Apply effects to entire spatial scene:

```max
┌─────────────────────────────────────┐
│ [hoa.2d.map~ 3]                     │
│         |                           │
│ [hoa.process~ hoa.fx.freeverb~      │
│    @order 3 @args 0.5]              │
│         |                           │
│ [hoa.2d.decoder~ 3 stereo]          │
└─────────────────────────────────────┘
```

### 9.2 Available Effects

- `hoa.fx.freeverb~` - Reverb
- `hoa.fx.delay~` - Spatial delay
- `hoa.fx.decorrelation~` - Diffusion
- `hoa.fx.gain~` - Volume control
- `hoa.fx.grain~` - Granular synthesis

**💡 Tip**: See [Practical Examples](examples.md) for effect recipes.

---

## Step 10: Optimization for Performance

### 10.1 Order Selection Guide

**For Real-Time Performance**:
- Order 1-2: Very fast, basic spatialization
- Order 3: Good balance (recommended to start)
- Order 5: High quality, moderate CPU
- Order 7+: Maximum precision, CPU intensive

### 10.2 2D vs 3D

**Use 2D when**:
- ✅ Horizontal plane only (music, stereo)
- ✅ Lower channel count needed
- ✅ CPU efficiency important

**Use 3D when**:
- ✅ Need elevation (domes, VR)
- ✅ Full spherical coverage
- ✅ Immersive experiences

### 10.3 Performance Tips

```max
BAD: Decode multiple times
[encoder~] → [decoder~] → [dac~]
[encoder~] → [decoder~] → [dac~]
[encoder~] → [decoder~] → [dac~]

GOOD: Combine then decode once
[encoder~] ⎤
[encoder~] ⎥→ [+~] → [decoder~] → [dac~]
[encoder~] ⎦
```

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Wrong Channel Count
```max
[hoa.2d.encoder~ 3]  ← 7 channels out
[hoa.2d.decoder~ 5 stereo]  ← Expects 11 channels!
```
**Fix**: Match orders exactly!

### ❌ Mistake 2: Forgetting Audio On
Your patch works but no sound?
- Check speaker icon is ON
- Check volume `[*~ 0.3]`
- Check `[dac~]` numbers match outputs

### ❌ Mistake 3: Recording Decoded Audio
```max
[encoder~] → [decoder~] → [sfrecord~]  ❌
```
**Fix**: Record BEFORE decoding!

### ❌ Mistake 4: Too High Order
Starting with order 7 = 64 channels (3D) = CPU overload
**Fix**: Start with order 3, increase if needed

---

## Next Steps

### 🎓 Continue Learning

**Beginner → Intermediate**:
1. ✅ [Interactive Tutorials](tutorials.md) - 10 built-in Max patches
2. ✅ [Practical Examples](examples.md) - Ready-to-use patches
3. ✅ Try different decoder modes

**Intermediate → Advanced**:
1. ✅ Move to 3D ambisonic objects
2. ✅ Build complex `hoa.process~` chains
3. ✅ Use higher orders (5-7)
4. ✅ Custom speaker arrays

### 📖 Deep Dive

- [What is HOA?](what-is-hoa.md) - Theory and mathematics
- [Object Reference](OBJECTS.md) - All 37 externals
- [References](references.md) - Academic papers

### 💡 Get Inspired

- Check Package extras for example patches
- Browse Max forums for user creations
- Experiment and break things!

---

## Troubleshooting

### No Sound Output

**Check**:
1. Audio is ON (speaker icon)
2. `[dac~]` channel numbers are correct
3. Volume control `[*~]` is not zero
4. Audio interface is selected (Options → Audio Status)

### Weird Stereo Image

**Possible causes**:
- Order mismatch between encoder/decoder
- Wrong decoder mode for your setup
- Phase issues (try different optimization)

### High CPU Usage

**Solutions**:
- Lower ambisonic order (3 instead of 7)
- Use 2D instead of 3D
- Reduce number of simultaneous sources
- Disable visualization while performing

### Can't Find Objects

**Check**:
- HoaLibrary is installed correctly
- Package shows in Package Manager
- Restart Max if just installed
- See [Installation Guide](INSTALLATION.md)

---

## Quick Reference Card

```
BASIC WORKFLOW:
[source~] → [encoder~] → [rotate~] → [decoder~] → [dac~]

ORDERS:
2D: channels = 2×order + 1
3D: channels = (order+1)²

COMMON OBJECTS:
hoa.2d.encoder~     - Encode sources to HOA
hoa.2d.decoder~     - Decode to speakers
hoa.2d.rotate~      - Rotate sound field
hoa.2d.wider~       - Increase spaciousness
hoa.2d.map~         - Multiple sources
hoa.2d.scope~       - Visualize field
hoa.process~        - Apply effects

DECODER MODES:
stereo              - L/R speakers
binaural            - Headphones (HRTF)
ambisonic N         - N speakers in circle
irregular           - Custom positions
```

---

## Summary

You now know how to:
- ✅ Create basic ambisonic patches
- ✅ Encode, transform, and decode audio
- ✅ Position and move sources in space
- ✅ Visualize sound fields
- ✅ Choose appropriate settings
- ✅ Avoid common mistakes

**Time to create!** Start with these examples and build your own spatial audio patches.

---

[← Back to Home](index.md) | [Tutorials →](tutorials.md) | [Examples →](examples.md)
