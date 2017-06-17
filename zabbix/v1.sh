#!/bin/sh
#zabbix server install pack
#yum install -y zabbix-server-mysql zabbix-web-mysql
# mysql -uroot -h127.0.0.1 -e "drop database if exists test;" 数据存在则删除
# mysql -uroot   <<EOF 2> /dev/null
#     show databases;
# EOF
#create database
#可以为自定义数据库地址

echo '''

	 ___ ____  __  __ 
 	|_ _| __ )|  \/  |
 	 | ||  _ \| |\/| |
         | || |_) | |  | |
        |___|____/|_|  |_|
 
"sheng si youming ,fugui zai tian"
'''

ip=`/usr/bin/grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-eth0 |/usr/bin/awk -F= '{ print $2 }'`
#'''
#SourceIP：若是有多个IP，启用一个源IP，对方授权的IP

#DBHost：数据库服务地址
#
#DBname：zabbix数据库名
#
#DBuser：zabbix数据库账户名
#
#DBpassword：zabbix数据库密码 
#
#DBSocket：如果database与server在同一台主机就要改，不在就没事。
#
##启动：systemctl start zabbix-server，注意如果是centos是7.0或者7.1版本的trousers包要更新.

case $1 in

bt|basecreate)
sqlcreate(){
mysql -uroot -h127.0.0.1 -e "
CREATE DATABASE  zabbix CHARSET 'utf8';
GRANT ALL ON zabbix.* TO zbxuser@'192.168.%.%' IDENTIFIED BY 'zbxpass';
GRANT ALL ON zabbix.* TO zbxuser@'127.0.0.1' IDENTIFIED BY 'zbxpass';
FLUSH PRIVILEGES;
quit
"
createpath=`rpm -ql zabbix-server-mysql |grep "create"`
sqlpath=${createpath%.*}
gzip -d $createpath
mysql -zbxuser -h127.0.0.1 -pzbxpass zabbix < $sqlpath
}
sqlcreate
;;

pt|phptime)
# zcat /usr/share/doc/zabbix-server-mysql-3.2.1/create.sql.gz | mysql -uzabbix -p zabbix
# /usr/bin/sed -i '/^# masterauth/a\masterauth foobared ' $redis_path
#config php timezone,mysql skipdns
timesqlcg(){
/usr/bin/sed -i  '/\[mysqld\]/a\skip_name_resolve = ON\ninnodb_file_per_table = ON'  /etc/my.cnf
sed -i '/# php_value date.timezone.*/c\\tphp_value date.timezone Asia/Shanghai' /etc/httpd/conf.d/zabbix.conf
}
timesqlcg

;;

cgs)
#config zabbix server 
configzbs(){

sed -i "/^# DBHost=localhost/a\DBHost=$ip" /etc/zabbix/zabbix_server.conf
sed -i "s/DBUser\=root/DBUser\=zabuser/g" /etc/zabbix/zabbix_server.conf
sed -i "/# DBPassword=/aDBPassword=zabpass\n" /etc/zabbix/zabbix_server.conf
#sed -i "s#tmp/zabbix_server.log#var/log/zabbix/zabbix_server.log#g" /etc/zabbix/zabbix_server.conf
}
configzbs
;;

*)
    echo '''
          bt|basecreate 
          pt|phptime zone   
          cgs|config zabbix server
    '''
;;
esac
