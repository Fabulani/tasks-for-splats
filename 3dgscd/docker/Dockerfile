FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel

# Set environment variables.
## Set non-interactive to prevent asking for user inputs blocking image creation.
ENV DEBIAN_FRONTEND=noninteractive
## Set timezone as it is required by some packages.
ENV TZ=Europe/Berlin
## CUDA Home, required to find CUDA in some packages.
ENV CUDA_HOME="/usr/local/cuda"

# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}
ARG TCNN_CUDA_ARCHITECTURES=75
ENV TCNN_CUDA_ARCHITECTURES=${TCNN_CUDA_ARCHITECTURES}
ARG COMMIT_ID="5ca3726"
ENV COMMIT_ID=${COMMIT_ID}

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    ninja-build \
    cmake \
    unzip \
    # 3dgscd requirements
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

RUN pip install --upgrade pip setuptools && \
    pip install --no-cache-dir ninja git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch

# HLOC
RUN pip install git+https://github.com/cvg/Hierarchical-Localization.git@73a3cb0f59659306eb6c15c7213137b2196c5ceb

# Downgrade pycolmap to 0.4.0
RUN pip install pycolmap==0.4.0

# Lightglue
RUN pip install git+https://github.com/cvg/LightGlue@035612541779b17897aa06d6ff19cb4060111616

# EfficientSAM
RUN pip install git+https://github.com/yformer/EfficientSAM.git@c9408a74b1db85e7831977c66e9462c6f4891729

# Download model weights
ARG TORCH_HUB=/root/.cache/torch/hub/checkpoints
RUN mkdir -p ${TORCH_HUB} && \
    wget -O ${TORCH_HUB}/superpoint_v1.pth \
    https://github.com/cvg/LightGlue/releases/download/v0.1_arxiv/superpoint_v1.pth && \
    wget -O ${TORCH_HUB}/superpoint_lightglue_v0-1_arxiv.pth \
    https://github.com/cvg/LightGlue/releases/download/v0.1_arxiv/superpoint_lightglue.pth && \
    wget -O ${TORCH_HUB}/alexnet-owt-7be5be79.pth \
    https://download.pytorch.org/models/alexnet-owt-7be5be79.pth

# 3DGS-CD
RUN git clone https://github.com/520xyxyzq/3DGS-CD.git 3dgscd && \
    cd 3dgscd && \
    git checkout ${COMMIT_ID} && \
    pip install -e .

WORKDIR /workspace/3dgscd

# EfficientSAM weights
RUN mkdir -p weights && \
    wget -O weights/efficient_sam_vits.pt.zip https://github.com/yformer/EfficientSAM/raw/main/weights/efficient_sam_vits.pt.zip && \
    unzip weights/efficient_sam_vits.pt.zip -d weights && \
    rm weights/efficient_sam_vits.pt.zip
