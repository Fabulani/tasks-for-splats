FROM ghcr.io/nerfstudio-project/nerfstudio:latest

# Build arguments
ARG TORCH_CUDA_ARCH_LIST="7.5+PTX"
ENV TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git \
    wget \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists
    
# Feature Splatting
RUN pip install --no-cache-dir git+https://github.com/vuer-ai/feature-splatting

WORKDIR /root/.cache/torch/hub

# Download MobileSAMV2 model and weights 
RUN git clone https://github.com/RogerQi/MobileSAMV2.git RogerQi_MobileSAMV2_main && \
    cd RogerQi_MobileSAMV2_main && \
    git checkout c143897
WORKDIR /workspace
RUN python3 -c "import torch; mobilesamv2, ObjAwareModel, predictor = torch.hub.load('RogerQi/MobileSAMV2', 'mobilesamv2_efficientvit_l2', force_reload=True)"

WORKDIR /root/.cache/torch/hub

# Download DinoV2 model and weights
RUN git clone https://github.com/facebookresearch/dinov2.git facebookresearch_dinov2_main && \
    cd facebookresearch_dinov2_main && \
    git checkout e1277af
RUN mkdir /root/.cache/torch/hub/checkpoints && \
    wget -O /root/.cache/torch/hub/checkpoints/dinov2_vits14_pretrain.pth https://dl.fbaipublicfiles.com/dinov2/dinov2_vits14/dinov2_vits14_pretrain.pth

# Download CLIP model
RUN mkdir /root/.torch_hub && \
    wget -O /root/.torch_hub/ViT-L-14-336px.pt https://openaipublic.azureedge.net/clip/models/3035c92b350959924f9f00213499208652fc7ea050643e8b385c2dac08641f02/ViT-L-14-336px.pt

WORKDIR /workspace
