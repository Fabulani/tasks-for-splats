FROM nvidia/cuda:12.3.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 build-essential ca-certificates openssh-server vim ffmpeg libsm6 libxext6 python3-opencv gcc-11 g++-11 cmake

# conda
ENV PATH /opt/conda/bin:$PATH 
RUN wget --quiet \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -rf /tmp/*

# Install hierarchical_3d_gaussians Python dependencies
RUN /opt/conda/bin/python -m ensurepip
RUN /opt/conda/bin/python -m pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu121
RUN /opt/conda/bin/python -m pip install plyfile tqdm joblib exif scikit-learn timm==0.4.5 opencv-python==4.9.0.80 gradio_imageslider gradio==4.29.0 matplotlib

# Install COLMAP dependencies
RUN apt-get install -y --no-install-recommends \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    libmetis-dev \
    libflann-dev \
    libsqlite3-dev \
    libceres-dev

# Clone and install COLMAP
RUN git clone https://github.com/colmap/colmap
RUN cd /colmap && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc -DCMAKE_CUDA_ARCHITECTURES="75;80;86;87;90" .. && \
    make -j4 && \
    make install

# # Missing packages for SIBR viewers.
# RUN apt-get install -y libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev libglfw3-dev libavdevice-dev libavcodec-dev libxxf86vm-dev libembree-dev

# Clone hierarchical-3d-gaussians (h3dg)
RUN git clone https://github.com/graphdeco-inria/hierarchical-3d-gaussians.git --recursive

WORKDIR /hierarchical-3d-gaussians

# Download Depth-Anything-V2 checkpoint
RUN mkdir -p submodules/Depth-Anything-V2/checkpoints/ && \
    wget -O submodules/Depth-Anything-V2/checkpoints/depth_anything_v2_vitl.pth "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth?download=true"

# Compile hierarchy generator and merger
RUN cd submodules/gaussianhierarchy && \
    cmake . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build -j --config Release

# Copy other files for h3dg
COPY entrypoint.sh entrypoint.sh
COPY run_all.sh run_all.sh
COPY run_skip_colmap.sh run_skip_colmap.sh

# Make the entrypoint script executable
RUN chmod +x entrypoint.sh