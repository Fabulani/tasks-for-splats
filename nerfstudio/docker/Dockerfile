FROM ghcr.io/nerfstudio-project/nerfstudio:latest

# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git \
    wget \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists
    
WORKDIR /workspace

# Feature Splatting
RUN pip install --no-cache-dir git+https://github.com/vuer-ai/feature-splatting

# Download MobileSAMV2 model and weights. Must cd to workspace to avoid file not found error on torch.hub.load
RUN git clone https://github.com/RogerQi/MobileSAMV2.git ${TORCH_HOME}/RogerQi_MobileSAMV2_main && \
    cd ${TORCH_HOME}/RogerQi_MobileSAMV2_main && \
    git checkout c143897 && \
    pip install --no-cache-dir -e . && \
    cd /workspace && \
    python3 -c "import torch; mobilesamv2, ObjAwareModel, predictor = torch.hub.load('RogerQi/MobileSAMV2', 'mobilesamv2_efficientvit_l2', force_reload=True)"

# Download DinoV2 model and weights
RUN git clone https://github.com/facebookresearch/dinov2.git ${TORCH_HOME}/facebookresearch_dinov2_main && \
    cd ${TORCH_HOME}/facebookresearch_dinov2_main && \
    git checkout e1277af && \
    mkdir -p ${TORCH_HOME}/checkpoints && \
    wget -O ${TORCH_HOME}/checkpoints/dinov2_vits14_pretrain.pth \
         https://dl.fbaipublicfiles.com/dinov2/dinov2_vits14/dinov2_vits14_pretrain.pth

# Download CLIP model
RUN wget -O ${TORCH_HOME}/checkpoints/ViT-L-14-336px.pt \
         https://openaipublic.azureedge.net/clip/models/3035c92b350959924f9f00213499208652fc7ea050643e8b385c2dac08641f02/ViT-L-14-336px.pt

# Download AlexNet
RUN wget -O ${TORCH_HOME}/checkpoints/alexnet-owt-7be5be79.pth \
    https://download.pytorch.org/models/alexnet-owt-7be5be79.pth

# Fix for ns-export gaussian-splat: https://github.com/nerfstudio-project/nerfstudio/issues/3483#issuecomment-2430423841
RUN pip uninstall -y pymeshlab && pip install --no-cache-dir pymeshlab==2023.12.post1
