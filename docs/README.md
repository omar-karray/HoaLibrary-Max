# HoaLibrary Documentation

**Version**: 3.0  
**Last Updated**: November 14, 2025  
**Website**: https://omar-karray.github.io/HoaLibrary-Max/

---

## 📁 Documentation Structure

```
docs/
├── README.md                    # This file
├── index.md                     # Homepage
├── _config.yml                  # Jekyll configuration
├── _layouts/                    # Site templates
│   └── default.html
│
├── api/                         # API Reference
│   └── API_REFERENCE.md         # Complete API documentation
│
├── theory/                      # Theoretical Foundations
│   └── what-is-hoa.md          # Introduction to HOA
│
├── guides/                      # How-To Guides
│   ├── CPP_REFRESHER.md        # C++ quick reference
│   ├── getting-started.md      # Quick start guide
│   ├── tutorials.md            # Step-by-step tutorials
│   └── examples.md             # Practical examples
│
├── reference/                   # Technical Reference
│   ├── ARCHITECTURE.md         # System architecture
│   ├── TECHNICAL_AUDIT.md      # Code analysis
│   ├── OPTIMIZATION_GUIDE.md   # Performance tuning
│   └── CODE_AUDIT_SUMMARY.md   # Executive summary
│
├── knowledge_base/              # Advanced Topics
│   ├── index.md
│   ├── abisonics_knowledge_base.md
│   ├── practical_implementation_guide_ambisonics.md
│   ├── spacial_granular_synthesis.md
│   └── quick_refs.md
│
├── assets/                      # Static Assets
│   ├── css/
│   │   └── style.scss
│   └── images/
│
└── legacy/                      # Build & Release Info
    ├── BUILD_STATUS.md
    ├── PROJECT_ANALYSIS.md
    ├── RELEASE_SUMMARY.md
    ├── RELEASE_STRATEGY.md
    ├── INSTALLATION.md
    └── CREDITS_AND_LICENSING.md
```

---

## 🎯 Documentation Types

### For Users

**Getting Started** → `guides/getting-started.md`
- Installation
- First steps
- Basic concepts

**Theory** → `theory/what-is-hoa.md`
- What is Higher Order Ambisonics?
- Mathematical foundations
- Practical guidelines

**Tutorials** → `guides/tutorials.md`
- Interactive learning
- Step-by-step examples

**Objects Reference** → `OBJECTS.md`
- All Max objects documented
- Quick reference

### For Developers

**API Reference** → `api/API_REFERENCE.md`
- Complete API documentation
- Every class, method, parameter
- Code examples

**C++ Guide** → `guides/CPP_REFRESHER.md`
- C++ quick refresher
- HoaLibrary patterns
- Coming from PHP/Laravel

**Architecture** → `reference/ARCHITECTURE.md`
- System design
- Class hierarchy
- Data flow
- Mermaid diagrams

**Technical Audit** → `reference/TECHNICAL_AUDIT.md`
- Code analysis
- Performance characteristics
- DSP implementation details

**Optimization** → `reference/OPTIMIZATION_GUIDE.md`
- Performance tuning
- SIMD vectorization
- Benchmarks

### Advanced Topics

**Knowledge Base** → `knowledge_base/`
- Spatial granular synthesis
- Advanced techniques
- Research papers
- Implementation guides

---

## 🚀 Quick Links

### Learning Path

1. **Start Here**: [What is HOA?](theory/what-is-hoa.md)
2. **Install**: [Getting Started](guides/getting-started.md)
3. **Learn**: [Tutorials](guides/tutorials.md)
4. **Reference**: [API Documentation](api/API_REFERENCE.md)
5. **Deep Dive**: [Knowledge Base](knowledge_base/)

### Developer Path

1. **C++ Basics**: [C++ Refresher](guides/CPP_REFRESHER.md)
2. **Architecture**: [System Design](reference/ARCHITECTURE.md)
3. **API**: [Complete Reference](api/API_REFERENCE.md)
4. **Optimization**: [Performance Guide](reference/OPTIMIZATION_GUIDE.md)
5. **Audit**: [Technical Analysis](reference/TECHNICAL_AUDIT.md)

---

## 📝 Contributing to Documentation

### File Naming Conventions

- Use `kebab-case.md` for new files
- Existing `UPPERCASE.md` maintained for continuity
- Keep filenames descriptive and concise

### Folder Organization

```
api/          → API reference and technical specs
theory/       → Conceptual and mathematical foundations
guides/       → How-to guides and tutorials
reference/    → Technical reference and architecture
knowledge_base/ → Advanced research and techniques
assets/       → CSS, images, and other static files
```

### Markdown Standards

- Use proper heading hierarchy (h1 → h2 → h3)
- Include table of contents for long documents
- Use code blocks with language specification
- Add Mermaid diagrams where helpful
- Cross-reference related documents

### Adding New Content

1. Choose appropriate folder based on content type
2. Create file with descriptive name
3. Add front matter if needed
4. Update `index.md` navigation
5. Cross-reference from related pages
6. Test locally with Jekyll

---

## 🔧 Local Development

### Prerequisites

```bash
# Install Ruby and Jekyll
gem install bundler jekyll

# Install dependencies
bundle install
```

### Running Locally

```bash
# Serve documentation site
cd docs
bundle exec jekyll serve

# View at http://localhost:4000
```

### Building for Production

```bash
bundle exec jekyll build
# Output in _site/
```

---

## 📊 Documentation Metrics

| Section | Files | Status |
|---------|-------|--------|
| API Reference | 1 | ✅ Complete |
| Theory | 1 | ✅ Complete |
| Guides | 4 | ✅ Complete |
| Technical Reference | 4 | ✅ Complete |
| Knowledge Base | 5 | ✅ Complete |
| **Total** | **15** | **✅ Complete** |

---

## 🎨 Style Guide

### Formatting

- **Bold** for emphasis and UI elements
- *Italic* for technical terms on first use
- `Code` for code, filenames, and commands
- > Blockquotes for important notes

### Code Examples

```cpp
// Always include language identifier
// Add comments explaining key concepts
// Keep examples focused and minimal
```

### Diagrams

Use Mermaid for:
- Architecture diagrams
- Flow charts
- Class hierarchies
- Sequence diagrams

---

## 🔗 External Resources

- **GitHub Repository**: https://github.com/omar-karray/HoaLibrary-Max
- **CICM Website**: http://cicm.mshparisnord.org/
- **Max/MSP**: https://cycling74.com/products/max

---

## 📮 Support

- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Email**: Contact CICM for research inquiries

---

**Maintained by**: Omar Karray  
**Original Authors**: CICM Team (Guillot, Paris, Colafrancesco, Le Meur)  
**License**: GNU GPL v3
