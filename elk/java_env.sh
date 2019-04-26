#!/usr/bin/env bash



# install package path

path='/root/elk/jdk-8u211-linux-x64.tar.gz'


[ -d /elkdata ] || mkdir /elkdata/{data,logs} -p;chown elasticsearch.elasticsearch /elkdata/ -R

function limits_config() {
egrep '\* soft nofile 65536' /etc/security/limits.conf >/dev/null
if [ $? -ne 0 ]; then
cat << EOF >> /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
* soft nproc 65536
* hard nproc 65536

* soft memlock unlimited
* hard memlock unlimited

EOF
fi
}
limits_config

function sysctl_config() {
egrep "max_map_count" /etc/sysctl.conf >/dev/null
if [ $? -ne 0 ]; then
cat >> /etc/sysctl.conf <<EOF
vm.max_map_count=655360
EOF
fi
}
sysctl_config



# 解压 jdk
function unzjdk () {
if [ -d  /usr/local/jdk ];then
	return 0
fi
if [ -f  $path ];then
    cd $(dirname $path)
    tar xvf $(basename $path) -C /usr/local/src/
    ln -sv /usr/local/src/jdk1.8.0_211/ /usr/local/jdk
    ln -sv /usr/local/jdk/bin/java /usr/bin
else
    cd $1
    tar xvf jdk-8u211-linux-x64.tar.gz -C /usr/local/src/
    ln -sv /usr/local/src/jdk1.8.0_211/ /usr/local/jdk
fi
}
unzjdk

# jdk 环境配置
function jdk_config() {
egrep "JAVA_HOME=/usr/local/jdk" /etc/profile >/dev/null
if [ $? -eq 0 ]; then
    echo "found!"
else
    echo "export JAVA_HOME=/usr/local/jdk
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile
java -version
fi
}
jdk_config



#useradd elsearch -g elsearch -p elasticsearch

