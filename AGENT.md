# AGENT.md for py-soundmining-tools

This document provides a machine-readable guide for AI agents to understand and interact with the `py-soundmining-tools` repository.

## Project Description

`py-soundmining-tools` is a Python library designed for audio analysis, feature extraction, and sound data mining. It provides a collection of tools to process audio files, extract meaningful acoustic features, and prepare data for machine learning tasks or further analysis.

## Technologies and Dependencies

-   **Primary Language:** Python (3.8+)
-   **Package Manager:** `pip`
-   **Core Libraries:**
    -   `numpy`: For numerical operations on audio data.
    -   `scipy`: For signal processing functionalities.
    -   `librosa`: For advanced audio and music analysis.
    -   `pandas`: For organizing extracted features into data frames.
    -   `python-osc`: For communicating with the SuperCollider synthesis server.
-   **Testing Framework:** `pytest`

## Setup and Installation

Execute the following commands in a shell to set up the development environment.

```bash
# 1. Clone the repository
git clone https://github.com/danielstahl/py-soundmining-tools.git
cd py-soundmining-tools

# 2. Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 3. Install dependencies
pip install -r requirements.txt
```

## Project Structure

The repository is organized as follows:

```
py-soundmining-tools/
├── .venv/                  # Virtual environment
├── soundmining/            # Main source code package
│   ├── __init__.py
│   ├── features.py         # Feature extraction modules (e.g., MFCC, Chroma)
│   ├── io.py               # Audio file loading and saving
│   └── processing.py       # Pre-processing functions (e.g., normalization)
├── supercollider/          # SuperCollider synth definitions (.scd files)
│   ├── instruments-v2.scd  # Advanced instrument definitions
│   └── synths.scd          # Basic synth definitions
├── tests/                  # Unit and integration tests
│   ├── test_features.py
│   └── test_io.py
├── examples/               # Usage examples and notebooks
│   ├── extract_features.py
│   └── instruments_v2.py   # Python client for SuperCollider instruments
├── .gitignore
├── AGENT.md                # This file
├── README.md
└── requirements.txt        # Project dependencies
```

## Running Tests

To verify the integrity of the codebase, run the test suite using `pytest`. The tests are located in the `tests/` directory and do not require any external network access.

```bash
# Ensure you are in the project root and the virtual environment is active
pytest
```

## Core Functionality & Usage

The primary goal of this library is to extract features from audio files. The core workflow involves loading an audio file and then applying one or more feature extraction functions.

## Python client for Supercollider SynthDefs

The Python classes in `src/soundmining_tools/modular_v2/instruments_v2.py` are clients for Supercollider `SynthDefs` defined in `sc/instruments-v2.scd`.

The `AudioInstrument` class is the base class for these Python clients. Each subclass of `AudioInstrument` corresponds to a specific `SynthDef`. The parameters of the Python classes' methods map to the arguments of the Supercollider `SynthDef`.

### Example: `MonoGrainBuf`

The `MonoGrainBuf` `SynthDef` in `sc/instruments-v2.scd` is defined as follows:

```supercollider
SynthDef(\monoGrainBuf, {
	arg dur = 1, soundbuf = 0, grainTriggerBus = 0, grainDurationBus = 0, grainRateBus = 0, grainPosBus = 0, out = 0;
	var grainTrigger, grainDuration, grainRate, grainPos, sig;
	Line.kr(dur:dur, doneAction:2);
	grainTrigger = In.ar(grainTriggerBus, 1);
	grainDuration = In.ar(grainDurationBus, 1);
	grainRate = In.kr(grainRateBus, 1);
	grainPos = In.kr(grainPosBus, 1);
	sig = GrainBuf.ar(
		numChannels: 1,
		trigger: grainTrigger,
		dur: grainDuration,
		sndbuf: soundbuf,
		rate: grainRate,
		pos: grainPos,
		interp: 2,
		pan: 0,
		envbufnum: -1);
	Out.ar(out, sig);
}).add.store('global', synthsDir);
```

The corresponding Python class `MonoGrainBuf` in `src/soundmining_tools/modular_v2/instruments_v2.py` is:

```python
class MonoGrainBuf(AudioInstrument):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("monoGrainBuf", 1, output_bus_allocator)

    def grain_buf(
        self,
        soundbuf: int,
        grain_trigger_bus: AudioInstrument,
        grain_duration_bus: AudioInstrument,
        grain_rate_bus: AudioInstrument,
        grain_pos_bus: AudioInstrument,
    ) -> Self:
        self.soundbuf = soundbuf
        self.grain_trigger_bus = grain_trigger_bus
        self.grain_duration_bus = grain_duration_bus
        self.grain_rate_bus = grain_rate_bus
        self.grain_pos_bus = grain_pos_bus
        return self
```

When an instance of the `MonoGrainBuf` class is created in Python and the `grain_buf` method is called, an OSC (Open Sound Control) message is sent to the Supercollider server. This message creates a new instance of the `monoGrainBuf` synth, using the provided parameters as arguments.

This allows for expressive musical composition in Python by leveraging Supercollider's powerful audio synthesis capabilities.