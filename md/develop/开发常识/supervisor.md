---
title: supervisor
date: 2020/11/26 15:54:49
toc: true
tags:
- develop
---




进程管理工具，python开发，监控进程状态，异常退出时能自动重启

<!--more-->

#### ubuntu18.04 安装

```bash
sudo apt-get install supervisor
```



#### 文件配置

主文件夹 /etc/supervisor/

* supervisord.conf 主配置文件
* /conf.d/ 放置以.conf结尾的子进程配置文件

##### supervisord.conf

```shell
作者：忠实的码农
链接：https://zhuanlan.zhihu.com/p/63340417
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

[unix_http_server]
file=/home/supervisor/supervisor.sock   ; supervisorctl使用的 socket文件的路径
;chmod=0700                 ; 默认的socket文件权限0700
;chown=nobody:nogroup       ; socket文件的拥有者

[inet_http_server]         ; 提供web管理后台管理相关配置
port=0.0.0.0:9001          ; web管理后台运行的ip地址及端口，绑定外网需考虑安全性 
;username=root             ; web管理后台登录用户名密码
;password=root

[supervisord]
logfile=/var/log/supervisord.log ; 日志文件，默认在$CWD/supervisord.log
logfile_maxbytes=50MB        ; 日志限制大小，超过会生成新文件，0表示不限制
logfile_backups=10           ; 日志备份数量默认10，0表示不备份
loglevel=info                ; 日志级别
pidfile=/home/supervisor/supervisord.pid ; supervisord pidfile; default supervisord.pid              ; pid文件
nodaemon=false               ; 是否在前台启动，默认后台启动false
minfds=1024                  ; 可以打开文件描述符最小值
minprocs=200                 ; 可以打开的进程最小值

[supervisorctl]
serverurl=unix:///home/supervisor/supervisor.sock ; 通过socket连接supervisord,路径与unix_http_server->file配置的一致

[include]
files = supervisor.d/*.conf ;指定了在当前目录supervisor.d文件夹下配置多个配置文件
```



##### *.conf 子进程配置文件

```sh
[program:sboot] ;
[program:xxx] 这里的xxx是指的项目名字
directory = /opt/project  ;
程序所在目录
command =  java -jar springboot-hello-sample.jar ;
程序启动命令
autostart=true ;
是否跟随supervisord的启动而启动
autorestart=true;
程序退出后自动重启,可选值：[unexpected,true,false]，默认为unexpected，表示进程意外杀死后才重启
stopasgroup=true;
进程被杀死时，是否向这个进程组发送stop信号，包括子进程
killasgroup=true;
向进程组发送kill信号，包括子进程
stdout_logfile=/var/log/sboot/supervisor.log;
该程序日志输出文件，目录需要手动创建
stdout_logfile_maxbytes = 50MB;
日志大小
stdout_logfile_backups  = 100;
备份数
```



#### 常用命令



首先运行主配置文件

```bash
supervisord -c /etc/supervisor/supervisord.conf
```

```
supervisorctl 
展示已配置好的项目信息  进入交互式
start/stop/restart  项目名称  
来简单控制项目的启停
update # 更新配置文件
reload # 重新启动配置的程序
stop all # 停止全部管理进程
status # 查看运行状态
```

也可以在浏览器端 http://ip_host:9000 输入账户密码访问





####  Supervisor 起es服务碰到的问题

http://www.likegirl.cn/2019/03/01/2019-03-01-supervisor-elasticsearch-error-max-file-descriptor/ 已解决