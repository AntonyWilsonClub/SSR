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
#安装SSR
libsodium_file="libsodium-stable"
libsodium_url="https://github.com/AntonyWilsonClub/SSR/raw/master/LATEST.tar.gz"
shadowsocks_r_file="shadowsocksr-3.2.2"
shadowsocks_r_url="https://github.com/AntonyWilsonClub/SSR/raw/master/shadowsocksr-3.2.2.tar.gz"

#Current folder
cur_dir=`pwd`
# Stream Ciphers
ciphers=(
none
aes-256-cfb
aes-192-cfb
aes-128-cfb
aes-256-cfb8
aes-192-cfb8
aes-128-cfb8
aes-256-ctr
aes-192-ctr
aes-128-ctr
chacha20-ietf
chacha20
salsa20
xchacha20
xsalsa20
rc4-md5
)

# Protocol
protocols=(
origin
verify_deflate
auth_sha1_v4
auth_sha1_v4_compatible
auth_aes128_md5
auth_aes128_sha1
auth_chain_a
auth_chain_b
auth_chain_c
auth_chain_d
auth_chain_e
auth_chain_f
)
# obfs
obfs=(
plain
http_simple
http_simple_compatible
http_post
http_post_compatible
tls1.2_ticket_auth
tls1.2_ticket_auth_compatible
tls1.2_ticket_fastauth
tls1.2_ticket_fastauth_compatible
)
# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
fi
echo "请设置ShadowsocksR 密码:"
read -p "(默认密码: antonywilson.club):" shadowsockspwd
[ -z "${shadowsockspwd}" ] && shadowsockspwd="antonywilson.club"
echo
echo "---------------------------"
echo "密码 = ${shadowsockspwd}"
echo "---------------------------"
echo
# Set ShadowsocksR config port
while true
do
echo -e "请设置ShadowsocksR 端口:[1-65535]"
read -p "(默认端口: 2048):" shadowsocksport
[ -z "${shadowsocksport}" ] && shadowsocksport=2048
expr ${shadowsocksport} + 1 &>/dev/null
if [ $? -eq 0 ]; then
if [ ${shadowsocksport} -ge 1 ] && [ ${shadowsocksport} -le 65535 ] && [ ${shadowsocksport:0:1} != 0 ]; then
echo
echo "---------------------------"
echo "端口 = ${shadowsocksport}"
echo "---------------------------"
echo
break
fi
fi
echo -e "[${red}Error${plain}]请输入正确的端口:[1-65535]"
done

