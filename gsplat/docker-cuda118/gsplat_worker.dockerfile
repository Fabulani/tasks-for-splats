FROM pytorch/pytorch:2.4.0-cuda11.8-cudnn9-devel

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

# Download AlexNet checkpoint
RUN mkdir -p /root/.cache/torch/hub/checkpoints && \
    wget -O /root/.cache/torch/hub/checkpoints/alexnet-owt-7be5be79.pth \
    https://download.pytorch.org/models/alexnet-owt-7be5be79.pth

WORKDIR /workspace

# gsplat
RUN git clone https://github.com/nerfstudio-project/gsplat.git --recursive && \
    cd gsplat && \
    git checkout 2043ddc

WORKDIR /workspace/gsplat

COPY dist/gsplat*.whl .
COPY dist/fused_ssim*.whl .
COPY requirements.txt examples/requirements.txt

# Install Python wheels and gsplat examples requirements
RUN pip install --no-cache-dir gsplat*.whl && \
    pip install --no-cache-dir fused_ssim*.whl && \
    rm gsplat*.whl && rm fused_ssim*.whl && \
    pip install --no-cache-dir -r examples/requirements.txt
