#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Install_SSR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/SSR.sh
chmod +x SSR.h
./SSR.h
}

Install_ServerStatus(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR-Status/master/ServerStatus.sh
chmod +x ServerStatus.sh
./ServerStatus.sh
}

Install_BBR(){
wget https://raw.githubusercontent.com/AntonyWilsonClub/BBR/master/BBR.sh
chmod +x BBR.sh
./BBR.sh
}

start_menu(){
clear
echo -e "
 ${Green_font_prefix}1.${Font_color_suffix} 安装 SSR
 ${Green_font_prefix}2.${Font_color_suffix} 安装 SeverStatus 
 ${Green_font_prefix}3.${Font_color_suffix} 安装 BBR"
 echo
read -p " 请输入数字 [0-11]:" num
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
  *)
	clear
	echo -e "${Error}:请输入正确数字 [1-3]"
	sleep 5s
	start_menu
	;;
  esac
}

start_menu
