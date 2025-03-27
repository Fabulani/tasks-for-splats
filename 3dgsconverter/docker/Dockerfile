FROM python:3.10.16-slim

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    # For pip install from source
    git \
    # Cleanup
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists

RUN pip install git+https://github.com/francescofugazzi/3dgsconverter.git@37dc41e

RUN git clone https://github.com/francescofugazzi/3dgsconverter.git && \
    cd 3dgsconverter && \
    git checkout 37dc41e

WORKDIR /workspace/3dgsconverter

# Cleanup
RUN apt-get remove --purge -y git && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*
