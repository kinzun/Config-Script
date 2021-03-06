#!/bin/sh

#
#https://github.com/shadowsocks/shadowsocks/tree/master
#
#http://shadowsocks.org/en/download/servers.html
# yum install python-pip
# pip install shadowsocks

configss(){
if [ ! -e /etc/shadowsocks.json ] ;then
        cat > /etc/shadowsocks.json << EOF
{
    "server":"45.76.13.61",
    "local_address": "127.0.0.1",
    "local_port":1080,
    "port_password":{
        "9128":"tianqibucuo",
	"9129":"nihaoa",
    },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}

EOF
fi

}
configss


case $1 in
start)

	ssserver -c /etc/shadowsocks.json -d start
	;;

stop)
	ssserver -c /etc/shadowsocks.json -d stop
	;;

*)
	echo "Usage: $(basename $0) {start|stop|}"
	exit 1

	;;

esac


