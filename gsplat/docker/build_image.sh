#!/usr/bin/env bash
# CUDA Arch to build for (currently not used). Find yours here: https://developer.nvidia.com/cuda-gpus. E.g., `"7.5"`.
# export TORCH_CUDA_ARCH_LIST="7.5"
export REPO_PATH="../repo"
export GSPLAT_VERSION=`cat ${REPO_PATH}/gsplat/version.py | cut -d '"' -f 2`
export TAG_BASE="ghcr.io/fabulani/nerfstudio-gsplat-base:${GSPLAT_VERSION}"
export TAG_WORKER="ghcr.io/fabulani/nerfstudio-gsplat-worker:${GSPLAT_VERSION}"

echo "build gsplat base image"
docker build \
    -t "${TAG_BASE}" \
    -f ./gsplat_base.dockerfile ${REPO_PATH}

echo "build gsplat and dependencies wheel"
# Create a container to build wheels since only the container can use CUDA
# Note: fused-ssim is a dependency of gsplat/examples that also requires cuda compilation. Its wheels are compiled and then moved to /gsplat/dist for easy installation in the next step.
docker run -t --rm --name nerfstudio-gsplat-wheel \
    --gpus 1 \
    -v ${REPO_PATH}:/gsplat \
    "${TAG_BASE}" \
    bash -c "cd /gsplat && python3 setup.py sdist bdist_wheel && cd /fused-ssim && python3 setup.py sdist bdist_wheel && mv /fused-ssim/dist/* /gsplat/dist/"

echo "build gsplat worker image"
docker build \
    --build-arg BASE_IMAGE="${TAG_BASE}" \
    --build-arg GSPLAT_VERSION="${GSPLAT_VERSION}" \
    -t "${TAG_WORKER}" \
    -f ./gsplat_worker.dockerfile ${REPO_PATH}