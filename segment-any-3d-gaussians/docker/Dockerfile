FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel


# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}
ARG COMMIT_ID="4acdaa6"
ENV COMMIT_ID=${COMMIT_ID}

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

RUN git clone https://github.com/Jumpat/SegAnyGAussians.git && \
    cd SegAnyGAussians && \
    git checkout ${COMMIT_ID}

# Download ViT-H model for SAM
RUN mkdir -p /workspace/SegAnyGAussians/third_party/segment-anything/sam_ckpt && \
    wget -O /workspace/SegAnyGAussians/third_party/segment-anything/sam_ckpt/sam_vit_h_4b8939.pth \
    https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth

WORKDIR /workspace/SegAnyGAussians

ENV CONDA_ALWAYS_YES=true

# Fix for conda env hanging up due to missing Pytorch3D repository
# Issue: https://github.com/Jumpat/SegAnyGAussians/issues/5#issuecomment-1972428432
RUN conda install https://anaconda.org/pytorch3d/pytorch3d/0.7.4/download/linux-64/pytorch3d-0.7.4-py39_cu113_pyt1121.tar.bz2

RUN conda env create --file environment.yml && \
    conda activate gaussian_splatting

