# For CUDA 11.8, use: pytorch/pytorch:2.6.0-cuda11.8-cudnn9-devel
FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-devel


# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}
ARG MAX_JOBS=10
ENV MAX_JOBS=${MAX_JOBS}

ARG COMMIT_ID="5b842f0"
ENV COMMIT_ID=${COMMIT_ID}

WORKDIR /workspace

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

# Download AlexNet checkpoint
RUN mkdir -p /root/.cache/torch/hub/checkpoints && \
    wget -O /root/.cache/torch/hub/checkpoints/alexnet-owt-7be5be79.pth \
    https://download.pytorch.org/models/alexnet-owt-7be5be79.pth

# Clone, install, and compile gsplat and its CUDA scripts
# Note: commit must be later than ae729d3 - this fixes a cuda compilation error!
RUN git clone https://github.com/nerfstudio-project/gsplat.git --recursive && \
    cd gsplat && \
    git checkout ${COMMIT_ID}
RUN pip install --no-cache-dir git+https://github.com/nerfstudio-project/gsplat.git@${COMMIT_ID}

WORKDIR /workspace/gsplat

# Custom requirements file fixes issues with some libraries
COPY requirements.txt examples/requirements.txt

# Install gsplat examples requirements
RUN pip install --no-cache-dir -r examples/requirements.txt
