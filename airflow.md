# airflow #

## install ##

<pre>
yum group install "development tools"

yum install -y epel-release python2-pip python2-devel mariadb-devel mariadb-server mariadb

pip install --upgrade pip setuptools -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com

pip install airflow[mysql,celery,hive,crypto,password] -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
</pre>

## setup ##

<pre>
mkdir -p ~/airflow/logs
mkdir -p ~/airflow/dags

service mariadb start
chkconfig mariadb on
mysql -e "create database airflow default charset utf8"
mysql -e "grant all privileges on airflow.* to 'airflow'@'%' identified by 'airflow'"

airflow initdb
</pre>
