# 3DGS-CD: 3D Gaussian Splatting-based Change Detection for Physical Object Rearrangement

Website: [3DGS-CD](https://github.com/520xyxyzq/3DGS-CD/tree/main)

From their page:

> We estimate 3D object-level changes from two sets of unaligned RGB images using 3D Gaussian Splatting as the scene representation, enabling accurate recovery of shapes and pose changes of rearranged objects in cluttered environments within tens of seconds using sparse (as few as one) new images.

## Dataset

Each scene must be organized as follows:

```txt
scene_name
  - rgb: pre-change images
  - rgb_new: post-change images
```

Example datasets from the authors can be downloaded [here](https://drive.google.com/drive/folders/1OPUu643bkbAoryASNMi8_iDJGnypotc0?usp=drive_link). These have been pre-processed: downscaled and undistorted.

## Usage

For the example datasets from the authors, the following command is enough:

```sh
python nerfstudio/scripts/change_det.py \
  --config <data_folder>/<scene_name>/config.yml \
  --transform <data_folder>/<scene_name>/transforms.json \
  --output <data_folder>/<scene_name> \
  --ckpt <data_folder>/<scene_name>/nerfstudio_models/
```

For custom datasets, there are only two steps:

1. Data Processing
2. Running the method

### Data Processing

Run the following:

```sh
./scripts/process_iphone_data.sh <data_folder/scene_name> <num_downscales> ${NERFSTUDIO_FOLDER}
```

where:

- `<data_folder/<scene_name>`: path to your scene.
- `<num_downscales>`: how much to downscale images. Change this to a number, e.g. `2`.
- `${NERFSTUDIO_FOLDER}`: path to the nerfstudio folder. Already set.

### Running the method

> [!WARNING]
> Not tested! This section is likely to not work with the current image, as it seems to require a conda environment along with COLMAP and nerfstudio.

Run the following:

```sh
./scripts/real_gsplat_train.sh <DATA_FOLDER> -0 <TRAIN_IDX> <OUTPUT_FOLDER> ${NERFSTUDIO_FOLDER} /workspace/3dgscd/scripts/merge_colmap_data.py /workspace/3dgscd/scripts/edit_nerf_data.py /workspace/3dgscd/scripts/undistort_transforms.py
```

where:

- <DATA_FOLDER>: path to dataset folder.
- <TRAIN_IDX>: indices of sparse images used for training, e.g. "0 2 4 6".
- <OUTPUT_FOLDER>: path to output folder, e.g. "/workspace/3dgscd/data/output"

---

For further details, see the [3DGS-CD README](https://github.com/520xyxyzq/3DGS-CD/tree/main?tab=readme-ov-file#instructions).
