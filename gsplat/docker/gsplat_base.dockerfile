FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-devel

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    # cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

WORKDIR /workspace

# gsplat
RUN git clone https://github.com/nerfstudio-project/gsplat.git --recursive && \
    cd gsplat && \
    git checkout 2043ddc

# fused-ssim - gsplat dependency
RUN git clone https://github.com/rahul-goel/fused-ssim.git && \
    cd fused-ssim && \
    git checkout 1272e21a282342e89537159e4bad508b19b34157
