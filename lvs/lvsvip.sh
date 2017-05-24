#!/bin/bash
#description: Config realserver

VIP=192.168.0.80

/etc/rc.d/init.d/functions
iface=eth0
case "$1" in
start)

       echo "1" >/proc/sys/net/ipv4/conf/$iface/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/$iface/arp_announce
       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
       sysctl -p >/dev/null 2>&1
       /sbin/ifconfig lo:0 $VIP netmask 255.255.255.255 broadcast $VIP up
       /sbin/route add -host $VIP dev lo:0
       echo "RealServer Start OK"
       ;;
stop)
       echo "0" >/proc/sys/net/ipv4/conf/$iface/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/$iface/arp_announce
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
       echo "RealServer Stoped"
       /sbin/ifconfig lo:0 down
       /sbin/route del $VIP >/dev/null 2>&1
       ;;
*)
       echo "Usage: $0 {start|stop}"
       exit 1
esac

exit 0
