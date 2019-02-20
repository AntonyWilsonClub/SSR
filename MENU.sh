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
cd /root/shadowsocksr
pip install -r requestment.txt
echo "安装成功，即将进入后端配置"
sleep 5s
vi user-config.json
vi usermysql.json
echo "配置成功，即将安装BBR_Plus加速"
sh logrun.sh
sleep 5s
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
sleep 5s

#宝塔面板安装
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh

#重启
stty erase '^H' && read -p "是否现在重启服务器? [Y/N] :" yn
[ -z "${yn}" ] && yn="y"
if [[ $yn == [Yy] ]]; then
echo -e "${Info} 服务器重启中..."
reboot
else
Start_MENU
fi
}
#BBRPlus状态
BBRPlus_Status(){
	kernel_version=`uname -r | awk -F "-" '{print $1}'`
	kernel_version_full=`uname -r`
	if [[ ${kernel_version_full} = "4.14.91-bbrplus" ]]; then
		kernel_status="BBRplus"
	else 
		kernel_status="noinstall"
	fi
	if [[ ${kernel_status} == "BBRplus" ]]; then
		run_status=`grep "net.ipv4.tcp_congestion_control" /etc/sysctl.conf | awk -F "=" '{print $2}'`
		if [[ ${run_status} == "bbrplus" ]]; then
			run_status=`lsmod | grep "bbrplus" | awk '{print $1}'`
			if [[ ${run_status} == "tcp_bbrplus" ]]; then
				run_status="BBRplus启动成功"
			else 
				run_status="BBRplus启动失败"
			fi
		else 
			run_status="未安装加速模块"
		fi
	fi
}
#SSR后端管理
SSR(){
clear
echo "
   SSR后端管理
 ---------------
 ${Green_font_prefix}1.${Font_color_suffix} 启动
 ${Green_font_prefix}2.${Font_color_suffix} 停止
 ${Green_font_prefix}3.${Font_color_suffix} 配置节点
 ${Green_font_prefix}4.${Font_color_suffix} 配置服务
 ${Green_font_prefix}5.${Font_color_suffix} 查看日志
 ${Green_font_prefix}6.${Font_color_suffix} 返回上一层
 ${Green_font_prefix}7.${Font_color_suffix} 返回主菜单"
 echo
read -p " 请输入数字 [1-7]:" num
case "$num" in
	1)
	cd /root/shadowsocksr
	sh logrun.sh
	echo "启动成功"
	sleep 3s
	SSR
	;;
	2)
	cd /root/shadowsocksr
	sh stop.sh
	echo "停止成功"
	sleep 3s
	SSR
	;;
	3)
	cd /root/shadowsocksr
	vi user-config.json
	SSR
	;;
	4)
	cd /root/shadowsocksr
	vi usermysql.json
	SSR
	;;
	5)
	cd /root/shadowsocksr
	sh tail.sh
	sleep 3s
	SSR
	;;
	6)
	Service
	;;
	7)
	Start_MENU
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-7]"
	sleep 3s
	SSR
	;;
  esac
}
#BBRPlus管理
BBRPlus(){
clear
echo "
   BBRPlus管理
 ---------------
 ${Green_font_prefix}1.${Font_color_suffix} 停用BBRPlus
 ${Green_font_prefix}2.${Font_color_suffix} 返回上一层
 ${Green_font_prefix}3.${Font_color_suffix} 返回主菜单"
echo
BBRPlus_Status
	if [[ ${kernel_status} == "noinstall" ]]; then
		echo -e " 当前状态: ${Green_font_prefix}未安装${Font_color_suffix} 加速内核 ${Red_font_prefix}请先安装内核${Font_color_suffix}"
	else
		echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} ${_font_prefix}${kernel_status}${Font_color_suffix} 加速内核 , ${Green_font_prefix}${run_status}${Font_color_suffix}"
		
	fi
 echo
