# vsftp 安装备忘

# 安装
`yum install vsftp`

# 配置

`vim /etc/vsftpd/vsftpd.conf`

```
#服务器独立运行
listen=YES
#设定不允许匿名访问
anonymous_enable=NO
#设定本地用户可以访问。注：如使用虚拟宿主用户，在该项目设定为NO的情况下所有虚拟用户将无法访问
local_enable=YES
#使用户不能离开主目录
chroot_list_enable=YES
#设定支持ASCII模式的上传和下载功能
ascii_upload_enable=YES
ascii_download_enable=YES
#PAM认证文件名。PAM将根据/etc/pam.d/vsftpd进行认证
pam_service_name=vsftpd
#设定启用虚拟用户功能
guest_enable=YES
#指定虚拟用户的宿主用户，CentOS中已经有内置的ftp用户了
guest_username=ftp
#设定虚拟用户个人vsftp的CentOS FTP服务文件存放路径。存放虚拟用户个性的CentOS FTP服务文件(配置文件名=虚拟用户名)
user_config_dir=/etc/vsftpd/vuser_conf
#配置vsftpd日志（可选）
xferlog_enable=YES
xferlog_std_format=YES
xferlog_file=/var/log/xferlog
dual_log_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
```

## 安装认证包

`yum install db4*`

创建用户密码文本

`vim /etc/vsftpd/vuser_passwd.txt`

```
用户名
密码
```

`vim /etc/pam.d/vsftpd`

```
auth required pam_userdb.so db=/etc/vsftpd/vuser_passwd
account required pam_userdb.so db=/etc/vsftpd/vuser_passwd
```

创建虚拟用户配置文件
`mkdir /etc/vsftpd/vuser_conf/`

文件名等于vuser_passwd.txt里面的账户名，否则下面设置无效
`vim /etc/vsftpd/vuser_conf/用户名`

```
anon_world_readable_only=NO
write_enable=YES
anon_mkdir_write_enable=YES
anon_upload_enable=YES
anon_other_write_enable=YES
local_root=目录路径
```

*tips: 注意设置目录权限*

建立限制用户访问目录的空文件
touch /etc/vsftpd/chroot_list

如果启用vsftpd日志需手动建立日志文件
touch /var/log/xferlog 
touch /var/log/vsftpd.log

## 启动
`service vsftpd start/restart`
