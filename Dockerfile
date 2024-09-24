
# 使用 NVIDIA Jetson ML 镜像
FROM nvcr.io/nvidia/l4t-ml:r35.2.1-py3

# 设置环境变量，避免交互式安装过程
ENV DEBIAN_FRONTEND=noninteractive

# 版本参数
# OPENCV版本
ARG OPENCV_VERSION=4.5.0
# YOLOv5子版本
ARG YOLO_VERSION=6.2

# 更新系统并安装基本依赖项
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    apt-utils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# PIP关联OpenCV
# 构建OpenCV-Python METADATA
RUN mkdir -p ~/.local/lib/python3.8/site-packages/opencv_python-${OPENCV_VERSION}.dist-info
RUN touch ~/.local/lib/python3.8/site-packages/opencv_python-${OPENCV_VERSION}.dist-info/METADATA

# 构建OpenCV-Contrib-Python METADATA
RUN mkdir -p ~/.local/lib/python3.8/site-packages/opencv_contrib_python-${OPENCV_VERSION}.dist-info
RUN touch ~/.local/lib/python3.8/site-packages/opencv_contrib_python-${OPENCV_VERSION}.dist-info/METADATA

# 克隆 YOLOv5 仓库并安装依赖
WORKDIR /workspace
RUN git clone -b v${YOLO_VERSION} https://github.com/ultralytics/yolov5.git && \
    cd yolov5 && \
    pip3 install -r requirements.txt && \
    wget -O yolov5s.pt https://github.com/ultralytics/yolov5/releases/download/v${YOLO_VERSION}/yolov5s.pt

# 设置默认工作目录并运行 bash
WORKDIR /workspace/yolov5
CMD ["bash"]