read -p " 请输入数字 [1-3]:" num
case "$num" in
	1)
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
	clear
	echo -e "${Info}:清除加速完成。"
	sleep 3s
	BBRPlus
	;;
	2)
	Service
	;;
	3)
	Start_MENU
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-3]"
	sleep 3s
	BBRPlus
	;;
  esac
}
#宝塔面板管理
BTPanle(){
clear
echo "
    宝塔面板管理
 -----------------
 ${Green_font_prefix}1.${Font_color_suffix} 启动
 ${Green_font_prefix}2.${Font_color_suffix} 停止
 ${Green_font_prefix}3.${Font_color_suffix} 重启
 ${Green_font_prefix}4.${Font_color_suffix} 卸载
 ${Green_font_prefix}5.${Font_color_suffix} 关闭面板SSL
 ${Green_font_prefix}6.${Font_color_suffix} 清理登陆限制
 ${Green_font_prefix}7.${Font_color_suffix} 删除域名绑定面板
 ${Green_font_prefix}8.${Font_color_suffix} 返回上一层
 ${Green_font_prefix}9.${Font_color_suffix} 返回主菜单"
 echo 
read -p " 请输入数字 [1-9]:" num
case "$num" in
	1)
	/etc/init.d/bt start
	sleep 3s
	BTPanle
	;;
	2)
	/etc/init.d/bt stop
	sleep 3s
	BTPanle
	;;
	3)
	/etc/init.d/bt restart
	sleep 3s
	BTPanle
	;;
	4)
	/etc/init.d/bt stop && chkconfig --del bt && rm -f /etc/init.d/bt && rm -rf /www/server/panel
	sleep 3s
	BTPanle
	;;
	5)
	rm -f /www/server/panel/data/ssl.pl && /etc/init.d/bt restart
	sleep 3s
	BTPanle
	;;
	6)
	rm -f /www/server/panel/data/*.login
	sleep 3s
	BTPanle
	;;
	7)
	rm -f /www/server/panel/data/domain.conf
	sleep 3s
	BTPanle
	;;
	8)
	Service
	;;
	9)
	Start_MENU
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-9]"
	sleep 3s
	BTPanle
	;;
  esac
}
#服务管理
Service(){
clear
echo "
    服务管理
 --------------
 ${Green_font_prefix}1.${Font_color_suffix} SSR后端管理
 ${Green_font_prefix}2.${Font_color_suffix} BBRPlus管理
 ${Green_font_prefix}3.${Font_color_suffix} 宝塔面板管理
 ${Green_font_prefix}4.${Font_color_suffix} 返回主菜单"
 echo
read -p " 请输入数字 [1-4]:" num
case "$num" in
	1)
	SSR
	;;
	2)
	BBRPlus
	;;
	3)
	BTPanle
	;;
	4)
	Start_MENU
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-4]"
	sleep 3s
	Service
	;;
  esac
}

#卸载脚本
Uninstall(){
rm -f *.sh
echo "卸载成功"
}

#退出脚本
Esc(){
echo "退出成功"
}


#开始菜单
Start_MENU(){
clear
echo "
 一键安装管理脚本 V2.65
  ${Green_font_prefix}1.${Font_color_suffix} 一 键 安 装
  ${Green_font_prefix}2.${Font_color_suffix} 服 务 管 理
  ${Green_font_prefix}3.${Font_color_suffix} 更 新 脚 本
  ${Green_font_prefix}4.${Font_color_suffix} 卸 载 脚 本
  ${Green_font_prefix}5.${Font_color_suffix} 退 出 脚 本"
 echo
read -p " 请输入数字 [1-5]:" num
case "$num" in
	1)
	Install
	;;
	2)
	Service
	;;
	3)
	wget -N https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/MENU.sh
	chmod +x MENU.sh
	./MENU.sh
	;;
	4)
	Uninstall
	;;
	5)
	Esc
	;;
	*)
	clear
	echo -e "请输入正确数字 [1-5]"
	sleep 3s
	Start_MENU
	;;
  esac
}

Start_MENU
