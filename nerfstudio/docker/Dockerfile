FROM ghcr.io/nerfstudio-project/nerfstudio:latest

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists
    
# Feature Splatting
RUN pip install git+https://github.com/vuer-ai/feature-splatting