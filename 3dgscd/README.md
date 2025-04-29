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

## Usage

There are only two steps:

1. Data Processing
2. Running the method

### Data Processing

Run the following:

```sh
./scripts/process_iphone_data.sh data/<scene_name> <num_downscales> ${NERFSTUDIO_FOLDER}
```

where:

- `data/<scene_name>`: path to your scene. Change `<scene_name>`.
- `<num_downscales>`: how much to downscale images. Change this to a number, e.g. `2`.
- `${NERFSTUDIO_FOLDER}`: path to the nerfstudio folder. Already set.

### Running the method

Run the following:

```sh
./scripts/real_gsplat_train.sh
```

---

For further details, see the [3DGS-CD README](https://github.com/520xyxyzq/3DGS-CD/tree/main?tab=readme-ov-file#instructions).
