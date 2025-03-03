FROM nvidia/cuda:12.3.0-devel-ubuntu22.04
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 sudo build-essential ca-certificates openssh-server vim ffmpeg libsm6 libxext6 python3-opencv gcc-11 g++-11 cmake

# conda
ENV PATH /opt/conda/bin:$PATH 
RUN wget --quiet \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -rf /tmp/*

# Create the user
RUN addgroup --gid $GROUP_ID user
RUN useradd --create-home -s /bin/bash --uid $USER_ID --gid $GROUP_ID docker
RUN adduser docker sudo
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER docker

# Setup hierarchical_3d_gaussians
RUN /opt/conda/bin/python -m ensurepip
RUN /opt/conda/bin/python -m pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu121
RUN /opt/conda/bin/python -m pip install plyfile tqdm joblib exif scikit-learn timm==0.4.5 opencv-python==4.9.0.80 gradio_imageslider gradio==4.29.0 matplotlib

# Install COLMAP dependencies
RUN sudo apt-get install -y --no-install-recommends \
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

# Clone COLMAP repository
RUN sudo git clone https://github.com/colmap/colmap

RUN cd /colmap && \
    sudo mkdir build && \
    cd build && \
    sudo cmake -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc -DCMAKE_CUDA_ARCHITECTURES="75;80;86;87;90" .. && \
    sudo make -j4 && \
    sudo make install

WORKDIR /host

# Download Depth-Anything-V2 checkpoint
RUN wget -O ./submodules/Depth-Anything-V2/checkpoints/depth_anything_v2_vitl.pth "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth?download=true"

# Compile hierarchy generator and merger
RUN cd submodules/gaussianhierarchy && \
    cmake . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build -j --config Release

# Missing packages for SIBR viewers. Need cleanup later.
RUN apt-get install -y libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev libglfw3-dev libavdevice-dev libavcodec-dev libxxf86vm-dev libembree-dev

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN sudo chmod +x /entrypoint.sh