# Use Torch2.4.1+CUDA12.4, otherwise Poetry will downgrade due to repo requirements
FROM pytorch/pytorch:2.4.1-cuda12.4-cudnn9-devel


# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}
ARG COMMIT_ID="d52a6a5"
ENV COMMIT_ID=${COMMIT_ID}

# Inference requires SSL certificates. This fixes the path.
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    ninja-build \
    cmake \
    # SpatialLM dependencies
    libx11-6 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

RUN git clone https://github.com/manycore-research/SpatialLM.git && \
    cd SpatialLM && \
    git checkout ${COMMIT_ID}

WORKDIR /workspace/SpatialLM

# Install spatiallm python dependencies
RUN conda install -y conda-forge::sparsehash
RUN pip install poetry && poetry config virtualenvs.create false --local
RUN poetry config installer.max-workers 4 \
    && pip config set global.timeout 120 \
    && poetry install --no-interaction

# Fix for torchsparse installation. See https://github.com/manycore-research/SpatialLM/issues/10#issuecomment-2754357404
RUN FORCE_CUDA=1 pip install git+https://github.com/mit-han-lab/torchsparse.git@385f5ce

# Disable anonymous telemetry from Rerun
RUN rerun analytics disable
