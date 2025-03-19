#!/bin/bash

# TCP 缓存优化脚本
# 该脚本用于优化 TCP 缓存大小，调整网络参数，提高 VPS 的网络性能。
# 适用于 Debian 11 及其他 Linux 发行版。
# 主要优化项：
# - 增大 TCP 缓冲区，提升吞吐量
# - 启用 BBR 拥塞控制算法，提高网络稳定性
# - 设定默认队列算法为 FQ，优化流量调度
# - 其他网络优化参数，提高数据传输效率

# 设置终端颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 设置TCP缓存参数
SYSCTL_CONF="/etc/sysctl.conf"

# 备份原 sysctl.conf
cp $SYSCTL_CONF ${SYSCTL_CONF}.bak.$(date +%F-%H-%M-%S)

echo -e "${GREEN}优化 TCP 缓存...${NC}"

echo -e "\n${BLUE}[1] 调整 TCP 缓存大小...${NC}"
sysctl -w net.core.rmem_max=536870912  # 最大接收缓冲区
sysctl -w net.core.wmem_max=536870912  # 最大发送缓冲区
sysctl -w net.ipv4.tcp_rmem="16384 16777216 536870912"  # TCP接收缓存 (最小/默认/最大)
sysctl -w net.ipv4.tcp_wmem="16384 16777216 536870912"  # TCP发送缓存 (最小/默认/最大)

# 确保 net.ipv4.tcp_moderate_rcvbuf 开启
sysctl -w net.ipv4.tcp_moderate_rcvbuf=1  # 自动调整接收缓冲区

echo -e "\n${BLUE}[2] 其他优化参数...${NC}"
sysctl -w net.ipv4.neigh.default.base_reachable_time_ms=600000  # ARP条目生存时间，减少ARP查询
sysctl -w net.ipv4.neigh.eth1.delay_first_probe_time=1  # 加快探测失败地址的恢复
sysctl -w net.ipv4.neigh.default.mcast_solicit=20  # 增加组播探测次数，提高稳定性
sysctl -w net.ipv4.neigh.default.retrans_time_ms=250  # 重新传输的超时时间
sysctl -w net.ipv4.conf.all.rp_filter=0  # 关闭反向路径过滤，提高转发灵活性
sysctl -w net.ipv4.conf.eth0.rp_filter=0
sysctl -w net.ipv4.conf.eth1.rp_filter=0
sysctl -w net.core.default_qdisc=fq  # 设置默认队列算法为 FQ，提高流量公平性
sysctl -w net.ipv4.tcp_congestion_control=bbr  # 启用BBR拥塞控制算法，提高吞吐量
sysctl -w net.ipv4.tcp_fastopen=3  # 启用 TCP Fast Open，加速连接建立
sysctl -w fs.file-max=65535  # 提高系统文件描述符最大数量

echo -e "\n${BLUE}[3] 持久化到 /etc/sysctl.conf...${NC}"
grep -q "net.core.rmem_max" $SYSCTL_CONF || echo "net.core.rmem_max=536870912" >> $SYSCTL_CONF
grep -q "net.core.wmem_max" $SYSCTL_CONF || echo "net.core.wmem_max=536870912" >> $SYSCTL_CONF
grep -q "net.ipv4.tcp_rmem" $SYSCTL_CONF || echo "net.ipv4.tcp_rmem=16384 16777216 536870912" >> $SYSCTL_CONF
grep -q "net.ipv4.tcp_wmem" $SYSCTL_CONF || echo "net.ipv4.tcp_wmem=16384 16777216 536870912" >> $SYSCTL_CONF
grep -q "net.ipv4.tcp_moderate_rcvbuf" $SYSCTL_CONF || echo "net.ipv4.tcp_moderate_rcvbuf=1" >> $SYSCTL_CONF
grep -q "net.ipv4.tcp_congestion_control" $SYSCTL_CONF || echo "net.ipv4.tcp_congestion_control=bbr" >> $SYSCTL_CONF
grep -q "net.core.default_qdisc" $SYSCTL_CONF || echo "net.core.default_qdisc=fq" >> $SYSCTL_CONF
grep -q "fs.file-max" $SYSCTL_CONF || echo "fs.file-max=65535" >> $SYSCTL_CONF

# 立即应用新配置
sysctl -p

echo -e "\n${GREEN}[4] TCP 缓存优化完成！${NC}"
