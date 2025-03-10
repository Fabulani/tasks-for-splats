# Hierarchical 3D Gaussians

Website: [A Hierarchical 3D Gaussian Representation for Real-Time Rendering of Very Large Datasets](https://repo-sam.inria.fr/fungraph/hierarchical-3d-gaussians/).

## Dataset

The container expects the environment variable `DATA_PATH` to contain the path to your datasets folder:

```txt
- <DATA_PATH>
-- dataset_1
-- dataset_2
-- ...
```

The dataset structure depends on whether you already have camera calibration (COLMAP output) or not. Follow one of the options:

```txt
dataset_1
│   # Option 1: If you don't already have camera intrinsics.
└── inputs
│   └── images
│       └── cam1
│           └── your_images.jpg/png/...
│
│   # Option 2: If you already have camera intrinsics.
└── camera_calibration
    └── rectified
        └── sparse
        │   ├── images.bin
        │   ├── cameras.bin
        │   └── points3D.bin
        └── images
           └── cam1
               └── your_images.jpg/png/...
```

## Usage

With Tasks:

- use `task hierarchical-3d-gaussians:pull` and `task hierarchical-3d-gaussians:run` to use Hierarchical 3D Gaussians locally.
- use `build`, `push` tasks to update the image on Github Container Registry.
- use `clone` only if the repository is needed for local testing.

The container is called `hierarchical-3d-gaussians`.

> [!WARNING] You must be logged in to Github Container Registry. Otherwise, build the image from scratch.

Once inside the container, you have 3 options:

1. _(for datasets without camera intrinsics)_ Run the full workflow: `./run_all.sh`
2. _(for datasets with camera intrinsics)_ Run the workflow, but skip COLMAP: `./run_skip_colmap.sh`
3. Execute manually step-by-step: see [Step-by-step](#step-by-step).

## Step-by-step

Step-by-step execution for Hierarchical 3D Gaussians, summarized from their Github readme.

> [!NOTE] dataset_dir is the directory of your target dataset.

### Preprocessing

If **COLMAP**, put cameras, images, and points3d in `<dataset_dir>/camera_calibration/rectified`, then run

```bash
python preprocess/auto_reorient.py --input_path <dataset_dir>/camera_calibration/rectified/sparse --output_path <dataset_dir>/camera_calibration/aligned/sparse/0
```

Otherwise, if **NO COLMAP**:

```bash
python preprocess/generate_colmap.py --project_dir <dataset_dir>
```

Generate chunks:

```bash
# H3DG doesn't create the dir sometimes, so do it
mkdir <dataset_dir>/camera_calibration/chunks

python preprocess/generate_chunks.py --project_dir <dataset_dir>
```

Generate monocular depth maps:

```bash
python preprocess/generate_depth.py --project_dir <dataset_dir>
```

### Optimization

Train a hierarchy with

```bash
python scripts/full_train.py --project_dir <dataset_dir>
```

### Real-time viewer

Run the viewer. Default expected VRAM is 16 GB, which can be changed with the flag `--budget <in MB>`. This defines the scene representation budget. There will be an extra 1.5 GB VRAM for framebuffer structs.

```bash
SIBR_viewers/install/bin/SIBR_gaussianHierarchyViewer_app --path <dataset_dir>/camera_calibration/aligned --scaffold <dataset_dir>/output/scaffold/point_cloud/iteration_30000 --model-path <dataset_dir>/output/merged.hier --images-path <dataset_dir>/camera_calibration/rectified/images
```
