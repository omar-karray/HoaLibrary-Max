# HoaLibrary Objects Reference

Complete list of all objects included in HoaLibrary v3.0 for Max 9.

## 2D Higher Order Ambisonics

### Encoding & Decoding

| Object | Description |
|--------|-------------|
| `hoa.2d.encoder~` | Encodes a signal in the circular harmonics domain (2D) |
| `hoa.2d.decoder~` | Decodes an ambisonic sound field for a circular array of loudspeakers (2D) |

### Processing

| Object | Description |
|--------|-------------|
| `hoa.2d.exchanger~` | Renumbers and normalizes the circular harmonics (2D) |
| `hoa.2d.map~` | Encodes several sources in the harmonics domain (2D) |
| `hoa.2d.optim~` | Optimizes the ambisonic sound field for a circular array of loudspeakers (2D) |
| `hoa.2d.projector~` | Projects a circular array of loudspeakers on an ambisonic sound field (2D) |
| `hoa.2d.recomposer~` | Recomposes a plane wave decomposition (2D) |
| `hoa.2d.rotate~` | Rotates a sound field in the circular harmonics domain (2D) |
| `hoa.2d.vector~` | Computes the velocity and energy vectors (2D) |
| `hoa.2d.wider~` | Increases the diffusion of a sound field (2D) |

### GUI Objects

| Object | Description |
|--------|-------------|
| `hoa.2d.meter~` | Circular array of meters for 2D ambisonic visualization |
| `hoa.2d.recomposer` | GUI for controlling plane wave decomposition (2D) |
| `hoa.2d.scope~` | Oscilloscope display for 2D ambisonic sound field |
| `hoa.2d.space` | GUI for controlling source positions in 2D space |

## 3D Higher Order Ambisonics

### Encoding & Decoding

| Object | Description |
|--------|-------------|
| `hoa.3d.encoder~` | Encodes a signal in the spherical harmonics domain (3D) |
| `hoa.3d.decoder~` | Decodes an ambisonic sound field for a spherical array of loudspeakers (3D) |

### Processing

| Object | Description |
|--------|-------------|
| `hoa.3d.exchanger~` | Renumbers and normalizes the spherical harmonics (3D) |
| `hoa.3d.map~` | Encodes several sources in the harmonics domain (3D) |
| `hoa.3d.optim~` | Optimizes the ambisonic sound field for a spherical array of loudspeakers (3D) |
| `hoa.3d.vector~` | Computes the velocity and energy vectors (3D) |
| `hoa.3d.wider~` | Increases the diffusion of a sound field (3D) |

### GUI Objects

| Object | Description |
|--------|-------------|
| `hoa.3d.meter~` | Spherical array of meters for 3D ambisonic visualization |
| `hoa.3d.scope~` | Oscilloscope display for 3D ambisonic sound field |

## Common Objects

### Signal Processing

| Object | Description |
|--------|-------------|
| `hoa.in~` | Defines ambisonic inputs for a `hoa.process~` patcher |
| `hoa.out~` | Defines ambisonic outputs for a `hoa.process~` patcher |
| `hoa.pi~` | Defines signal inlets for a `hoa.process~` patcher |
| `hoa.thisprocess~` | Retrieves information about `hoa.process~` context |
| `hoa.process~` | Manages ambisonic processing in a sub-patcher |

### Data Flow

| Object | Description |
|--------|-------------|
| `hoa.in` | Defines ambisonic inputs (data) for a `hoa.process~` patcher |
| `hoa.out` | Defines ambisonic outputs (data) for a `hoa.process~` patcher |
| `hoa.pi` | Defines data inlets for a `hoa.process~` patcher |

### Utilities

| Object | Description |
|--------|-------------|
| `hoa.connect` | Connects multiple channels automatically |
| `hoa.dac~` | Convenient multichannel DAC for ambisonic outputs |
| `hoa.gain~` | Multichannel gain control with GUI |
| `hoa.map` | GUI for controlling source positions (data version) |

### Effects (via hoa.process~)

| Object | Description |
|--------|-------------|
| `c.convolve~` | Convolution reverb/processor |
| `c.freeverb~` | Freeverb reverb algorithm |

## Effects Abstractions

These are located in `extras/` and used with `hoa.process~`:

### hoa.fx.* (Effects for hoa.process~)

- `hoa.fx.convolve~` - Convolution processing
- `hoa.fx.decorrelation~` - Decorrelates ambisonic channels
- `hoa.fx.delay~` - Multichannel delay
- `hoa.fx.dephaser~` - Phase effect
- `hoa.fx.freeverb~` - Reverb effect
- `hoa.fx.gain~` - Gain control
- `hoa.fx.grain~` - Granular synthesis
- `hoa.fx.mirror~` - Mirroring effect
- `hoa.fx.mixer~` - Channel mixer
- `hoa.fx.ringmod~` - Ring modulation

### hoa.syn.* (Synthesis for hoa.process~)

- `hoa.syn.decorrelation~` - Decorrelated synthesis
- `hoa.syn.delay~` - Delayed synthesis
- `hoa.syn.grain~` - Granular synthesis
- `hoa.syn.ringmod~` - Ring modulation synthesis

### Special Abstractions

- `hoa.receive~` - Multichannel receive
- `hoa.send~` - Multichannel send

## Object Categories

### 🎵 Audio Processing (~ objects)
37 externals for real-time ambisonic processing

### 🎨 GUI Objects
8 graphical objects for visualization and control

### 📊 Data Processing
Non-audio ambisonic calculations and routing

### 🎚️ Effects & Utilities
Abstractions for common ambisonic effects chains

## Learning Path

**Beginners**: Start with
1. `hoa.2d.encoder~` / `hoa.2d.decoder~`
2. `hoa.2d.rotate~`
3. `hoa.2d.scope~` for visualization

**Intermediate**: Explore
1. `hoa.2d.map~` for multiple sources
2. `hoa.2d.wider~` for diffusion
3. `hoa.process~` for effects

**Advanced**: Work with
1. 3D ambisonic objects
2. Custom `hoa.process~` patches
3. High ambisonic orders (5+)

## Technical Details

- **Total Externals**: 37 compiled objects
- **Compiled As**: Universal Binary (Intel + Apple Silicon)
- **Max Version**: 9.0 or higher
- **SDK Used**: Max SDK 8.2.0

---

For detailed documentation on each object, right-click the object in Max and select **"Open Help"**.

[← Back to README](../README.md) | [Installation Guide →](INSTALLATION.md)
