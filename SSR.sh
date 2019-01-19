#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#安装SSR服务
Install_SSR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/SSR_Install.sh
chmod +x SSR_Install.sh
./SSR_Install.sh
}

#安装服务器监控服务
Install_ServerStatus(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ServerStatus_Install.sh
chmod +x ServerStatus_Install.sh
./ServerStatus_Install.sh
}

#安装加速服务
Install_BBR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/BBR_Install.sh
chmod +x BBR_Install.sh
./BBR_Install.sh
}

#安装宝塔面板
Install_BT(){
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh
}

#卸载脚本
Uninstall_SH(){
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
./SSR_Install.sh uninstall
echo "卸载成功"
}

#开始菜单
start_menu(){
clear
echo -e "
  一键安装管理脚本 V1.00
 ${Green_font_prefix}1.${Font_color_suffix} BBR   加 速  配置菜单 
 ${Green_font_prefix}2.${Font_color_suffix} 状 态 监 控  配置菜单 
 ${Green_font_prefix}3.${Font_color_suffix} 一 键 安 装  S S R
 ${Green_font_prefix}4.${Font_color_suffix} 一 键 安 装  宝塔面板
 ${Green_font_prefix}5.${Font_color_suffix} 一 键 卸 载  S S R
 ${Green_font_prefix}6.${Font_color_suffix} 一 键 卸 载  脚本
 ${Green_font_prefix}7.${Font_color_suffix} 退 出 脚 本"
 echo
read -p " 请输入数字 [1-7]:" num
case "$num" in
	1)
	Install_BBR
	;;
	2)
	Install_ServerStatus
	;;
	3)
	Install_SSR
	;;
	4)
	Install_BT
	;;
	5)
	Uninstall_SSR
	;;
	6)
	Uninstall_SH
	;;
	7)
	Exit_SH
	;;
	*)
	start_menu
	;;
  esac
}

start_menu
