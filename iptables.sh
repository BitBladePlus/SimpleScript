#!/bin/bash

# 此脚本最好在docker安装以前运行，以免破坏docker的防火墙。

# 配置网络参数并写入 /etc/sysctl.conf 文件中

# 设置 net.core.default_qdisc 参数为 fq，以优化网络队列调度
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf

# 设置 net.ipv4.tcp_congestion_control 参数为 bbr，使用 TCP BBR 拥塞控制算法
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf

# 启用 IPv4 转发功能，允许系统将接收到的数据包转发到其他网络接口
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

# 启用 IPv6 转发功能，允许系统将接收到的 IPv6 数据包转发到其他网络接口
echo "net.ipv6.conf.all.forwarding=1" | sudo tee -a /etc/sysctl.conf

# 加载并应用新的内核参数设置
sudo sysctl -p

#关闭ufw防火墙

ufw disable

# 安装 iptables-persistent 软件包
apt install iptables-persistent -y

# 设置默认策略为接受所有输入流量
iptables -P INPUT ACCEPT
# 设置默认策略为接受所有转发流量
iptables -P FORWARD ACCEPT
# 设置默认策略为接受所有输出流量
iptables -P OUTPUT ACCEPT
# 清除 mangle 表中的所有规则和计数器
iptables -t mangle -F
# 清除所有链中的规则和计数器
iptables -F
# 删除所有用户定义的链
iptables -X
# 将传入的 UDP 流量目标端口为 8443、2053、2096、2087、2083 的数据包目标地址重定向到端口 443
iptables -t nat -A PREROUTING -p udp -m multiport --dport 8443,2053,2096,2087,2083 -j DNAT --to-destination :443
# 将 IPv6 环境下传入的 UDP 流量目标端口为 8443、2053、2096、2087、2083 的数据包目标地址重定向到端口 443
ip6tables -t nat -A PREROUTING -p udp -m multiport --dport 8443,2053,2096,2087,2083 -j DNAT --to-destination :443

# 永久保存当前配置
netfilter-persistent save

# iptables -t nat -nL --line  可以查看转发规则
# tcpdump -nn -G 1 udp | awk '{print $1,$3}' | awk '/443|8443|2053|2096|2087|2083/'         这个命令可以查看端口跳跃是否成功
# iptables -t nat -F PREROUTING 用于清除所有清除 "nat" 表的 "PREROUTING" 链中的所有规则，即将那些用于处理流入数据包地址转换的规则全部删除。这通常用于规则的重置或重新配置 NAT 环境时转发的规则。