#! /usr/bin/sh

# 修改当前目录下权限
find . -type f -print0 | xargs -0 chmod 0644
find * -type d -print0 | xargs -0 chmod 0755
