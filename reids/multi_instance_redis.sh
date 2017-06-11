#!/bin/bash

# 执行完脚本，必须修改配置文件，增加requirepass等。。。。

yum install -y redis

redis_sentinel_ports=(26379 26380 26381)
redis_ports=(6379 6380 6381)
pid_dir=/var/run/redis
log_dir=/var/log/redis

mv /usr/lib/systemd/system/redis-sentinel.service{,.bak}
mkdir -p /etc/redis.d/

for port in ${redis_sentinel_ports[@]};do
	cp /usr/lib/systemd/system/redis-sentinel.service.bak /usr/lib/systemd/system/redis-sentinel${port}.service
	sed -i "s@^ExecStart.*@ExecStart=/usr/bin/redis-sentinel /etc/redis.d/redis-sentinel${port}.conf --daemonize no@" /usr/lib/systemd/system/redis-sentinel${port}.service
	sed -i "s@^ExecStop.*@ExecStop=/usr/bin/redis-shutdown redis-sentinel${port}@" /usr/lib/systemd/system/redis-sentinel${port}.service

	cp /etc/redis-sentinel.conf /etc/redis.d/redis-sentinel${port}.conf
	file=/etc/redis.d/redis-sentinel${port}.conf
	sed -i "s@^port.*@port ${port}@" $file
	sed -i "s@^sentinel monitor.*@sentinel monitor mymaster 127.0.0.1 6379 2@" $file
	sed -i "s@^logfile@logfile ${log_dir}/sentinel${port}.log@" $file
done

mv /usr/lib/systemd/system/redis.service{,.bak}
for port in ${redis_ports[@]};do
	cp /usr/lib/systemd/system/redis.service.bak /usr/lib/systemd/system/redis${port}.service
	sed -i "s@^ExecStart.*@ExecStart=/usr/bin/redis-server /etc/redis.d/redis${port}.conf --daemonize no@" /usr/lib/systemd/system/redis${port}.service
	sed -i "s@^ExecStop.*@ExecStop=/usr/bin/redis-shutdown /etc/redis.d/redis${port}@" /usr/lib/systemd/system/redis${port}.service

	cp /etc/redis.conf /etc/redis.d/redis${port}.conf

	file=/etc/redis.d/redis${port}.conf
	sed -i "s/^port.*/port ${port}/" $file
	sed -i "s@^pidfile.*@pidfile \"$pid_dir/redis${port}.pid\"@" $file
	sed -i "s@^logfile.*@logfile \"$log_dir/redis${port}.log\"@" $file
	sed -i "s@^dbfilename.*@dbfilename \"dump${port}.rdb\"@" $file
	sed -i "s@^appendfilename.*@appendfilename \"appendonly${port}.aof\"@" $file
done

rm -rf /etc/redis.conf /etc/redis-sentinel.conf
chown  redis. /etc/redis.d/*
systemctl daemon-reload
