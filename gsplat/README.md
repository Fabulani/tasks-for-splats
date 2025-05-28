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

---

For further details, see the [gsplat documentation](https://docs.gsplat.studio/main/).
