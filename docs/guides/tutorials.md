---
layout: default
title: Tutorials
---

# HoaLibrary Tutorials

[← Back to Home](index.md)

---

## Learning Path

HoaLibrary includes **10 interactive Max patches** that teach you Higher Order Ambisonics from the ground up. These tutorials are built right into the package and are the best way to learn HOA concepts hands-on.

---

## 📚 Tutorial Series

### Tutorial 01 - Introduction
**Topics**: What is Ambisonics, advantages, limitations, basic workflow

**You'll learn**:
- The fundamental concept of Ambisonics
- How encoding and decoding work
- Advantages over traditional techniques
- When to use HOA vs other methods

**Key Objects**: `hoa.2d.encoder~`, `hoa.2d.decoder~`, `hoa.2d.scope~`

---

### Tutorial 02 - Space Representation
**Topics**: Understanding ambisonic orders, channel counts, spatial resolution

**You'll learn**:
- What ambisonic order means
- How order affects spatial accuracy
- Channel count formulas (2D vs 3D)
- Choosing the right order for your needs

**Key Concepts**: Order, harmonics, spatial resolution

---

### Tutorial 03 - Harmonics
**Topics**: Deep dive into circular and spherical harmonics

**You'll learn**:
- What harmonics represent physically
- How harmonics combine to form sound fields
- Visualizing harmonic patterns
- The mathematics (simplified)

**Key Objects**: `hoa.2d.scope~` with different modes

---

### Tutorial 04 - Planewaves
**Topics**: Planewave decomposition and reconstruction

**You'll learn**:
- What planewaves are in ambisonic context
- How to decompose sound fields into planewaves
- Recomposing with custom weights
- Creative applications

**Key Objects**: `hoa.2d.recomposer~`, `hoa.2d.recomposer`

---

### Tutorial 05 - Spatial Resolution
**Topics**: How order affects localization accuracy

**You'll learn**:
- Testing spatial resolution at different orders
- Sweet spot size and listening area
- Trade-offs between quality and CPU usage
- Practical order recommendations

**Experiments**: A/B comparisons at orders 1, 3, 5, 7

---

### Tutorial 06 - Encoding
**Topics**: Converting sources into the ambisonic domain

**You'll learn**:
- Single source encoding
- Multiple source encoding with `hoa.map~`
- Positioning sources (azimuth, elevation)
- Dynamic source movement

**Key Objects**: `hoa.2d.encoder~`, `hoa.2d.map~`, `hoa.map`

---

### Tutorial 07 - Decoding
**Topics**: Converting ambisonic fields to speakers

**You'll learn**:
- Decoding modes (ambisonic, binaural, stereo)
- Speaker array configurations
- Regular vs irregular arrays
- Decoder optimization types

**Key Objects**: `hoa.2d.decoder~` with various modes

---

### Tutorial 08 - Optimization
**Topics**: Improving sound field rendering

**You'll learn**:
- Basic vs optimized decoding
- MaxRE optimization (larger sweet spot)
- InPhase optimization (phase coherence)
- When to use which optimization

**Key Objects**: `hoa.2d.optim~`, `hoa.2d.decoder~` modes

---

### Tutorial 09 - Rotation
**Topics**: Rotating the entire sound field

**You'll learn**:
- Sound field rotation concept
- Automating rotation for movement
- Rotation vs source repositioning
- Performance advantages

**Key Objects**: `hoa.2d.rotate~`, `hoa.3d.rotate~`

---

### Tutorial 10 - Wider
**Topics**: Increasing spatial diffusion and spaciousness

**You'll learn**:
- What spatial widening does
- Diffusion parameters
- Creative uses of widening
- Combining with other transformations

**Key Objects**: `hoa.2d.wider~`, `hoa.3d.wider~`

---

## 🚀 How to Access Tutorials

### From Max

1. **Method 1**: File Browser
   ```
   Max → File → Open
   Navigate to: Packages/HoaLibrary/extras/HoaLibrary/Tutorials-en/
   Open any tutorial patch
   ```

2. **Method 2**: Package Browser
   ```
   Max → Extras → Show Package Manager
   Find "HoaLibrary"
   Click "extras" folder
   Browse Tutorials-en/
   ```

