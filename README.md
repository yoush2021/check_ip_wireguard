# check_ip_wireguard
一个支持ipv4和ipv6的wireguard服务检查脚本

### 食用方法
```
    1. git clone https://github.com/yoush2021/check_ip_wireguard.git
    2. cd check_ip_wireguard
    3. vim check_ip_wireguard.sh
    4. Domain="ddns.domain.com" 更改为你的域名
    5. DomainVersion=6  更改为你需要用的IP协议版本（4 or 6）
    6. 保存文件，并添加定时命令
    7. crontab -e
    8. */5 * * * * /bin/bash /opt/shell/check_ip_wireguard.sh >> ~/.log/wg_check.log 
    9. 添加第8条每5分钟执行的命令，然后保存。
```


