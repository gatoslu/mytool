#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================
#       System Required: CentOS/Debian/Ubuntu
#       Description: Caddy Install
#       Version: 1.0.1
#       Author: Gatoslu
#       Blog: https://gatoslu.xyz/
#=================================================
caddy_file="/usr/local/caddy"
caddy_ver_file="/usr/local/caddy/ver.txt"
caddy_conf_file="/usr/local/caddy/Caddyfile"
Info_font_prefix="\033[32m" && Error_font_prefix="\033[31m" && Info_background_prefix="\033[42;37m" && Error_background_prefix="\033[41;37m" && Font_suffix="\033[0m"

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
check_installed_status(){
	[[ ! -e ${caddy_file} ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 没有安装，请检查 !" && exit 1
}
check_new_ver(){
	#caddy_new_ver=`curl -m 10 -s "https://github.com/mholt/caddy/releases/latest" | perl -e 'while($_=<>){ /\/tag\/(.*)\">redirected/; print $1;}'`
	caddy_new_ver=`wget -qO- https://github.com/mholt/caddy/releases/latest | grep "<title>" | perl -e 'while($_=<>){ /Release (.*) · mholt\/caddy/; print $1;}'`
	[[ -z ${caddy_new_ver} ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 最新版本获取失败 !" && exit 1
}
Download_caddy(){
	mkdir "${caddy_file}" && cd "${caddy_file}"
	if [[ ${bit} == "386" ]||[ ${bit} == "i686" ]]; then
		wget -N "https://github.com/mholt/caddy/releases/download/v${caddy_new_ver}/caddy_linux_386.tar.gz" && caddy_bit="caddy_linux_386"
	elif [[ ${bit} == "x86_64" ]]; then
		wget -N "https://github.com/mholt/caddy/releases/download/v${caddy_new_ver}/caddy_linux_amd64.tar.gz" && caddy_bit="caddy_linux_amd64"
	else
		echo -e "${Error_font_prefix}[错误]${Font_suffix} 不支持 ${bit} !" && exit 1
	fi
	[[ ! -e ${caddy_bit}.tar.gz ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 下载失败 !" && exit 1
	tar zxf ${caddy_bit}.tar.gz && rm -rf ${caddy_bit}.tar.gz && mv ${caddy_bit} caddy
	[[ ! -e ${caddy_file}"/caddy" ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 解压失败或压缩文件错误 !" && exit 1
	chmod +x caddy
	echo "${caddy_new_ver}" > ${caddy_ver_file}
}
Service_caddy(){
	if [[ ${release} = "centos" ]]; then
		if ! wget --no-check-certificate https://softs.pw/Bash/other/caddy_centos -O /etc/init.d/caddy; then
			echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/caddy
		chkconfig --add caddy
		chkconfig caddy on
	else
		if ! wget --no-check-certificate https://softs.pw/Bash/other/caddy_debian -O /etc/init.d/caddy; then
			echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/caddy
		update-rc.d -f caddy defaults
	fi
}
install_caddy(){
	[[ -e ${caddy_file} ]] && echo -e "${Error_font_prefix}[错误]${Font_suffix} 检测到 Caddy 已安装，如需继续，请先卸载 !" && exit 1
	check_sys
	check_new_ver
	Download_caddy
	Service_caddy
	echo && echo -e "Caddy 配置文件：${caddy_conf_file}
	${Info_font_prefix}[信息]${Font_suffix} Caddy 安装完成！" && echo
}
uninstall_caddy(){
	check_installed_status
	check_sys
	echo && echo "确定要卸载 Caddy ? [y/N]"
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		PID=`ps -ef |grep "caddy" |grep -v "grep" |grep -v "init.d" |grep -v "service" |grep -v "caddy_install" |awk '{print $2}'`
		[[ ! -z ${PID} ]] && kill -9 ${PID}
		if [[ ${release} = "centos" ]]; then
			chkconfig --del caddy
		else
			update-rc.d -f caddy remove
		fi
		rm -rf ${caddy_file}
		rm -rf /etc/init.d/caddy
		[[ ! -e ${caddy_file} ]] && echo && echo -e "${Info_font_prefix}[信息]${Font_suffix} Caddy 卸载完成 !" && echo && exit 1
		echo && echo -e "${Error_font_prefix}[错误]${Font_suffix} Caddy 卸载失败 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}
action=$1
[[ -z $1 ]] && action=install
case "$action" in
    install|uninstall)
    ${action}_caddy
    ;;
    *)
    echo "输入错误 !"
    echo "用法: {install|uninstall}"
    ;;
esac
