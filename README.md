# Dockerfile-Jetson-YOLOv5

这是一个基于NVIDIA L4T ML镜像版本构建的Dockerfile，可用于Jetson设备运行YOLOv5。

### 系统环境

``` txt
OS:             Ubuntu 20.04.5 LTS
CUDA:           11.4
OpenCV:         4.5.0 with CUDA
TensorRT:       8.5.2.2
Torch:          2.0.0
TorchVision:    0.14.1
TensorFlow:     2.11.0
NumPy:          1.21.1
ONNX:           1.13.0
```

### 关于YOLOv5

这里使用了YOLOv5 v6.2版本

## 构建

使用如下命令构建Docker镜像。

```bash
./build
```

如果构建失败，可使用如下命令重新构建Docker镜像。

```bash
./build --no-cache
```

## 运行

这里默认绑定了USB摄像头“/dev/video0”，可使用如下命令运行。

```bash
./run
```

## 运行自己的权重文件

可以参考如下命令，运行自己的权重文件“xxx.pt”
```bash
mkdir -p /path/to/weights
cp xxx.pt /path/to/weights
xhost +local:
sudo docker run -it --rm \
           --runtime nvidia \
           --network host \
           --device /dev/video0:/dev/video0 \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix/:/tmp/.X11-unix \
           -v /path/to/weights:/weights \
           yolov5:jetson python3 detect.py --source 0 --weights /weights/xxx.pt
```

