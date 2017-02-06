# airflow #

## install ##

<pre>
yum group install "development tools"

yum install -y epel-release python2-pip python2-devel mariadb-devel mariadb-server mariadb

pip install --upgrade pip setuptools -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com

pip install airflow[mysql, celery, hive] -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
</pre>