# Set shadowsocksR config stream ciphers
while true
do
echo -e "请选择ShadowsocksR 加密方式:"
for ((i=1;i<=${#ciphers[@]};i++ )); do
hint="${ciphers[$i-1]}"
echo -e "${green}${i}${plain}) ${hint}"
done
read -p "默认加密方式: ${ciphers[1]}:" pick
[ -z "$pick" ] && pick=2
expr ${pick} + 1 &>/dev/null
if [ $? -ne 0 ]; then
echo -e "[${red}Error${plain}]请输入数字:"
continue
fi
if [[ "$pick" -lt 1 || "$pick" -gt ${#ciphers[@]} ]]; then
echo -e "[${red}Error${plain}]请输入1至${#ciphers[@]}的数字:"
continue
fi
shadowsockscipher=${ciphers[$pick-1]}
echo
echo "---------------------------"
echo "加密方式 = ${shadowsockscipher}"
echo "---------------------------"
echo
break
done

# Set shadowsocksR config protocol
while true
do
echo -e "请选择ShadowsocksR 协议:"
for ((i=1;i<=${#protocols[@]};i++ )); do
hint="${protocols[$i-1]}"
echo -e "${green}${i}${plain}) ${hint}"
done
read -p "默认协议: ${protocols[4]}:" protocol
[ -z "$protocol" ] && protocol=5
expr ${protocol} + 1 &>/dev/null
if [ $? -ne 0 ]; then
echo -e "[${red}Error${plain}]请输入数字:"
continue
fi
if [[ "$protocol" -lt 1 || "$protocol" -gt ${#protocols[@]} ]]; then
echo -e "[${red}Error${plain}]请输入1至${#protocols[@]}的数字:"
continue
fi
shadowsockprotocol=${protocols[$protocol-1]}
echo
echo "---------------------------"
echo "协议 = ${shadowsockprotocol}"
echo "---------------------------"
echo
break
done

# Set shadowsocksR config obfs
while true
do
echo -e "请选择ShadowsocksR 混淆方式:"
for ((i=1;i<=${#obfs[@]};i++ )); do
hint="${obfs[$i-1]}"
echo -e "${green}${i}${plain}) ${hint}"
done
read -p "默认混淆方式: ${obfs[0]}:" r_obfs
[ -z "$r_obfs" ] && r_obfs=1
expr ${r_obfs} + 1 &>/dev/null
if [ $? -ne 0 ]; then
echo -e "[${red}Error${plain}]请输入数字:"
continue
fi
if [[ "$r_obfs" -lt 1 || "$r_obfs" -gt ${#obfs[@]} ]]; then
echo -e "[${red}Error${plain}]请输入1至${#obfs[@]}的数字:"
continue
fi
shadowsockobfs=${obfs[$r_obfs-1]}
echo
echo "---------------------------"
echo "混淆方式 = ${shadowsockobfs}"
echo "---------------------------"
echo
break
done
   # Install necessary dependencies
    if check_sys packageManager yum; then
        yum install -y python python-devel python-setuptools openssl openssl-devel curl wget unzip gcc automake autoconf make libtool
    elif check_sys packageManager apt; then
        apt-get -y update
        apt-get -y install python python-dev python-setuptools openssl libssl-dev curl wget unzip gcc automake autoconf make libtool
    fi
cd ${cur_dir}
# Download libsodium file
if ! wget --no-check-certificate -O ${libsodium_file}.tar.gz ${libsodium_url}; then
echo -e "[${red}Error${plain}] 下载失败 ${libsodium_file}.tar.gz!"
exit 1
fi
# Download ShadowsocksR file
if ! wget --no-check-certificate -O ${shadowsocks_r_file}.tar.gz ${shadowsocks_r_url}; then
echo -e "[${red}Error${plain}] ShadowsocksR下载失败!"
exit 1
fi
# Download ShadowsocksR init script
if check_sys packageManager yum; then
if ! wget --no-check-certificate https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ssr -O /etc/init.d/shadowsocks; then
echo -e "[${red}Error${plain}] ShadowsocksR配置文件下载失败!"
exit 1
fi
elif check_sys packageManager apt; then
if ! wget --no-check-certificate https://raw.githubusercontent.com/AntonyWilsonClub/SSR/master/ssr-bebian -O /etc/init.d/shadowsocks; then
echo -e "[${red}Error${plain}] ShadowsocksR配置文件下载失败!"
exit 1
fi
fi
cat > /etc/shadowsocks.json<<-EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"[::]",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":120,
    "method":"${shadowsockscipher}",
    "protocol":"${shadowsockprotocol}",
    "protocol_param":"",
    "obfs":"${shadowsockobfs}",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
EOF
systemctl status firewalld > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            default_zone=$(firewall-cmd --get-default-zone)
            firewall-cmd --permanent --zone=${default_zone} --add-port=${shadowsocksport}/tcp
            firewall-cmd --permanent --zone=${default_zone} --add-port=${shadowsocksport}/udp
            firewall-cmd --reload
        else
            echo -e "[${yellow}Warning${plain}] 防火墙未安装或未启动, 请启用端口 ${shadowsocksport} ."
        fi
# Install libsodium
    if [ ! -f /usr/lib/libsodium.a ]; then
        cd ${cur_dir}
        tar zxf ${libsodium_file}.tar.gz
        cd ${libsodium_file}
        ./configure --prefix=/usr && make && make install
        if [ $? -ne 0 ]; then
            echo -e "[${red}Error${plain}] libsodium install failed!"
            install_cleanup
            exit 1
        fi
    fi

    ldconfig
    # Install ShadowsocksR
    cd ${cur_dir}
    tar zxf ${shadowsocks_r_file}.tar.gz
    mv ${shadowsocks_r_file}/shadowsocks /usr/local/
    if [ -f /usr/local/shadowsocks/server.py ]; then
        chmod +x /etc/init.d/shadowsocks
        if check_sys packageManager yum; then
            chkconfig --add shadowsocks
            chkconfig shadowsocks on
        elif check_sys packageManager apt; then
            update-rc.d -f shadowsocks defaults
        fi
        /etc/init.d/shadowsocks start

        clear
        echo
        echo -e "恭喜,ShadowsocksR 安装完成!"
        echo -e "服务器地址 :  $(get_ip)"
        echo -e "服务器端口 :  ${shadowsocksport}"
        echo -e "服务器密码 :  ${shadowsockspwd}"
        echo -e "服务器协议 :  ${shadowsockprotocol}"
        echo -e "服务器混淆 :  ${shadowsockobfs}"
        echo -e "服务器加密 :  ${shadowsockscipher}"
        echo -e 
        echo
    else
        echo "ShadowsocksR 安装失败"
        cd ${cur_dir}
        rm -rf ${shadowsocks_r_file}.tar.gz ${shadowsocks_r_file} ${libsodium_file}.tar.gz ${libsodium_file}
        exit 1
fi
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
echo -e "安装成功！BBRplus将在重新启动后运行！"
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
  一键安装管理脚本 V2.11
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
