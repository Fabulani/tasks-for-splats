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

Get the image ready by either:

1. Pulling it: `task pull`
2. Building it: `task build`

Run the container with `task run`.

Inside the container, train a Gaussian Splatting model with:

```sh
python3 examples/simple_trainer.py default \
--data_dir data/your-data-folder \
--data_factor 1 \
--result_dir data/results/some-output-folder
```

where:

- `--data_dir` is the path to the dataset you'd like to use. Specify the folder containing `images` and `sparse`.
- `--result_dir` is the path to the output folder, where gsplat will save checkpoints and other outputs. If you want results to be persistent, save them to the `data` folder, e.g., `data/results/<some-output-folder>`.
- `--data_factor` is the downscaling factor for images.

Adjust the maximum amount of training steps (default 30000) with `--max_steps`.

Open the viewer with a previous checkpoint using:

```sh
python simple_viewer.py --ckpt data/results/path-to-ckpt.pt
```

### 3DGUT

> [!NOTE]
>
> Based on the [gsplat 3DGUT documentation](https://github.com/nerfstudio-project/gsplat/blob/0b4dddf04cb687367602c01196913cde6a743d70/docs/3dgut.md#features-3dgut).

For **3DGUT** (see [NVIDIA 3DGUT page](https://research.nvidia.com/labs/toronto-ai/3DGUT/)), add the flags `--with_ut --with_eval3d`:

```sh
python examples/simple_trainer.py mcmc \
--with_ut \
--with_eval3d \
<other arguments>
```

> [!IMPORTANT]
>
> Only the MCMC densification strategy is supported.

Two viewers are available:

1. Distortion effect supported viewer:

    ```sh
    CUDA_VISIBLE_DEVICES=0 python simple_viewer_3dgut.py --ckpt data/results/path-to-ckpt.pt 
    ```

2. Nerfstudio-style viewer:

    ```sh
    CUDA_VISIBLE_DEVICES=0 python simple_viewer.py --with_ut --with_eval3d --ckpt data/results/path-to-ckpt.pt
    ```

`--ckpt` is the path to the checkpoint file generated from training, e.g., `data/results/benchmark_mcmc_1M_3dgut/garden/ckpt_29999_rank0.pt`

### Fused Bilateral Grid

Fused Bilagrids were introduced in [PR#706](https://github.com/nerfstudio-project/gsplat/pull/706) and refer to the [Bilateral Guided Radiance Field Processing paper](https://bilarfpro.github.io/). They have been shown to improve visual quality of radiance fields significantly, especially in the presense of exposure changes during capture. Benchmarks have also shown that it is about 15% faster and consumes 20% less VRAM than the original Bilateral Grid used by gsplat.

To train with fused bilagrids, add the flag `--use-fused-bilagrid` to `simple_trainer.py`.

---

For further details, see the [gsplat documentation](https://docs.gsplat.studio/main/).
