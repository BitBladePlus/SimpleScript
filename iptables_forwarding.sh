#!/bin/bash

# 获取本地内网 IP 地址
local_ip=$(hostname -I | awk '{print $1}')

# 提示用户输入目标 IP 地址和端口
read -p "请输入转发的本地端口号: " dest_port
read -p "请输入要转发的目标IP地址: " forward_ip
read -p "请输入要转发的目标端口号: " forward_port

# 添加 PREROUTING 规则
sudo iptables -t nat -A PREROUTING -p tcp --dport $dest_port -j DNAT --to-destination $forward_ip:$forward_port

# 添加 POSTROUTING 规则
sudo iptables -t nat -A POSTROUTING -p tcp -d $forward_ip --dport $forward_port -j SNAT --to-source $local_ip

# 永久保存当前配置
sudo netfilter-persistent save