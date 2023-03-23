# 修改拥塞算法并开启 tcp_fastopen

1. `modprobe tcp_bbr`
2. `vim /etc/sysctl.conf`

   ```conf
   # 开启tcp bbr拥塞算法
   net.core.default_qdisc = fq
   net.ipv4.tcp_congestion_control = bbr
   # 开启tcp fastopen
   net.ipv4.tcp_fastopen = 3
   ```

3. `sudo sysctl -p`
4. 检查 BBR 及 `tcp_fastopen` 是否已经开启

   ```bash
   lsmod | grep bbr
   sysctl net.ipv4.tcp_available_congestion_control
   sysctl net.ipv4.tcp_congestion_control
   sysctl net.ipv4.tcp_fastopen
   ```
