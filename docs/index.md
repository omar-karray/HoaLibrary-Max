---
layout: default
title: Home
---

# HoaLibrary for Max

> **High Order Ambisonics library for Max 9 with Apple Silicon support**

A comprehensive suite of externals and patches for 2D and 3D spatial audio processing using circular and spherical harmonics.

[![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Max](https://img.shields.io/badge/Max-9.0%2B-orange.svg)](https://cycling74.com/products/max)
[![Architecture](https://img.shields.io/badge/architecture-Universal%20Binary-green.svg)](https://developer.apple.com/documentation/apple-silicon)
[![License](https://img.shields.io/badge/license-GPL%20v3-blue.svg)](https://github.com/omar-karray/HoaLibrary-Max/blob/master/LICENSE.txt)

---

## Quick Start

### Download & Install

1. **[Download Latest Release (v3.0.0)](https://github.com/omar-karray/HoaLibrary-Max/releases/latest)**
2. Extract the zip file
3. Copy `HoaLibrary` folder to: `~/Documents/Max 9/Packages/`
4. Restart Max

### First Patch

```
[noise~]
|
[hoa.2d.encoder~ 3]
|
[hoa.2d.decoder~ 3 stereo]
|  |
[dac~ 1 2]
```

---

## Start Here

<div class="cards">
  <div class="card highlight">
    <h3>Getting Started</h3>
    <p><strong>New to ambisonics?</strong> Follow our step-by-step guide to create your first spatial audio patch in 30 minutes</p>
    <a href="guides/getting-started.html" class="button primary">Start Tutorial</a>
  </div>
  
  <div class="card">
    <h3>Installation</h3>
    <p>Download and set up HoaLibrary in Max 9</p>
    <a href="legacy/INSTALLATION.html" class="button">Install Now</a>
  </div>
  
  <div class="card">
    <h3>What is HOA?</h3>
    <p>Understand the theory behind Higher Order Ambisonics</p>
    <a href="theory/what-is-hoa.html" class="button">Learn Theory</a>
  </div>
</div>

---

## Guides & Documentation

<div class="cards">
  <div class="card">
    <h3>📚 Knowledge Base</h3>
    <p><strong>Comprehensive resources:</strong> Theory, workflows, and spatial granular synthesis</p>
    <a href="knowledge_base/index.html" class="button">Explore Knowledge Base</a>
  </div>
  
  <div class="card">
    <h3>Interactive Tutorials</h3>
    <p>10 built-in Max patches teaching HOA concepts hands-on</p>
    <a href="guides/tutorials.html" class="button">Browse Tutorials</a>
  </div>
  
  <div class="card">
    <h3>Practical Examples</h3>
    <p>Copy-paste ready patches: stereo, multichannel, VR, effects</p>
    <a href="guides/examples.html" class="button">See Examples</a>
  </div>
  
  <div class="card">
    <h3>Object Reference</h3>
    <p>Complete documentation of all 37 externals by category</p>
    <a href="OBJECTS.html" class="button">Browse Objects</a>
  </div>
</div>

---

## Developer Resources

<div class="cards">
  <div class="card">
    <h3>⚡ C++ Quick Refresher</h3>
    <p>Back to C++ after PHP/Laravel? Quick guide to pointers, headers, and templates</p>
    <a href="guides/CPP_REFRESHER.html" class="button">Review C++</a>
  </div>
  
  <div class="card">
    <h3>📘 API Reference</h3>
    <p>Complete C++ API documentation for all classes and Max objects</p>
    <a href="api/API_REFERENCE.html" class="button">Browse API</a>
  </div>
  
  <div class="card">
    <h3>🏗️ Architecture Guide</h3>
    <p>System architecture with Mermaid diagrams and design patterns</p>
    <a href="reference/ARCHITECTURE.html" class="button">Explore Architecture</a>
  </div>
  
  <div class="card">
    <h3>🔬 Technical Audit</h3>
    <p>Deep dive into DSP implementation and code quality analysis</p>
    <a href="reference/TECHNICAL_AUDIT.html" class="button">Read Audit</a>
  </div>
  
  <div class="card">
    <h3>⚙️ Optimization Guide</h3>
    <p>Performance tuning strategies with benchmarks and SIMD techniques</p>
    <a href="reference/OPTIMIZATION_GUIDE.html" class="button">Optimize</a>
  </div>
  
  <div class="card">
    <h3>Academic References</h3>
    <p>Research papers, institutions, citations, and related software</p>
    <a href="guides/references.html" class="button">Explore</a>
  </div>
</div>

---

## Features

### 2D & 3D Ambisonics
- Full suite of encoders and decoders
- Up to order 7+ supported
- Optimized for Apple Silicon

### Real-time Processing
- Rotation, widening, and effects
- `hoa.process~` for custom chains
- Efficient multichannel handling

### Visualization Tools
- Interactive scopes and meters
- Source position mapping
- Real-time sound field display

### Universal Binary
- Native Apple Silicon (arm64)
- Intel Mac support (x86_64)
- Optimized performance

---

## Use Cases

**Music Production** - Immersive spatial mixes and VR/AR audio

**Game Development** - Dynamic 3D soundscapes with head tracking

**Installation Art** - Venue-adaptable multichannel playback

**Research** - Spatial audio experiments and psychoacoustics

**Post-Production** - 360° video audio and Dolby Atmos workflows

---

## Credits

### Original Authors (2012-2015)
**CICM** - Université Paris 8, France
- Pierre Guillot
- Eliott Paris
- Julien Colafrancesco

### v3.0 Modernization (2025)
**Omar Karray** - Current Maintainer
- Apple Silicon support
- Max 9 compatibility
- Modern build system

---

## License

Licensed under [GNU GPL v3.0](https://github.com/omar-karray/HoaLibrary-Max/blob/master/LICENSE.txt)

---

## Links

- [GitHub Repository](https://github.com/omar-karray/HoaLibrary-Max)
- [Report Issues](https://github.com/omar-karray/HoaLibrary-Max/issues)
- [Original HoaLibrary](http://www.mshparisnord.fr/hoalibrary/)
- [CICM](http://cicm.mshparisnord.org/)

---

<div class="footer-note">
Made with ❤️ for the Max community
</div>
