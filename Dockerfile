FROM ubuntu:22.04
ENV TZ=Asia/Jakarta \
    DEBIAN_FRONTEND=noninteractive
# Install system dependencies and add deadsnakes PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.9 python3.9-venv python3.9-distutils git curl build-essential \
    python3.9-dev python3-pip python3-setuptools python3-wheel \
    && apt-get clean

# Set python3.9 as default python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# Create working directory
WORKDIR /app

# Copy FlowManager source code into the image
COPY . /app

# Create and activate virtual environment, install pip, eventlet, ryu
RUN python3.9 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install "setuptools<60.0.0" && \
    /app/venv/bin/pip install wheel && \
    /app/venv/bin/pip install eventlet==0.30.2 && \
    /app/venv/bin/pip install "ryu==4.34"

# Expose ports for OpenFlow and web UI
EXPOSE 8080 6633

# Set environment variables
ENV PATH="/app/venv/bin:$PATH"

# Default command to run FlowManager
CMD ["ryu-manager", "flowmanager/flowmanager.py"] 