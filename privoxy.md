
# 安装 privoxy
<pre>
yum install privoxy -y
</pre>

/etc/privoxy/config
<pre>
listen-address  0.0.0.0:8118
forward-socks5 / 127.0.0.1:1080 .
</pre>

# 安装sslocal
<pre>
pip install  shadowsocks --trusted-host pypi.douban.com
</pre>

/etc/systemd/system/sslocal.service
<pre>
[Unit]
Description=sslocal

[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/sslocal.json

[Install]
WantedBy=multi-user.target
</pre>

/etc/sslocal.json
<pre>
{
    "server":"abc.com",
    "server_port":443,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"pwd",
    "timeout":300,
    "method":"rc4-md5",
    "fast_open": false,
    "workers": 1
}
</pre>

# 启动
<pre>
service sslocal start

service privoxy start
</pre>
