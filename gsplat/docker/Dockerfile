FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-devel

ENV TORCH_CUDA_ARCH_LIST="7.5+PTX"

# Required for install of packages from examples/requirements.txt.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    # Required for running simple_trainer.py
    libgl1 \
    libglib2.0-0 \
    # Other requirements
    libglm-dev \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

#! CUDA_HOME????

# Download AlexNet checkpoint
RUN mkdir -p /root/.cache/torch/hub/checkpoints && \
    wget -O /root/.cache/torch/hub/checkpoints/alexnet-owt-7be5be79.pth \
    https://download.pytorch.org/models/alexnet-owt-7be5be79.pth

WORKDIR /workspace
WORKDIR /workspace/get
WORKDIR /workspace
# Clone, install, and compile gsplat and its CUDA scripts
ARG GSPLAT_COMMIT_ID=2043ddc
RUN git clone https://github.com/nerfstudio-project/gsplat.git --recursive && \
    cd gsplat && \
    git checkout ${GSPLAT_COMMIT_ID} && \
    pip install --no-cache-dir git+https://github.com/nerfstudio-project/gsplat.git@${GSPLAT_COMMIT_ID}

# Install fused-ssim
RUN pip install --no-cache-dir git+https://github.com/rahul-goel/fused-ssim@1272e21a282342e89537159e4bad508b19b34157

WORKDIR /workspace/gsplat

# Custom requirements file fixes issues with some libraries
COPY requirements.txt examples/requirements.txt

# Install gsplat examples requirements
RUN pip install --no-cache-dir -r examples/requirements.txt
