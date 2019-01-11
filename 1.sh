echo -e "
  ${Green_font_prefix}1.${Font_color_suffix} 安装 ShadowsocksR
  ${Green_font_prefix}2.${Font_color_suffix} 安装 SeverStatus
  ${Green_font_prefix}3.${Font_color_suffix} 安装 BBR加速
 "
	echo && read -e -p "请输入数字 [1-3]：" num
case "$num" in
	1)
	Install_SSR
	;;
	2)
	Install_SeverStatus
	;;
	3)
	Install_BBR
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-3]"
	;;
esac

Install_SSR()
 {
  wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ssr.sh
  chmod +x ssr.sh
  bash ssr.sh
 }

Install_SeverStatus()
 {
  wget https://raw.githubusercontent.com/AntonyWilsonClub/SSR-Status/master/ServerStatus.sh
  chmod +x ServerStatus.sh
  bash ServerStatus.sh
 }

Install_BBR()
 {
  wget https://raw.githubusercontent.com/AntonyWilsonClub/BBR/master/BBR.sh
  chmod +x BBR.sh
  ./BBR.sh
 }
