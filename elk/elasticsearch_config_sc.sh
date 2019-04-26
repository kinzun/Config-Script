

# elasticsearch 配置文件
function es_java_config() {
egrep "^JAVA_HOME" /etc/sysconfig/elasticsearch > /dev/null
if [ $? -ne 0 ]; then
sed  "/#JAVA_HOME/a \JAVA_HOME=/usr/local/jdk" /etc/sysconfig/elasticsearch
fi
}
sysctl_config


function es_config() {
# 注释未注释的行
egrep "^network.host:" /etc/elasticsearch/elasticsearch.yml > /dev/null

if [ $? -ne 0 ]; then
sed -i "s@^[^#]@#&@" /etc/elasticsearch/elasticsearch.yml > /dev/null
#ip a show dev eth1|grep -w inet|awk '{print $2}'|awk -F '/' '{print $1}'
cat << EOF >> /etc/elasticsearch/elasticsearch.yml

cluster.name: ad_ek
node.name: node1
path.data: /elkdata/data
path.logs: /elkdata/logs

bootstrap.memory_lock: false
bootstrap.system_call_filter: true
discovery.zen.ping.unicast.hosts: ["192.168.1.18"]
network.host: 192.168.1.12
http.port: 9200

EOF
fi
}
es_config


chown elasticsearch.elasticsearch /elkdata/ -R