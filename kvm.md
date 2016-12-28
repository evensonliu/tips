#kvm配置指南

*只适用于桥接，nat方式没有尝试*

# 环境
centos 7

# 操作系统来源
`http://mirrors.163.com/centos/7.3.1611/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso`

# 安装
```
yum -y install qemu-kvm libvirt virt-install bridge-utils 
```

# 配置
```
vim /etc/libvirt/qemu.conf
```

添加
<pre>
user = "root"
group = "root"
dynamic_ownership = 0
</pre>

启动
<pre>
systemctl start libvirtd
systemctl enable libvirtd
</pre>

# 配置网络
```
vim /etc/sysconfig/network-scripts/ifcfg-enp0s31f6
```

添加
<pre>
BRIDGE=br0
</pre>

```
vim /etc/sysconfig/network-scripts/ifcfg-br0
```

添加
<pre>
DEVICE=br0
BOOTPROTO=dhcp
ONBOOT=yes
TYPE=Bridge
</pre>

重启网络

```service network restart```

此时网络状况类似如下

```ip a```
<pre>
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP qlen 1000
    link/ether 40:8d:5c:c6:5b:f0 brd ff:ff:ff:ff:ff:ff
4: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 52:54:00:8f:1b:d8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
5: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN qlen 500
    link/ether 52:54:00:8f:1b:d8 brd ff:ff:ff:ff:ff:ff
8: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
    link/ether 40:8d:5c:c6:5b:f0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.148/24 brd 192.168.1.255 scope global dynamic br0
       valid_lft 2626sec preferred_lft 2626sec
    inet6 fe80::428d:5cff:fec6:5bf0/64 scope link 
       valid_lft forever preferred_lft forever
17: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UNKNOWN qlen 500
    link/ether fe:54:00:43:00:ca brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe43:ca/64 scope link 
       valid_lft forever preferred_lft forever
</pre>

# 安装guest系统

- 创建目录

```mkdir -p /data2/kvm/images ```

- 下载镜像

<pre>
cd /data2/kvm/
axel -n 10 http://mirrors.163.com/centos/7.3.1611/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso
</pre>

- 安装

```
virt-install --name v1 --ram 4096 --disk /data2/kvm/images/v1.img,size=30 --vcpus 2 --os-type linux --os-variant rhel7 --network bridge=br0 --graphics none --console pty,target_type=serial --extra-args 'console=ttyS0,115200n8 serial' --location "/data2/kvm/CentOS-7-x86_64-Minimal-1611.iso"
```

- 登入系统

```
virsh console v1
```

- 配置guest系统网络

```vim /etc/sysconfig/network-scripts/ifcfg-eth0```

<pre>
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.1.111
NETMASK=255.255.255.0
DNS1=192.168.1.1
TYPE=Ethernet
BOOTPROTO=static
IPV6INIT=no
USERCTL=no
</pre>

- 重启网络 

```service network restart```

- 注意事项

**首先关注是否能ping通网关，如能ping通网关不能上网有如下解决方案**

  1.在host上执行
    <pre>
    sysctl -w net.ipv4.ip_forward=1
    </pre>

  2.在guest上配置网关路由
    <pre>
    ip route add default via 192.168.1.1
    </pre> 

