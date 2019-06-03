



echo "---------------------------------------------------------------------------------------------------------------------"

function bashrc_config() {
egrep 'LANG="en_US.UTF-8"' /etc/bashrc >/dev/null
if [ $? -ne 0 ]; then
cat << EOF >> /etc/bashrc
export LANG="en_US.UTF-8"
EOF
fi
}
limits_config

yum install -y bash-completion && yum install -y bash-completion-extras.noarch
yum install -y git


yum install -y python-setuptools && easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master

echo "init finish"

