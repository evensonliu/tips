# samba服务器搭建备忘

## 安装
`yum install samba`

## 配置
`vim /etc/samba/smb.conf`
```
[global]
        workgroup = WORKGROUP
        server string = Samba Server Version %v
        log file = /var/log/samba/log.%m
        max log size = 50
        cups options = raw
        #匿名用户使用这个参数
        map to guest =Bad User
        #指定用户访问需要修改成
        security = user
        passdb backend = tdbsam
#匿名用户可读写
[share]
        path = /home/samba/share
        public = yes
        browseable= yes
        writable= yes
        create mask = 0644
        directory mask = 0755
        guest ok = yes
        read only = no
[ui]
        path = /home/samba/ui
        public = yes
        browseable= yes
        writable= yes
        create mask = 0644
        directory mask = 0755
        read only = no
        valid users = ui
```
## 配置须知
* 若需要匿名访问 主要注意如下
    `map to guest =Bad User`
    `guest ok = yes`
* 关闭selinux
    `setenforce 0`
* 若需要登录访问 先要添加相应用户然后
    `smbpasswd -a 用户名`
* 修改相应目录权限
