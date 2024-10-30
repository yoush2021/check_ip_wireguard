#/bin/bash

# 域名解析获取
Domain="ddns.domain.com"
# 协议版本 4 或者6
DomainVersion=6
# wireguard 网卡名称（一般是wireguard配置文件名）
NetCard="wg0"
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
	dns_status=0
	# 协议版本4
	if [[ $DomainVersion == 4 ]];then
		for (( i=1; i<=$Address4; i++ ))
		do
			Inet4="$(ip a | grep 'inet' | grep -v 'inet6' | cut -d ' ' -f6 | cut -d '/' -f1 | awk NR=="$i"'{print $1}' )"
			if [[ "$Domaindns4" == "$Inet4" ]];then
				echo $time "   IPV4 解析无变化"
				dns_status=1
			fi
		done
	
	# 协议版本6
	elif [[ $DomainVersion == 6 ]];then
		for (( i=1; i<=$Address6; i++ ))
		do	
			Inet6="$(ip a | grep 'inet6' | grep '240' | cut -d '/' -f1 | cut -d ' ' -f6 | awk NR=="$i"'{print $1}' )"
		
			if [[ "$Domaindns6" == "$Inet6" ]];then
				echo $time "   IPV6 解析无变化"	
				dns_status=1
				break
			fi
		done
	fi
	if [[ "$DnsStatus" -eq 0 ]];then
		# 重启wireguard
		systemctl restart --force wg-quick@"$NetCard".service
		echo $time "   wg 服务重新启动中..."
		WGStatus
	
	fi
		

}
# wireguard 状态查询
function WGStatus (){
	wg_status=$(systemctl status wg-quick@"$NetCard".service | awk '{print $1,$2,$3}' | grep "Active" | cut -d ':' -f2 | sed 's/(/_/g' | sed 's/)//g' | sed '
	s/ //g')
	if [[ "$wg_status" == "active_exited" ]];then
		echo $time "   wg 服务启动运行中！"
	elif [[ "$wg_status" == "inactive_dead" ]];then
		echo $time "   wg 服务已停止！"
	
	#elif [[ "$wg_status" == "failed" ]];then
	else
		echo $wg_status
		echo $time "   状态异常！！！"
	fi


}
echo " ____________ "$time" _____________ "
DomainDNS
CheckIp
echo " "
