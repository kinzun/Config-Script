#!/bin/sh
#sed -i '/^# slaveof/{N;'s/^/gogo/'}' $redis_path
#sed -i '/otherstop/i\ffdsafdf' text.html
echo '''

	 ___ ____  __  __ 
 	|_ _| __ )|  \/  |
 	 | ||  _ \| |\/| |
         | || |_) | |  | |
        |___|____/|_|  |_|
 
"sheng si youming ,fugui zai tian"
'''
IP=`/usr/bin/grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-eth0 |/usr/bin/awk -F= '{ print $2 }'`
redis_path=/etc/redis.conf
redis_stpath=/etc/redis-sentinel.conf
case $1 in
mt)
echo $IPADDR

redis_conf(){
/usr/bin/sed -i "s@^bind 127.0.0.1@bind 127.0.0.1 $IP@" $redis_path

/usr/bin/sed -i "s@^daemonize no@daemonize yes@" $redis_path
/usr/bin/sed -i '/^# requirepass foobared/a\requirepass foobarede' $redis_path
}
redis_conf
;;
sl)
/usr/bin/sed -i "s@^bind 127.0.0.1@bind 127.0.0.1 $IP@" $redis_path
/usr/bin/sed -i "s@^daemonize no@daemonize yes@" $redis_path
/usr/bin/sed -i '/^# slaveof/a\slaveof 192.168.0.15 6379' $redis_path
/usr/bin/sed -i '/^# requirepass foobared/i\#' $redis_path
/usr/bin/sed -i '/^# masterauth/a\masterauth foobared ' $redis_path

;;
st)
/usr/bin/sed -i "s@^sentinel mon.*@sentinel monitor mymaster $IP 6379 1@" $redis_stpath
/usr/bin/sed -i '$a daemonize yes' $redis_stpath
/usr/bin/sed -i '/^# sentinel auth-pass mymaster.*/a\sentinel auth-pass mymaster foobared' $redis_stpath


;;

quit|exit)
    echo "exit"
    exit 1

;;
*)
    echo '''
	mt---master
	sl---slaveof
	st---sentinel	
	quit:exit
			
 '''
;;


esac
