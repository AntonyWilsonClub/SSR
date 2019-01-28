#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#安装SSR服务
Install_SSR(){
rm -f SSR.sh
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/SSR.sh
chmod +x SSR.sh
./SSR.sh
}

#安装服务器监控服务
Install_ServerStatus(){
rm -f ServerStatus_Install.sh
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ServerStatus_Install.sh
chmod +x ServerStatus_Install.sh
./ServerStatus_Install.sh
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
 ${Green_font_prefix}1.${Font_color_suffix} 一 键 安 装  S S R
 ${Green_font_prefix}2.${Font_color_suffix} 一 键 安 装  宝塔面板 
 ${Green_font_prefix}3.${Font_color_suffix} B B R 加 速  管理菜单
 ${Green_font_prefix}4.${Font_color_suffix} 状 态 监 控  管理菜单
 ${Green_font_prefix}5.${Font_color_suffix} S   S   R    服务管理
 ${Green_font_prefix}6.${Font_color_suffix} 一 键 卸 载  S S R
 ${Green_font_prefix}7.${Font_color_suffix} 一 键 卸 载  脚本
 ${Green_font_prefix}8.${Font_color_suffix} 退 出 脚 本"
 echo
read -p " 请输入数字 [1-8]:" num
case "$num" in
	1)
	Install_SSR
	;;
	2)
	Install_BT
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
