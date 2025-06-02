# gsplat

Website: [gsplat: An Open-Source Library for Gaussian Splatting](https://github.com/nerfstudio-project/gsplat)

From their page:

> gsplat is an open-source library for CUDA-accelerated differentiable rasterization of 3D gaussians with Python bindings. It is inspired by the SIGGRAPH paper “3D Gaussian Splatting for Real-Time Rendering of Radiance Fields”, but we’ve made gsplat even faster, more memory efficient, and with a growing list of new features!
>
> - (...) gsplat enables up to 4x less training memory footprint, and up to 15% less training time on Mip-NeRF 360 captures. (...)
> - gsplat is designed to support extremely large scene rendering, which is magnitudes faster than the official CUDA backend diff-gaussian-rasterization. (...)
> - gsplat offers (...) batch rasterization, N-D feature rendering, depth rendering, sparse gradient, multi-GPU distributed rasterization etc. (...)
> - gsplat is equipped with (...) absgrad, anti-aliasing, 3DGS-MCMC etc. And more to come!

## Dataset

Your dataset must be structured like so:

```txt
- dataset-name

-- images
--- img1.png
--- img2.png
--- ...

-- sparse
--- cameras.bin
--- images.bin
--- points3D.bin


- other-dataset ...
```

Alternativelly, you can use `examples/datasets/download_datasets.py` to download datasets:

```sh
apt-get update && apt-get install -y --no-install-recommends curl

python examples/datasets/download_datasets.py --dataset <mipnerf360, mipnerf360_extra, bilarf_data, zipnerf, zipnerf_undistorted> --save_dir data/dataset-name
```

## Usage

Train a Gaussian Splatting model with:

```sh
python3 examples/simple_trainer.py default \
--data-dir data/your-data-folder \
--data-factor 1 \
--result-dir data/results/some-output-folder
```

where:

- `--data-dir` is the path to the dataset you'd like to use. Specify the folder containing `images` and `sparse`.
- `--result-dir` is the path to the output folder, where gsplat will save checkpoints and other outputs. If you want results to be persistent, save them to the `data` folder, e.g., `data/results/<some-output-folder>`.
- `--data-factor` is the downscaling factor for images (default `4`).

Other useful arguments to include:

- `--max_steps`: number of training steps (default: `30000`).
- `--compression png`: use PNG compression strategy (default: `None`).
- `--camera-model {pinhole,ortho,fisheye}`: camera model to use (default: `pinhole`).
- `--save-steps`: steps to save the model (default: `7000 30000`).
- `--save-ply True`: save ply file.
- `--ply-steps`: steps to save the ply file (default: `7000 30000`).
- `--sh-degree`: degree of spherical harmonics (default: `3`).
- `--antialiased`: anti-aliasing in rasterization. Might slightly hurt quantitative metrics (default: `False`).
- `--use-bilateral-grid`: enable bilateral grid (default: `False`).
- `--use-fused-bilagrid`: enable fused bilateral grid (default: `False`). See [Fused Bilateral Grid](#fused-bilateral-grid).
- `--depth-loss`: enable depth loss (default: `False`).
- `--with-ut` and `with-eval3d`: 3DGUT (uncented transform + eval 3D) (`mcmc` strategy only!) (default: `False`). See [3DGUT](#3dgut).
- `--strategy.verbose`: print verbose information (default: `False`).
- `--strategy.cap-max`: maximum number of GSs (`mcmc` strategy only!) (default: `1_000_000`).

> [!NOTE]
>
> See all available arguments with `python examples/simple_trainer.py {default, mcmc} --help`.

Example using the `mcmc` strategy, 3DGUT, fused bilateral grid, PNG compression, and training to 7k steps:

```sh
python examples/simple_trainer.py mcmc --with-ut --with-eval3d --use-fused-bilagrid --compression png --data-dir data/360_v2/garden --data-factor 1 --result-dir data/gsplat/garden_1-3dgut-fused-bilagrid-png --max_steps 7000
```

### Viewer

Open the viewer with a previous checkpoint using:

```sh
python examples/simple_viewer.py --ckpt data/results/path-to-ckpt.pt --output_dir data/results/<some-output-folder>
```

The viewer is available on `localhost:8080`.

> [!IMPORTANT]
>
> 3DGUT models use different viewers. See [3DGUT](#3dgut).

### 3DGUT

> [!NOTE]
>
> Based on the [gsplat 3DGUT documentation](https://github.com/nerfstudio-project/gsplat/blob/0b4dddf04cb687367602c01196913cde6a743d70/docs/3dgut.md#features-3dgut).

For **3DGUT** (see [NVIDIA 3DGUT page](https://research.nvidia.com/labs/toronto-ai/3DGUT/)), add the flags `--with-ut --with-eval3d`:

```sh
python examples/simple_trainer.py mcmc \
--with-ut \
--with-eval3d \
<other arguments>
```

> [!IMPORTANT]
>
> Only the MCMC densification strategy is supported.

Two viewers are available:

1. Distortion effect supported viewer:

    ```sh
    python simple_viewer_3dgut.py --ckpt data/results/path-to-ckpt.pt 
    ```

2. Nerfstudio-style viewer:

    ```sh
    python simple_viewer.py --with_ut --with_eval3d --ckpt data/results/path-to-ckpt.pt --output_dir data/results/<some_output_folder>
    ```

`--ckpt` is the path to the checkpoint file generated from training, e.g., `data/results/benchmark_mcmc_1M_3dgut/garden/ckpt_29999_rank0.pt`.

### Fused Bilateral Grid

Fused Bilagrids were introduced in [PR#706](https://github.com/nerfstudio-project/gsplat/pull/706) and refer to the [Bilateral Guided Radiance Field Processing paper](https://bilarfpro.github.io/). They have been shown to improve visual quality of radiance fields significantly, especially in the presense of exposure changes during capture. Benchmarks have also shown that it is about 15% faster and consumes 20% less VRAM than the original Bilateral Grid used by gsplat.

To train with fused bilagrids, add the flag `--use-fused-bilagrid` to `simple_trainer.py`.

---

For further details, see the [gsplat documentation](https://docs.gsplat.studio/main/).
