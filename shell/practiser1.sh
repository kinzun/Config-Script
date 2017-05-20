#!/bin/bash
''185ssssss103.


1#!/bin/bash

server_ip=`ifconfig|grep'inet\b'|grep -v '127.0.0.1'|tr-s ' '|cut -d' ' -f3`
CPUmod=`lscpu|grep -i "model name:"`
Meminfo=`free -h|sed -n '2p'|tr -s ' '|cut -d' ' -f2`
DISKinfo=`fdisk -l |sed -n '2p'|sed -r 's/.*[[:space:]][0-9].*GB).*/\1/g`


echo 'hostname:' $(hostname)
echo 'hostIP:' ${server_ip}
echo 'OS version:' $(cat /etc/redhat-release)
echo 'Kernel version:' $(uname -r)
echo 'CPU:' $CPUmod
echo 'Memory:' $Meminfo
echo 'Harddisk:' $DISKinfo
lsblk|grep "^sd"
netstat -tan
last |egrep -o "^root\b.*[0-9]\.[0-9]{1,3}"|egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}" | uniq -c

netstat|grep "tcp"|cut -d"." -f2|tr -s " "|cut -d " " -f2
3


+   匹配其前面的字符至少1次             \{1,\}正则中近似 
    ？ 匹配紧挨在其前面的字符0次或1次    \?正则中 
    {m,n}  匹配前面字符至少m次至多n次      {1，}表示1至无限 {0,3}表示0-3 
    （）分组  \1 \2 \3 … 
     |  或者


4
 grep -n "^[[:blank:]]" file2



5. 

 nmap -sP 192.168.206.0/24|grep -B1 up|grep Nmap|cut -d" " -f5


6.
> /var/log/app.log


7
nohup ./bin/backup.sh

8

9
cp -r /etc/skel /home/mage
cp /etc/shadow /home/mage
chown -R mage:mage /home/mage

setfacl -m u:wang:rx /home/mage/shadow
10.
#!/bin/bash

Tt=`date +%F`

mkdir /root/etc$Tt


11	


sort /root/file -n|head -1&&sort /root/file -n|tail -1
12

grep /root/web.txt "^http:\b./.com"
13


cut -d " " -f1 /root/access.log

14		
#!/bin/bash
for i in {1..100,2}
do
     r=$((r+i))
done
echo $r
15

echo {0..100..2}|tr ' ' '+' |bc
16
cut -d " " -f1 /var/log/httpd/access_log|uniq -c|sort -nr|head -20

17

18
cat qqnum.txt | cut -d: -f1 | sort | uniq -c

      2 600000
      4 600001
      3 600002
      1 600003

19
1. ls -aS /etc

2 ls -d /etc/\.*

3 ls -d /etc/
14.
grep -E"\<[tp].*[e.t]\>" /root/file1
20
mkdir /app/date

chmod 2750 /app/date

chown mysql:dbadmins /app/date


17.cat /etc/init.d/functions |tr -d '[[:punct:]]' |grep -o "."|sort |uniq -c|sort -nr

