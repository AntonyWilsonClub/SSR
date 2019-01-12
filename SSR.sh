#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Install_SSR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/SSR_Install.sh
chmod +x SSR_Install.sh
./SSR_Install.sh
}

Install_ServerStatus(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ServerStatus_Install.sh
chmod +x ServerStatus_Install.sh
./ServerStatus_Install.sh
}

Install_BBR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/BBR_Install.sh
chmod +x BBR_Install.sh
./BBR_Install.sh
}

Uninstall_SSR(){
./SRR.sh uninstall}

start_menu(){
clear
echo -e "
 ${Green_font_prefix}1.${Font_color_suffix} 安装 SSR
 ${Green_font_prefix}2.${Font_color_suffix} 安装 SeverStatus 
 ${Green_font_prefix}3.${Font_color_suffix} 安装 BBR
 ${Green_font_prefix}4.${Font_color_suffix} 卸载 SSR"
 echo
read -p " 请输入数字 [1-4]:" num
case "$num" in
	1)
	Install_SSR
	;;
	2)
	Install_ServerStatus
	;;
	3)
	Install_ServerStatus
	;;
	4)
	Uninstall_SSR
	;;
	*)
	clear
	echo -e "${Error}:请输入正确数字 [1-4]"
	sleep 5s
	start_menu
	;;
  esac
}

start_menu
