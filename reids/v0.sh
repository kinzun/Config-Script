#!/bin/sh
#sed -i '/^# slaveof/{N;'s/^/gogo/'}' $redis_path
#sed -i '/otherstop/i\ffdsafdf' text.html

while true;do
echo "please enter mt|sl"

read conf

IP=`/usr/bin/grep "IPADDR" /etc/sysconfig/network-scripts/ifcfg-eth0 |/usr/bin/awk -F= '{ print $2 }'`
redis_path=/etc/redis.conf
case $conf in
mt)
echo $IPADDR

redis_conf(){
/usr/bin/sed -i "s@^bind 127.0.0.1@bind 127.0.0.1 $IP@" $redis_path
/usr/bin/sed -i "s@^daemonize no@daemonize yes@" $redis_path
}
redis_conf
;;
sl)
/usr/bin/sed -i "s@^bind 127.0.0.1@bind 127.0.0.1 $IP@" $redis_path
/usr/bin/sed -i "s@^daemonize no@daemonize yes@" $redis_path
/usr/bin/sed -i '/^# slaveof/a\slaveof 192.168.0.15 6379' $redis_path
exit 
;;

quit)
    echo "exit"
    break
    exit 1

;;
*)
    echo "enter:  mt|sl|quit "
    continue
;;


esac
done
