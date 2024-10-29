#/bin/bash

# 域名解析获取
Domain="ddns.domain.com"
# 协议版本 4 或者6
DomainVersion=6
# IP数量
Address4="$(ip a | grep 'inet' | grep -v 'inet6' | cut -d ' ' -f6 | cut -d '/' -f1 | wc -l )"
Address6="$(ip a | grep 'inet6' | grep '24' | cut -d ' ' -f6 | cut -d '/' -f1 | wc -l)"
time=$( date )

function DomainDNS (){
	# 检查工具否则安装
	if [[ -z $(which dig) ]];then
		# 安装dig域名解析工具
		apt update -y && apt upgrade -y
		apt install dnsutils -y
	fi

	if [[ $DomainVersion == 4 ]];then
		Domaindns4="$( dig "$Domain" A | awk '{print $5}' | grep "\.")"
	elif [[ $DomainVersion == 6 ]];then
		Domaindns6="$(dig "$Domain" AAAA | awk '{print $5}' | grep "240")"
	fi

}
function CheckIp (){
	DnsStatus=0
	# 协议版本4
	if [[ $DomainVersion == 4 ]];then
		for (( i=1; i<=$Address4; i++ ))
		do
			Inet4="$(ip a | grep 'inet' | grep -v 'inet6' | cut -d ' ' -f6 | cut -d '/' -f1 | awk NR=="$i"'{print $1}' )"
			if [[ "$Domaindns4" == "$Inet4" ]];then
				echo $time "   IPV4 解析无变化"
				DnsStatus=1
			fi
		done
	
	# 协议版本6
	elif [[ $DomainVersion == 6 ]];then
		for (( i=1; i<=$Address6; i++ ))
		do	
			Inet6="$(ip a | grep 'inet6' | grep '240' | cut -d '/' -f1 | cut -d ' ' -f6 | awk NR=="$i"'{print $1}' )"
		
			if [[ "$Domaindns6" == "$Inet6" ]];then
				echo $time "   IPV6 解析无变化"	
				DnsStatus=1
				break
			fi
		done
	fi
	if [[ "$DnsStatus" -eq 0 ]];then
		# 重启wireguard
		wg-quick down wg0
		echo $time "   wg 服务停止！"
		wg-quick up wg0
		echo $time "   wg 服务启动！"

	fi
		

}

DomainDNS
CheckIp
