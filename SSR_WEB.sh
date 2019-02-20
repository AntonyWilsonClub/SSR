yum -y install git unzip
wget https://github.com/ssrpanel/shadowsocksr/archive/master.zip && unzip master && mv shadowsocksr-master shadowsocksr
sudo yum install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \ openssl-devel xz xz-devel libffi-devel gcc readline readline-devel readline-static \ openssl openssl-devel openssl-static sqlite-devel bzip2-devel bzip2-libs
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
cat >> ~/.bashrc << EOF
export PATH="/root/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
source ~/.bashrc
pyenv install 3.7.1
pyenv global 3.7.1
cd shadowsocksr
pip install -r requestment.txt
echo "安装成功"
