





echo "---------------------------------------------------------------------------------------------------------------------"


cat << EOF >> /etc/bashrc
export LANG="en_US.UTF-8"
EOF

yum install -y bash-completion && yum install -y bash-completion-extras.noarch
yum install -y git


yum install python-setuptools && easy_install pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master

echo "init finish"

