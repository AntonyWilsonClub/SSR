#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


#安装SSR+BBR_Plus加速+宝塔面板
Install(){
yum undate
yum -y install wget git unzip
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
echo "安装成功，即将进入后端配置"
sleep 3s
vi user-config.json
vi usermysql.json
echo "配置成功，即将安装BBR_Plus加速"
#安装BBR_Plus加速
github="raw.githubusercontent.com/chiakge/Linux-NetSpeed/master"
wget -N --no-check-certificate https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/bbrplus/centos/7/kernel-4.14.91.rpm
yum install -y kernel-4.14.91.rpm
rm -f kernel-4.14.91.rpm
rpm_total=`rpm -qa | grep kernel | grep -v "4.11.8" | grep -v "noarch" | wc -l`
if [ "${rpm_total}" > "1" ]; then
echo -e "检测到 ${rpm_total} 个其余内核，开始卸载..."
for((integer = 1; integer <= ${rpm_total}; integer++)); do
rpm_del=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer}`
echo -e "开始卸载 ${rpm_del} 内核..."
rpm --nodeps -e ${rpm_del}
echo -e "卸载 ${rpm_del} 内核卸载完成，继续..."
done
echo --nodeps -e "内核卸载完毕，继续..."
else
echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
fi
if [ ! -f "/boot/grub2/grub.cfg" ]; then
echo -e "/boot/grub2/grub.cfg 找不到，请检查."
exit 1
fi
grub2-set-default 0
rm -rf bbrmod
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
sed -i '/fs.file-max/d' /etc/sysctl.conf
sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
if [[ -e /appex/bin/serverSpeeder.sh ]]; then
wget --no-check-certificate -O appex.sh https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh && chmod +x appex.sh && bash appex.sh uninstall
rm -f appex.sh
fi
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbrplus" >> /etc/sysctl.conf
sysctl -p
echo -e "安装成功！BBRplus将在重新启动后运行！即将安装宝塔面板！"
sleep 3s
#宝塔面板安装
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh
#重启
stty erase '^H' && read -p "是否现在重启服务器? [Y/N] :" yn
[ -z "${yn}" ] && yn="y"
if [[ $yn == [Yy] ]]; then
echo -e "${Info} 服务器重启中..."
reboot
fi
}





#卸载脚本
Uninstall_SH(){
rm -f MENU.sh
rm -f SSR.sh
rm -f BBR_Install.sh
rm -f ServerStatus_Install.sh
rm -f install_6.0.sh
echo "卸载成功"
}

#退出脚本
Exit_SH(){
echo "退出成功"
}


#开始菜单
start_menu(){
clear
echo -e "
  一键安装管理脚本 V2.21
 ${Green_font_prefix}1.${Font_color_suffix} 一 键 安 装  
 ${Green_font_prefix}2.${Font_color_suffix} 退 出 脚 本"
 echo
read -p " 请输入数字 [1-6]:" num
case "$num" in
	1)
	Install
	;;
	)
	Exit_SH
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-8]"
	sleep 3s
	start_menu
	;;
  esac
}

start_menu
