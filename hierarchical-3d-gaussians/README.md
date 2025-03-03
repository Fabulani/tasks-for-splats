# Hierarchical 3D Gaussians -- with Docker

> [!NOTE] Clone with --recursive!

```sh
git clone https://github.com/Fabulani/hierarchical-3d-gaussians.git --recursive
cd hierarchical-3d-gaussians
```

> [!WARNING] You must be logged in to Github Container Registry. Otherwise, build the image from scratch.

---

Pull image from the Github Container Registry:

```sh
docker pull ghcr.io/fabulani/hierarchical-3d-gaussians:latest
```

Start the container. **NOTE:** make sure that, inside `docker-compose.yml`, the `build` field is commented out and `image` is not.

```bash
docker compose up -d
docker exec -it hierarchical-3d-gaussians bash
```

The dataset folder must be in the `/data` folder. Set your dataset directory with:

```bash
export DATASET_DIR=/host/data/<dataset-name>
```

If you don't have the COLMAP export, images must be stored like so: `${DATASET_DIR}/inputs/images/cam1`.

If you have a COLMAP export already (`sparse` folder with `.bin` files), put it in the `${DATASET_DIR}/camera_calibration/rectified` folder.

Your project folder should look like this:

```txt
${DATASET_DIR}
│   # If you don't have a COLMAP export
└── inputs
│   └── images
│       └── cam1
│           └── your_images.jpg/png/...
│
│   # If you have a COLMAP export
└── camera_calibration
    └── rectified
        └── sparse
        │   ├── images.bin
        │   ├── cameras.bin
        │   └── points3D.bin
        └── images
```

From now on, you have a few options: execute one of the scripts with the entire workflow, or do it manually.

- No COLMAP export workflow: `./run_all.sh`.
- With COLMAP export ready: `./run_skip_colmap.sh`.
- Execute manually step-by-step: follow the rest of the README.

## Preprocessing

Summarised from [Preprocessing](#preprocessing).

If **COLMAP**, put cameras, images, and points3d in `${DATASET_DIR}/camera_calibration/rectified`, then run

```bash
python preprocess/auto_reorient.py --input_path ${DATASET_DIR}/camera_calibration/rectified/sparse --output_path ${DATASET_DIR}/camera_calibration/aligned/sparse/0
```

Otherwise, if **NO COLMAP**:

```bash
python preprocess/generate_colmap.py --project_dir ${DATASET_DIR}
```

Generate chunks:

```bash
python preprocess/generate_chunks.py --project_dir ${DATASET_DIR}
```

Generate monocular depth maps:

```bash
python preprocess/generate_depth.py --project_dir ${DATASET_DIR}
```

## Optimization

Summarized from [Optimization](#optimization).

Train a hierarchy with

```bash
python scripts/full_train.py --project_dir ${DATASET_DIR}
```

## Real-time viewer

Summarized from [Real-time viewer](#real-time-viewer).

Run the viewer. Default expected VRAM is 16 GB, which can be changed with the flag `--budget <in MB>`. This defines the scene representation budget. There will be an extra 1.5 GB VRAM for framebuffer structs.

```bash
SIBR_viewers/install/bin/SIBR_gaussianHierarchyViewer_app --path ${DATASET_DIR}/camera_calibration/aligned --scaffold ${DATASET_DIR}/output/scaffold/point_cloud/iteration_30000 --model-path ${DATASET_DIR}/output/merged.hier --images-path ${DATASET_DIR}/camera_calibration/rectified/images
```
