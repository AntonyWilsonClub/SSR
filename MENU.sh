#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#安装环境
Install_Service(){
yum undate
yum -y install wget git unzip
echo "环境安装成功"
sleep 2s
start_menu
}

#安装SSR+BBR_Plus加速+宝塔面板
Install_SSR(){
kernel_version="4.14.91"
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
echo -e "BBRplus启动成功！"
}

#安装加速服务
Install_BBR(){
rm -f BBR_Install.sh
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/BBR_Install.sh
chmod +x BBR_Install.sh
./BBR_Install.sh
}

#安装宝塔面板
Install_BT(){
rm -f install_6.0.sh
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh
}

#SSR管理
SSR_MENU(){
clear
echo -e "
 ${Green_font_prefix}1.${Font_color_suffix} 启动  S S R
 ${Green_font_prefix}2.${Font_color_suffix} 停止  S S R
 ${Green_font_prefix}3.${Font_color_suffix} 重启  S S R
 ${Green_font_prefix}4.${Font_color_suffix} SSR  状  态
 ${Green_font_prefix}5.${Font_color_suffix} 返回主菜单"
  echo
read -p " 请输入数字 [1-5]:" num
case "$num" in
	1)
	/etc/init.d/shadowsocks start
	sleep 3s
        SSR_MENU
	;;
	2)
	/etc/init.d/shadowsocks stop
	sleep 3s
        SSR_MENU
	;;
	3)
	/etc/init.d/shadowsocks restart
	sleep 3s
        SSR_MENU
	;;
	4)
	/etc/init.d/shadowsocks status
	sleep 3s
        SSR_MENU
	;;
        5)
        ./MENU.sh
        ;;
	*)
	clear
	echo -e "请输入正确数字 [1-5]"
	sleep 3s
	SSR_MENU
	;;
  esac
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

#卸载SSR服务
Uninstall_SSR(){
./SSR.sh uninstall
echo "卸载成功"
}

#开始菜单
start_menu(){
clear
echo -e "
  一键安装管理脚本 V1.12
 ${Green_font_prefix}1.${Font_color_suffix} 一 键 安 装  运行环境
 ${Green_font_prefix}2.${Font_color_suffix} 一 键 安 装  S S R+BBR_Plus加速+宝塔面板
 ${Green_font_prefix}3.${Font_color_suffix} 一 键 安 装  SSR后端+BBR_Plus加速+宝塔面板
 ${Green_font_prefix}4.${Font_color_suffix} 服 务 管 理
 ${Green_font_prefix}5.${Font_color_suffix} 一 键 卸 载  脚本
 ${Green_font_prefix}6.${Font_color_suffix} 退 出 脚 本"
 echo
read -p " 请输入数字 [1-6]:" num
case "$num" in
	1)
	Install_Service
	;;
	2)
	Install_SSR
	;;
	3)
	Install_BBR
	;;
	4)
	Install_ServerStatus
	;;
	5)
	SSR_MENU
	;;
	6)
	Uninstall_SSR
	;;
	7)
	Uninstall_SH
	;;
	8)
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
