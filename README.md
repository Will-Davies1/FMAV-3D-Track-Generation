# FMAV Wing Mechanism

MATLAB code for the development and geometric analysis of a passive wing twist mechanism for a flapping-wing micro air vehicle (FMAV).

The project generates the three-dimensional mechanism track from the wing flapping motion, maps the required wing twist angle, and develops inner and outer offset curves for the track geometry. MATLAB-generated geometry is also compared against reference curves exported from Onshape.

## Repository Structure

```text
FMAV-Wing-Mechanism/
│
├── data/
│   ├── normal_stroke.xlsx
│   └── track.xlsx
│
├── src/
│   ├── generate_flapping_input.m
│   ├── map_theta.m
│   ├── generate_track.m
│   ├── generate_inner_offsets.m
│   └── generate_outer_offsets.m
│
├── plotting/
│   ├── plot_flapping_comparison.m
│   ├── plot_theta_mapping.m
│   ├── plot_track_comparison.m
│   └── plot_all_offsets.m
│
├── main.m
└── README.md
```

## Running the Code

1. Clone or download the repository.
2. Open MATLAB and navigate to the project directory.
3. Run `main.m`.

The main script automatically adds the `src/` and `plotting/` directories to the MATLAB path and executes each stage of the workflow in sequence.

## Workflow

The code is divided into five main stages:

### 1. Flapping Input Generation

`generate_flapping_input.m`

Generates the wing flapping motion using the linkage geometry and compares the resulting motion against the reference sampling exported from Onshape.

### 2. Wing Twist Mapping

`map_theta.m`

Maps the linear wing twist angle relationship onto the nonlinear flapping motion.

### 3. Three-Dimensional Track Generation

`generate_track.m`

Combines the wing flapping motion and twist mapping to generate the three-dimensional track geometry. The resulting track is compared against the rough track sampling exported from Onshape.

### 4. Inner Offset Generation

`generate_inner_offsets.m`

Calculates the inner offset curves at two specified distances from the original track. Points that are too close to the original track are removed to simulate how the original 2D track was constructed graphically.

### 5. Outer Offset Generation

`generate_outer_offsets.m`

Calculates the corresponding outer offset curves. Additional intersection calculations are used to join the curves at the track corners, simulating how the original 2D track was constructed graphically.

## Plotting

The `plotting/` directory contains separate functions for visualising the generated geometry:

- `plot_flapping_comparison.m` – compares MATLAB and Onshape flapping motion.
- `plot_theta_mapping.m` – displays the linear and nonlinear twist mappings.
- `plot_track_comparison.m` – compares MATLAB and Onshape track geometry.
- `plot_all_offsets.m` – displays the complete track geometry, including inner and outer offsets and their upper surfaces.

All plots are generated automatically when `main.m` is executed.

## Output

The main script generates the following MATLAB structures:

| Variable | Description |
|---|---|
| `flap` | Wing flapping motion and reference sampling |
| `theta` | Linear and nonlinear wing twist mapping |
| `track` | Generated 3D track and Onshape reference geometry |
| `inner` | Inner offset curves |
| `offset_geometry` | Track gradients, pin axes and offset directions |
| `outer` | Outer offset curves and corner intersections |

