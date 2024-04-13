#!/bin/bash

# 检查是否已经安装 Docker
if ! command -v docker &> /dev/null; then
    echo "正在安装 Docker..."
    sudo curl -fsSL https://get.docker.com | bash -s docker
else
    echo "检测到 Docker 已经安装。"
fi

# 检查是否已经安装 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "正在安装 Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
else
    echo "检测到 Docker Compose 已经安装。"
fi

# 检查是否已经添加当前用户到 docker 用户组
if ! groups $USER | grep &>/dev/null '\bdocker\b'; then
    echo "将当前用户添加到 docker 用户组..."
    sudo groupadd docker
    sudo usermod -aG docker $USER
else
    echo "检测到当前用户已经添加到 docker 用户组。"
fi

# 测试 Docker 安装是否成功
echo "正在运行 hello-world 测试 Docker..."
docker run --rm hello-world

echo "Docker 安装完成！"
