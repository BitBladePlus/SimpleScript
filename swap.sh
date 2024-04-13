#!/bin/bash

# 检查当前系统是否已经有swap分区
echo "检查当前系统的swap情况..."
swapon -s

# 确认用户操作
read -p "这将创建一个2GB大小的swap分区，继续吗？(y/n): " choice
if [[ $choice == "y" ]]; then
    # 创建一个2GB大小的swap文件
    echo "创建swap文件..."
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile

    # 将文件设置为swap分区
    echo "设置swap分区..."
    sudo mkswap /swapfile
    sudo swapon /swapfile

    # 添加swap分区到 /etc/fstab 文件中，以便开机自动挂载
    echo "将swap分区添加到 /etc/fstab..."
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

    echo "已经成功创建并启用2GB大小的swap分区！"
    # 显示当前swap情况
    echo "当前swap情况："
    swapon -s
else
    echo "操作已取消。"
fi
