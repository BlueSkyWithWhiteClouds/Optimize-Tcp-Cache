# Optimize-Tcp-Cache
  Optimize Tcp Cache

# TCP 缓存优化脚本
该脚本用于优化 TCP 缓存大小，调整网络参数，提高 VPS 的网络性能。
适用于 Debian 11 及其他 Linux 发行版。

# 主要优化项：
- 增大 TCP 缓冲区，提升吞吐量
- 启用 BBR 拥塞控制算法，提高网络稳定性
- 设定默认队列算法为 FQ，优化流量调度
- 其他网络优化参数，提高数据传输效率



# TCP 缓存的作用

TCP 缓存的主要作用是优化数据传输性能，具体功能如下：

1. **提高吞吐量**：通过缓存数据，TCP 可以在网络条件允许时一次性发送更多数据，减少频繁的小数据包传输，提升网络利用率。
2. **减少延迟**：发送方缓存数据后，可以等待更多数据到达再发送，避免频繁的小数据包传输，降低网络延迟。
3. **流量控制**：接收方通过缓存管理数据接收速率，防止发送方发送过快导致数据丢失或拥塞。
4. **拥塞控制**：TCP 通过缓存和拥塞控制算法（如 Reno、Cubic）动态调整发送速率，避免网络过载。

---

## 调参位置

调参的位置取决于优化目标：

1. **落地机**：如果目标是优化特定服务器的性能，应在落地机上调参。落地机指数据最终到达的服务器，如 Web 服务器、数据库服务器等。
2. **线路机**：如果目标是优化网络传输性能，应在线路机上调参。线路机指路由器、交换机等网络设备。

---

## 调参建议

### 落地机
- **接收缓存**：增大接收缓存可提升吞吐量，减少丢包。
- **发送缓存**：增大发送缓存可提升发送效率，减少延迟。

### 线路机
- **队列管理**：调整队列长度和算法（如 RED、CoDel）可优化网络拥塞控制。
- **带宽分配**：合理分配带宽，避免某些流量占用过多资源。

---

## 总结

- **落地机**调参优化服务器性能。
- **线路机**调参优化网络传输性能。

根据具体需求选择合适的调参位置。

# TCP 缓存优化脚本
- 增加 TCP 缓存大小，提升吞吐量
- 启用 BBR 拥塞控制算法，提高网络稳定性
- 适用于 Debian 11 及其他 Linux 发行版

# 使用方法 (复制粘贴到命令行并且执行)
```
wget https://github.com/BlueSkyWithWhiteClouds/Optimize-Tcp-Cache/releases/download/v1.0/Optimize_Tcp_Cache.sh ; chmod +x Optimize_Tcp_Cache.sh ; ./Optimize_Tcp_Cache.sh
```
效果

```

TCP 缓存优化脚本
 
该脚本用于优化 TCP 缓存大小，调整网络参数，提高 VPS 的网络性能。
适用于 Debian 11 及其他 Linux 发行版。
 
主要优化项：
- 增大 TCP 缓冲区，提升吞吐量
- 启用 BBR 拥塞控制算法，提高网络稳定性
- 其他网络优化参数，提高数据传输效率

[1] 调整 TCP 缓存大小...
net.core.rmem_max = 536870912
net.core.wmem_max = 536870912
net.ipv4.tcp_rmem = 16384 16777216 536870912
net.ipv4.tcp_wmem = 16384 16777216 536870912
net.ipv4.tcp_moderate_rcvbuf = 1

[2] 其他优化参数...
net.ipv4.neigh.default.base_reachable_time_ms = 600000
net.ipv4.neigh.eth1.delay_first_probe_time = 1
net.ipv4.neigh.default.mcast_solicit = 20
net.ipv4.neigh.default.retrans_time_ms = 250
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.eth1.rp_filter = 0
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
fs.file-max = 65535

[3] 持久化到 /etc/sysctl.conf...
net.ipv4.neigh.default.base_reachable_time_ms = 600000
net.ipv4.neigh.eth1.delay_first_probe_time = 1
net.ipv4.neigh.default.mcast_solicit = 20
net.ipv4.neigh.default.retrans_time_ms = 250
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.eth1.rp_filter = 0
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
fs.file-max = 65535
net.core.rmem_max = 536870912
net.core.wmem_max = 536870912
net.ipv4.tcp_rmem = 16384 16777216 536870912
net.ipv4.tcp_wmem = 16384 16777216 536870912
net.ipv4.tcp_moderate_rcvbuf = 1

[4] TCP 缓存优化完成！
```

# TCP 缓存优化的效果分析

## 1. 影响优化效果的因素

### **(1) 线路较差的 VPS**
对于**高丢包、延迟大、带宽小**的 VPS，TCP 优化可能带来明显提升，具体表现为：
- **BBR 拥塞控制**：在弱网环境下提高吞吐量，减少因丢包导致的速度下降。
- **增加 TCP 缓冲区**：减少数据包丢失的影响，提高整体连接稳定性。
- **TCP Fast Open**：减少握手延迟，加快连接建立速度。

### **(2) 线路优质的 VPS**
对于**CN2 GIA、优质运营商直连**的 VPS，优化效果可能不明显，甚至可能带来负优化：
- **过大的 TCP 缓冲区**：可能增加系统内存占用，但对低延迟、高带宽的环境提升有限。
- **BBR 在部分网络下未必优于 CUBIC**，尤其是**带宽充足但高并发**的场景。
- **TCP Fast Open 可能导致 NAT VPS 连接问题**。

## 2. 其他影响因素
- **目标服务器的网络配置**（对端的 TCP 拥塞控制、MSS/MTU）。
- **本地 Linux 内核版本**（不同版本的 BBR 可能有不同效果）。
- **实际使用场景**（流量走向、并发数、协议特性）。

## 3. 结论
- **VPS 线路较差时**，优化可能会带来明显提升，尤其是 **BBR + FQ** 组合。
- **线路本身已很好**，优化可能效果不大，甚至在个别情况下导致负优化。
- **建议使用 `iperf3` 或 `wget` 进行测试**，对比前后网络性能变化，确保优化有效。

