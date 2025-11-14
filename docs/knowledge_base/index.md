---
layout: default
title: Knowledge Base - HoaLibrary
---

# Knowledge Base

**Comprehensive theoretical and practical resources for spatial audio**

---

## 📚 Complete Guides

### [Comprehensive Ambisonics Knowledge Base](abisonics_knowledge_base.html)

**Complete theoretical foundation** covering:
- Core ambisonic concepts and mathematics
- B-format and Higher Order Ambisonics (HOA)
- Spatial encoding and decoding strategies
- HOA Library architecture deep dive
- Granular synthesis in spatial audio
- Plane wave decomposition
- Advanced techniques

**Best for**: Understanding the theory, mathematics, and fundamental concepts

---

### [Practical Implementation Guide](practical_implementation_guide_ambisonics.html)

**Real-world workflows and techniques** including:
- Quick start workflows (point sources, granular, diffusion)
- Multi-source composition strategies
- Dynamic spatial effects
- Microphone array processing
- Binaural rendering workflows
- Processing suite (hoa.process~) patterns
- Troubleshooting and optimization

**Best for**: Building actual patches and creative applications

---

### [Spatial Granular Synthesis: Complete Guide](spacial_granular_synthesis.html)

**From theory to implementation** covering:
- Granular synthesis foundations
- Per-harmonic vs grain swarm paradigms
- GrainflowLib C++ architecture
- Grainflow for Max/MSP
- HOA Library granular approach
- Creative techniques and patterns
- Performance optimization

**Best for**: Advanced spatial granular techniques and custom implementations

---

### [Quick Reference Cards](quick_refs.html)

**Essential formulas and parameters** including:
- Core ambisonic formulas
- Channel count calculations
- Angular resolution by order
- Granular synthesis parameters
- Common workflows cheat sheet

**Best for**: Quick lookups while working

---

## 🎯 Choose Your Path

### I want to understand the theory
👉 Start with [Comprehensive Ambisonics Knowledge Base](abisonics_knowledge_base.html)

Read sections:
1. Core Ambisonics Concepts
2. B-Format and Higher Order Ambisonics
3. Spatial Encoding & Decoding
4. Mathematical foundations

Then explore [Quick Reference](quick_refs.html) for formulas.

---

### I want to build patches
👉 Start with [Practical Implementation Guide](practical_implementation_guide_ambisonics.html)

Follow these workflows:
1. Basic Point Source Spatialization
2. Granular Diffuse Field Synthesis
3. Multi-Source Composition
4. Dynamic Spatial Effects

Keep [Quick Reference](quick_refs.html) open for parameter values.

---

### I want to create granular textures
👉 Start with [Spatial Granular Synthesis Guide](spacial_granular_synthesis.html)

Learn:
1. Granular Synthesis Principles
2. Per-Harmonic vs Grain Swarm (choose your approach)
3. HOA Library Approach (hoa.plug~ + hoa.grain~)
4. Creative Techniques

Then check [Practical Implementation](practical_implementation_guide_ambisonics.html) for integration.

---

### I want to develop C++ extensions
👉 Combine knowledge base with developer docs:

