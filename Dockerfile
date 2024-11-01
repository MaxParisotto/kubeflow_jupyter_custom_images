FROM nvcr.io/nvidia/nemo:dev

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        ffmpeg \
        git \
        jupyter \
        libsm6 \
        libxext6 \
        libxrender1 \
        python3 \
        python3-dev \
        python3-setuptools \
        python3-pip \
        rsync \
        vim && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter extensions
RUN pip3 install jupyter_contrib_nbextensions==0.5.1 && \
    jupyter contrib nbextension install --system

# Set environment variables
ENV PYTHONPATH='/usr/local/lib/python3.9/site-packages'
ENV LD_LIBRARY_PATH="/opt/conda/lib:${LD_LIBRARY_PATH}"
ENV PATH="/usr/local/cuda-12.0/bin:/usr/local/nvidia/bin:${PATH}"

# Set up aliases for python and pip
RUN echo 'alias python=python3' >> /root/.bashrc && \
    echo 'alias pip=pip3' >> /root/.bashrc

# Install NeMo and dependencies
RUN cd /tmp && \
    git clone --depth 1 -b main https://github.com/NVIDIA/NeMo.git && \
    pip3 install ./NeMo

# Expose the default Jupyter port
EXPOSE 8888

# Optional: Set the working directory
WORKDIR /root

# Adjust the CMD instruction if necessary
CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]