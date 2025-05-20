# Nerfstudio

Website: [Nerfstudio](https://docs.nerf.studio/index.html)

From their page:

> Nerfstudio provides a simple API that allows for a simplified end-to-end process of creating, training, and testing NeRFs. The library supports a more interpretable implementation of NeRFs by modularizing each component. With more modular NeRFs, we hope to create a more user-friendly experience in exploring the technology.

## Dataset

Nerfstudio supports a variety of input types that can be converted to the nerfstudio format. See [Using custom data](https://docs.nerf.studio/quickstart/custom_dataset.html) for instructions.

For quick reference, this is the general command:

```sh
ns-process-data {video,images,polycam,record3d,realitycapture} --data {DATA_PATH} --output-dir {PROCESSED_DATA_DIR}
```

where:

- `{video,images,polycam,record3d,realitycapture}` is the data type. Pick one.
- `--data {DATA_PATH}` is the path to the data. E.g., for images, should be inside `data/YOUR_DATASET_NAME/images` or similar.
- `--output-dir {PROCESSED_DATA_DIR}` is the output directory where the nerfstudio format dataset will be stored. This README assumes `data/nerfstudio/outputs/YOUR_DATASET_NAME` is used.

Other important parameters:

- `--num-downscales {int}`: how many times to downscale training images (default: 3), at multiples of 2. E.g., for 1, it'll downscale by 2; for 2, it'll downscale by 4x; and for 3, it'll downscale by 8x.

Run `ns-process-data --help` for a complete list of parameters.

> [!NOTE]
> Reality Capture has an export option for Nerfstudio transforms format. You can export the `transforms.json` and the sparse point cloud with name `sparse_pc.ply` for use with Nerfstudio, but it'll require manual editing of the image paths: RC writes the absolute path, but Nerfstudio uses relative.
>
> Each frame in `transforms.json` should have their `file_path` like so: `"file_path": "images/00000.png"`. Use Search and Replace All for a quick fix.
>
> A better options (that also seems to avoid [error with different image dimensions](https://github.com/nerfstudio-project/nerfstudio/issues/1852)) is to export camera poses as a `.csv` file using the `Internal/External camera parameters` option, alongside with the (sparse) Point Cloud `.ply`. Then, use
>
> `ns-process-data realitycapture --csv <csv_path> --data <images_folder or video> --output-dir <output_dir> --ply <ply_path>`.

## Usage

Nerfstudio has a collection of methods. In this container, the following methods are ready-to-use:

- Feature Splatting

Other methods can be easily added to the container by following their respective install instructions from the Nerfstudio documentation.

### Feature Splatting

From [Nerfstudio docs](https://docs.nerf.studio/nerfology/methods/feature_splatting.html):

> Feature splatting distills CLIP features into 3DGS by view-independent rasterization, which allows open-vocabulary 2D segmentation and open-vocabulary 3D segmentation of Gaussians directly in the 3D space. This implementation supports simple editing applications by directly manipulating Gaussians.

#### Train

Run training with:

```sh
ns-train feature-splatting --data {PROCESSED_DATA_DIR} --output-dir {OUTPUT_DIR} --max-num-iterations 30000
```

where:

- `--data {PROCESSED_DATA_DIR}`: path to the output from `ns-process-data`. If following README, `PROCESSED_DATA_DIR=data/nerfstudio/outputs/YOUR_DATASET_NAME`.
- `--output-dir {OUTPUT_DIR}`: path to the output directory for the feature splatting model. Recommended: `OUTPUT_DIR=data/nerfstudio/outputs`.
- `--max-num-iterations 30000`: number of iterations to train for (default: 30k).

Other useful parameters:

- `--pipeline.datamanager.images-on-gpu True`: may speed up processing at a higher gpu memory cost.
- `--save-only-latest-checkpoint`: default `True`, set to `False` to save checkpoints in intervals.
- `--steps-per-save`: interval for saving checkpoints.

Run `ns-train feature-splatting --help` to see all available parameters.

#### Viewer

Once training is finished, you can load the checkpoint for the viewer with:

```sh
ns-viewer --load-config {OUTPUT_DIR}/feature-splatting/{TIMESTAMP}/config.yml
```

Run `ns-viewer --helper` to see all available parameters

#### Export to PLY

Export the trained model to `.ply` with:

```sh
ns-export gaussian-splat --load-config {OUTPUT_DIR}/feature-splatting/{TIMESTAMP}/config.yml --output-dir {PLY_OUTPUT_DIR}
```

where:

- `--load-config`: path to the config YAML file.
- `--output-dir`: path to the output directory.

Use `--output-filename` to change the output file name (default: `splat.ply`).

---

For further details, see the [Nerfstudio Feature Splatting documentation](https://docs.nerf.studio/nerfology/methods/feature_splatting.html).
