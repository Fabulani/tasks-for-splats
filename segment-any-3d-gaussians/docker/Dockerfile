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

# # Fix for this issue: https://github.com/Jumpat/SegAnyGAussians/issues/5#issuecomment-1972428432
RUN conda install https://anaconda.org/pytorch3d/pytorch3d/0.7.4/download/linux-64/pytorch3d-0.7.4-py39_cu113_pyt1121.tar.bz2

#! Hanged for 10k seconds resolving environment!
RUN conda env create --file environment.yml 
    # conda activate gaussian_splatting


# Fast clean install using conda
# COPY environment.yml /tmp/environment.yml
# RUN conda env create -f /tmp/environment.yml 
    # conda clean -afy

# # Then install using pip within conda
# RUN /bin/bash -c "source activate gaussian_splatting && \
#     pip install \
#       submodules/diff-gaussian-rasterization \
#       submodules/diff-gaussian-rasterization-depth \
#       submodules/diff-gaussian-rasterization_contrastive_f \
#       submodules/simple-knn \
#       third_party/segment-anything \
#       dearpygui \
#       opencv-python \
#       open-clip-torch \
#       joblib==1.1.0 \
#       --no-cache-dir"