1. [Spatial Granular Synthesis - GrainflowLib](spacial_granular_synthesis.html#grainflowlib-architecture) (C++ architecture)
2. [C++ Quick Refresher](../CPP_REFRESHER.html) (language review)
3. [API Reference](../API_REFERENCE.html) (HOA classes)
4. [Architecture Guide](../ARCHITECTURE.html) (system design)

---

## 📖 Topic Index

### Ambisonics Theory
- [Core Concepts](abisonics_knowledge_base.html#core-ambisonics-concepts)
- [B-Format](abisonics_knowledge_base.html#b-format-and-higher-order-ambisonics)
- [Channel Count Formulas](quick_refs.html#essential-formulas)
- [Angular Resolution](quick_refs.html#angular-resolution-by-order)

### Encoding & Decoding
- [Encoding Strategies](abisonics_knowledge_base.html#spatial-encoding--decoding)
- [Decoder Types](practical_implementation_guide_ambisonics.html#decoder-configuration)
- [Binaural Rendering](practical_implementation_guide_ambisonics.html#workflow-7-binaural-rendering-for-headphones)
- [Speaker Arrays](practical_implementation_guide_ambisonics.html#speaker-array-considerations)

### Spatial Effects
- [Width Control](practical_implementation_guide_ambisonics.html#workflow-5-spatial-width-control)
- [Rotation](practical_implementation_guide_ambisonics.html#workflow-4-field-rotation-and-listener-orientation)
- [Distance Simulation](abisonics_knowledge_base.html#distance-encoding)
- [Diffusion](practical_implementation_guide_ambisonics.html#workflow-2-granular-diffuse-field-synthesis)

### Granular Synthesis
- [Granular Principles](spacial_granular_synthesis.html#granular-synthesis-principles)
- [Per-Harmonic Granulation](spacial_granular_synthesis.html#paradigm-1-per-harmonic-granulation)
- [Grain Swarm](spacial_granular_synthesis.html#paradigm-2-grain-swarm)
- [HOA Library Approach](spacial_granular_synthesis.html#hoa-library-approach)
- [Granular Parameters](quick_refs.html#granular-synthesis-parameters)

### Advanced Topics
- [Plane Wave Decomposition](abisonics_knowledge_base.html#plane-wave-decomposition)
- [Multi-Source Composition](practical_implementation_guide_ambisonics.html#workflow-8-multi-source-composition)
- [Processing Suite Patterns](practical_implementation_guide_ambisonics.html#workflow-6-using-hoaprocess-for-effects)
- [Custom C++ Implementation](spacial_granular_synthesis.html#cpp-implementation-strategies)

---

## 🔗 Related Documentation

### For Users
- [Getting Started](../getting-started.html) - First steps
- [Tutorials](../tutorials.html) - Step-by-step guides
- [Examples](../examples.html) - Ready-to-use patches
- [Object Reference](../OBJECTS.html) - All Max objects

### For Developers
- [C++ Quick Refresher](../CPP_REFRESHER.html) - Language review
- [API Reference](../API_REFERENCE.html) - Complete API
- [Architecture](../ARCHITECTURE.html) - System design
- [Technical Audit](../TECHNICAL_AUDIT.html) - Code analysis
- [Optimization Guide](../OPTIMIZATION_GUIDE.html) - Performance

---

## 💡 Quick Tips

### Understanding Channel Count
```
2D: 2N + 1 channels
3D: (N+1)² channels

Order 3 (2D) = 7 channels
Order 7 (2D) = 15 channels
Order 3 (3D) = 16 channels
```

### Common Ambisonic Orders
- **Order 1**: Testing and basic work
- **Order 3**: Music production standard
- **Order 7**: High-end installations
- **Order 35**: Research and specialized applications

### Granular Grain Sizes
```
5-20ms:   Dense, buzzy textures
20-50ms:  Standard musical grains
50-100ms: Sparse, cloud-like
```

### When to Use Per-Harmonic vs Grain Swarm
- **Per-Harmonic**: Enveloping atmospheres, fewer grains, easier
- **Grain Swarm**: Precise positioning, complex trajectories, more control

---

## 📚 Suggested Reading Order

### For Complete Beginners
1. [Quick Reference - What is Ambisonics?](quick_refs.html#what-is-ambisonics)
2. [Knowledge Base - Core Concepts](abisonics_knowledge_base.html#core-ambisonics-concepts)
3. [Practical Guide - Basic Point Source](practical_implementation_guide_ambisonics.html#workflow-1-basic-point-source-spatialization)
4. [Getting Started](../getting-started.html)

### For Max Users
1. [Practical Implementation Guide](practical_implementation_guide_ambisonics.html) (full read)
2. [Quick Reference](quick_refs.html) (bookmark it)
3. [Knowledge Base - HOA Library](abisonics_knowledge_base.html#hoa-library-architecture)
4. [Object Reference](../OBJECTS.html)

### For Composers
1. [Practical Guide - Multi-Source](practical_implementation_guide_ambisonics.html#workflow-8-multi-source-composition)
2. [Granular Synthesis Guide](spacial_granular_synthesis.html) (creative sections)
3. [Knowledge Base - Advanced Techniques](abisonics_knowledge_base.html#advanced-techniques)
4. [Examples](../examples.html)

### For Developers
1. [Knowledge Base - HOA Architecture](abisonics_knowledge_base.html#hoa-library-architecture)
2. [Granular Synthesis - C++ Implementation](spacial_granular_synthesis.html#cpp-implementation-strategies)
3. [C++ Refresher](../CPP_REFRESHER.html)
4. [API Reference](../API_REFERENCE.html)
5. [Architecture Guide](../ARCHITECTURE.html)

---

## 🎓 Learning Resources

### Academic Papers
See [References](../references.html#publications) for:
- Original ambisonic papers
- Spatial granular synthesis research
- HRTF and binaural rendering
- Psychoacoustic studies

### External Tools & Libraries
- **Grainflow**: [github.com/composingcap/grainflow](https://github.com/composingcap/grainflow)
- **IEM Plugin Suite**: Ambisonic production tools
- **SuperCollider**: SC-HOA and ATK libraries
- **FAUST**: Ambitools implementation

### Video Tutorials
Check [Tutorials](../tutorials.html) for links to:
- Video walkthroughs
- Workshop recordings
- Conference presentations

---

<div class="back-nav">
  <a href="../index.html">← Back to Main Documentation</a>
</div>

<style>
.back-nav {
  margin: 3rem 0;
  padding: 1rem 0;
  border-top: 2px solid #eee;
}

.back-nav a {
  font-size: 1.1rem;
  color: #0066cc;
  text-decoration: none;
}

.back-nav a:hover {
  text-decoration: underline;
}
</style>
