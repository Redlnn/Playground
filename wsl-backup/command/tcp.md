1. `modprobe tcp_bbr`
2. `vim /etc/sysctl.conf`
```
# 开启tcp bbr拥塞算法
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
# 开启tcp fastopen
net.ipv4.tcp_fastopen = 3
```
3. `echo 3 > /proc/sys/net/ipv4/tcp_fastopen`
4. `sysctl -p`
5. 
```
lsmod | grep bbr  # 检查BBR是否已经开启
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
```