3. **Method 3**: From Finder
   ```
   ~/Documents/Max 9/Packages/HoaLibrary/extras/HoaLibrary/Tutorials-en/
   ```

### Available Languages

- **English**: `Tutorials-en/`
- **French**: `Tutoriels-fr/`

---

## 🎯 Recommended Learning Order

### For Complete Beginners

Follow the tutorials in order (01 → 10):

1. **Tutorial 01** - Understand what HOA is
2. **Tutorial 02** - Learn about orders and resolution
3. **Tutorial 06** - Learn encoding (making ambisonic fields)
4. **Tutorial 07** - Learn decoding (playing back)
5. **Tutorial 09** - Experiment with rotation
6. **Tutorial 10** - Try spatial widening

**Skip initially**: Tutorials 03, 04, 08 (more advanced theory)

### For Experienced Users

Jump to what you need:

- **Quick refresh** → Tutorial 01
- **Encoding multiple sources** → Tutorial 06
- **Speaker array setup** → Tutorial 07, 08
- **Creative transformations** → Tutorial 09, 10
- **Deep theory** → Tutorial 03, 04

---

## 💡 Tutorial Tips

### Make Them Your Own
- **Modify** the patches - experimentation is key!
- **Save copies** to preserve originals
- **Add comments** with your discoveries

### Listen Carefully
- **Use headphones** for binaural decoding
- **Try different orders** to hear resolution differences
- **A/B test** different decoder modes

### Visualize
- Keep `hoa.2d.scope~` visible while experimenting
- Watch `hoa.2d.meter~` to understand channel activity
- Use `hoa.map` for visual source positioning

### Start Simple
- Begin with **order 3** (good balance)
- Use **2D** before attempting 3D
- **Stereo/binaural** decode before complex arrays

---

## 🎓 Additional Learning Resources

### Built-in Help Files
Every HoaLibrary object has comprehensive help:
```
Right-click any object → "Open Help"
```

### Overview Patch
Quick reference of all objects:
```
Packages/HoaLibrary/extras/HoaLibrary/hoa.overview.maxpat
```

### Order Tool
Calculate channel counts:
```
Packages/HoaLibrary/extras/HoaLibrary/OrderTool.maxpat
```

### Object Reference
Complete documentation:
- **[Object Reference](OBJECTS.md)** - All 37 externals
- **[What is HOA?](what-is-hoa.md)** - Conceptual guide

---

## 📖 Tutorial Quick Reference

| Tutorial | Focus | Difficulty | Key Objects |
|----------|-------|------------|-------------|
| 01 | Introduction | ⭐ Beginner | encoder~, decoder~ |
| 02 | Spatial Resolution | ⭐ Beginner | Understanding orders |
| 03 | Harmonics | ⭐⭐ Intermediate | scope~ modes |
| 04 | Planewaves | ⭐⭐ Intermediate | recomposer~ |
| 05 | Resolution Testing | ⭐⭐ Intermediate | A/B comparison |
| 06 | Encoding | ⭐ Beginner | encoder~, map~ |
| 07 | Decoding | ⭐⭐ Intermediate | decoder~ modes |
| 08 | Optimization | ⭐⭐⭐ Advanced | optim~, decoder~ |
| 09 | Rotation | ⭐ Beginner | rotate~ |
| 10 | Wider | ⭐ Beginner | wider~ |

---

## 🎬 Next Steps

After completing tutorials:

1. **Build your own patches** using the concepts
2. **Explore help files** for advanced features
3. **Check examples** in the extras folder
4. **Experiment** with `hoa.process~` for effects chains
5. **Read** the [What is HOA?](what-is-hoa.md) guide for deeper understanding

---

## 💬 Need Help?

- **GitHub Issues**: [Report problems](https://github.com/omar-karray/HoaLibrary-Max/issues)
- **GitHub Discussions**: [Ask questions](https://github.com/omar-karray/HoaLibrary-Max/discussions)
- **Max Forums**: [Cycling '74 Community](https://cycling74.com/forums)

---

[← Back to Home](index.md) | [What is HOA? →](what-is-hoa.md) | [Objects →](OBJECTS.md)
