#!/bin/bash

# 执行完脚本，必须修改配置文件，增加requirepass等。。。。
#	sed -i "s/^pidfile.*/#&/" /etc/redis.conf  #注释

itredis(){
rpm -qa |grep redis > /dev/null 2>&1 
if [ "$?" -ne 0 ] ;then
	yum install redis -y  > /dev/null 2>&1

	echo "install redis successfully"
fi
}
itredis
redis_sentinel_ports=(26379 26380 26381)
redis_ports=(6379 6380 6381)
pid_dir=/var/run/redis
log_dir=/var/log/redis

mv /usr/lib/systemd/system/redis-sentinel.service{,.bak}
mkdir -p /etc/redis.d/

#sentinel server
#
for port in ${redis_sentinel_ports[@]};do
	cp /usr/lib/systemd/system/redis-sentinel.service.bak /usr/lib/systemd/system/redis-sentinel${port}.service
	sed -i "s@^ExecStart.*@ExecStart=/usr/bin/redis-sentinel /etc/redis.d/redis-sentinel${port}.conf --daemonize no@" /usr/lib/systemd/system/redis-sentinel${port}.service
	sed -i "s@^ExecStop.*@ExecStop=/usr/bin/redis-shutdown redis-sentinel${port}@" /usr/lib/systemd/system/redis-sentinel${port}.service
#sentinel config 
	cp /etc/redis-sentinel.conf /etc/redis.d/redis-sentinel${port}.conf
	file=/etc/redis.d/redis-sentinel${port}.conf
	sed -i "s@^port.*@port ${port}@" $file 
	sed -i "s@^sentinel monitor.*@sentinel monitor mymaster 127.0.0.1 6379 2@" $file 
	sed -i "s@^logfile.*@logfile ${log_dir}/sentinel${port}.log@" $file #log
	sed -i '$a daemonize yes' $file
#	sed -i "/^logfile.*/a\pidfile  /var/run/reids_sentinel_${port}.pid" $file
	sed -i "/^logfile.*/a\pidfile  $pid_dir/sentinel${port}.pid" $file
done

mv /usr/lib/systemd/system/redis.service{,.bak}
for port in ${redis_ports[@]};do
	cp /usr/lib/systemd/system/redis.service.bak /usr/lib/systemd/system/redis${port}.service
	sed -i "s@^ExecStart.*@ExecStart=/usr/bin/redis-server /etc/redis.d/redis${port}.conf --daemonize no@" /usr/lib/systemd/system/redis${port}.service
	sed -i "s@^ExecStop.*@ExecStop=/usr/bin/redis-shutdown /etc/redis.d/redis${port}@" /usr/lib/systemd/system/redis${port}.service

	cp /etc/redis.conf /etc/redis.d/redis${port}.conf

	file=/etc/redis.d/redis${port}.conf 
	sed -i "s@^bind.*@bind 0.0.0.0@" $file
	sed -i "s/^port.*/port ${port}/" $file
	sed -i "s@^pidfile.*@pidfile $pid_dir/redis${port}.pid@" $file
	sed -i "s@^logfile.*@logfile $log_dir/redis${port}.log@" $file
	sed -i "s@^dbfilename.*@dbfilename dump${port}.rdb@" $file
	sed -i "s@^appendfilename.*@appendfilename \"appendonly${port}.aof\"@" $file #AOF文件名称
	sed -i "s@^dir.*@dir /var/lib/redis/${port}@" $file #文件存放
	sed -i "/^daemonize.* /c\daemonize yes" $file #启用后台守护进程运行模式 

done

rm -rf /etc/redis.conf /etc/redis-sentinel.conf
chown  redis. /etc/redis.d/*
for port in ${redis_ports[@]};do
	redis-server /etc/redis.d/redis${port}.conf
done
systemctl daemon-reload
