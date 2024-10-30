# check_ip_wireguard
一个支持ipv4和ipv6的wireguard服务检查脚本

### 食用方法

##### 1. 将脚本文件克隆到设备上
```
git clone https://github.com/yoush2021/check_ip_wireguard.git
```

##### 2. 进入克隆的github文件夹
```
cd check_ip_wireguard
```

##### 3. 编辑脚本
```   
vim check_ip_wireguard.sh
```
   
##### 4. Domain="ddns.domain.com" 更改为你的域名
```
:%s/ddns.domain.com/你的域名/g
```

##### 5. DomainVersion=6  更改为你需要用的IP协议版本（4 or 6）

```
:%s/DomainVersion=6/DomainVersion=4 or 6/g
```


##### 6. 保存配置文件
```
:wq
```

##### 7. 为脚本增加运行权限
```
chmod +x check_ip_wireguard.sh
```

##### 8. 添加定时任务
```
crontab -e
```
   
##### 9. 将两行代码添加到定时文件尾部
``` 
# 每5分钟检查一次；路径可以换成你脚本的位置(~/check_ip_wireguard/check_ip_wireguard.sh)
*/5 * * * * /bin/bash ~/check_ip_wireguard/check_ip_wireguard.sh >> ~/.log/wg_check.log 
# 每一周清理一次日志
* * * * 6 /bin/bash : > ~/.log/wg_check.log
```
   
##### 10. 查看日志命令
```
cat ~/.log/wg_check.log
```


