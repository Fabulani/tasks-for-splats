FROM node:23.11

ARG COMMIT_ID=0ed0dfa
ENV COMMIT_ID=${COMMIT_ID}

WORKDIR /workspace

RUN git clone https://github.com/playcanvas/supersplat.git --recursive && \
    cd supersplat && \
    git checkout ${COMMIT_ID} && \
    npm install

WORKDIR /workspace/supersplat

EXPOSE 3000