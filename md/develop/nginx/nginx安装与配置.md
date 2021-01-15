---
title: nginx安装与配置
date: 2020/12/02 17:43:03
toc: true
tags:
- nginx
---



#### 安装

```
sudo apt-get install nginx
```

安装完后，直接在浏览器端用 ip: port(默认80) 来访问

#### 文件构成

1. `conf.d`：用户自己定义的conf配置文件
2. `sites-available`：系统默认设置的配置文件
3. `sites-enabled`：由`sites-available`中的配置文件转换生成
4. `nginx.conf`：汇总以上三个配置文件的内容，同时配置我们所需要的参数
5. 错误日志文件 ： /var/log/nginx/error.log
6. 访问日志文件 ：/var/log/nginx/access.log

##### 配置

在部署需要的web服务时，我们可以拷贝`sites-enabled`中的`default`文件到conf.d并且修改名字为`**.conf`,然后进行配置

```sh
server {
    #服务启动时监听的端口
    listen 80 default_server;
    #服务启动时文件加载的路径
    root /var/www/html/wordpress;
    #默认加载的第一个文件
    index index.php index.html index.htm index.nginx-debian.html;
    #页面访问域名，如果没有域名也可以填写_
    server_name www.xiexianbo.xin;
    ## 访问日志文件路径名
    access_log /var/log/nginx/access.log
    ## 访问日志文件错误路径名; 
	error_log /var/log/nginx/error.log;

    location / {
        #页面加载失败后所跳转的页面
        try_files $uri $uri/ =404;
    }
    
    # 处理静态文件/favicon.ico:
    location /favicon.ico {
        root /srv/awesome/www;
    }

    # 处理静态资源:
    location ~ ^\/static\/.*$ {
        root /srv/awesome/www;
    }
    
    #server其他配置
    location /zrlog{ #访问路径可以是正则
        proxy_pass http://域名或ip地址:端口/zrlog;
        #location其他配置
    }
    
    location /jlwy{
        proxy_pass http://域名或ip地址:端口/jlwy;
        #location其他配置
    }
    
    # 动态请求转发到9000端口:
    location / {
        proxy_pass       http://127.0.0.1:9000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

只想通过域名访问不拼接任何东西，location使用 /进行匹配，需要注意的是proxy_pass映射的url必须本身就是tomcat的根项目（根项目的配置可以通过替换ROOT文件或者修改server.xml来设置



#### 配置站点

在conf.d下生成 **.conf 的配置文件。

* 有些教程提到要建立软连接(sudo ln -s src dst), 但其实不用，因为在nginx.conf配置文件里已经include了conf.d目录下的 ***.conf 配置文件，所以不用把/conf.d/ ..conf 软连接到 sites-enable

```
默认已经有一个站点了,就是defalt,在sites-available里面有
一个default文件,就是默认站点的配置,servername是localhost
不建议直接修改这个默认站点,我们可以复制一个:

cd /etc/nginx/sites-available/
cp default web1.com

别忘了建立个软连接,不然新站点不会生效滴:
ln -s /etc/ngix/sites-available/web1.com /etc/nginx/sites-enabled/web1.com

现在就开始修改我们的新站点配置:
vim web1.com

找到21行的这句配置(:set nu可以显示行号):
listen 80 default_server;

改成:
listen 80; //注意:default_server是设置默认站点的,我们新建立的站点不需要

找到24行:
root /usr/share/nginx/html

改成:
root /your server path  (写你自己的网站目录)

重启nginx服务:
/etc/init.d/nginx restart
```



```shell
windows修改hosts文件:
文件在C:\Windows\System32\drivers\etc\hosts

mac os修改hosts文件
sudo /etc/hosts/

在文件中加入:
nginx服务器的ip 新站点的域名
192.168.1.222 web1.com
```



```
sudo nginx -t 测试配置有无问题
sudo service nginx restart 重启nginx

```



#### 负载均衡

```
nginx服务器 192.168.1.100
web服务器1  192.168.1.101
web服务器2  192.168.1.102
```

修改配置文件

```
vim /etc/nginx/sites-available/default

upstream a.com {
  server  192.168.1.101:80;  #有多少个服务器就添加多少个ip
  server  192.168.1.102:80;
}

server{
    listen 80;
    server_name a.com;
    location / {
        proxy_pass         http://a.com;   #这个地址一定是上面定义的负载均衡的名字
        proxy_set_header   Host             $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    }
```

> nginx**主服务器也可以当做一个负载均衡服务器**,但是由于**80端口已经给负载均衡食用了**,所有如果我们还使用80端口的话,就会造成一个死循环,我们可以再给主服务器添加一个服务器,并使用不同的8080端口,这样,主服务器也可以当做一个负载均衡的子服务器了,不会造成资源的浪费



```
server{
    listen 8080;
    server_name a.com;
    index index.html;
    root /data0/htdocs/www;
}

upstream a.com {
  server  192.168.5.126:80;
  server  192.168.5.27:80;
  server  127.0.0.1:8080;
}
```



##### 轮询

每个请求按照时间顺序逐一分配到后端服务器，如果后端服务起down掉，能自动剔除



##### weight

指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况

```
 upstream bakend {
     server 192.168.159.10 weight=10;
     server 192.168.159.11 weight=10;
 }
```



##### ip_hash

每个请求按访问ip的hash结果分配，这样**每个访客固定访问一个后端服务器，可以解决session的问**题。

```undefined
 upstream resinserver{
     ip_hash;
     server 192.168.159.10:8080;
     server 192.168.159.11:8080;
 }
```

##### fair(第三方)

后端服务器的响应时间来分配请求，响应时间短的优先分配。

```undefined
 upstream resinserver{
     server server1;
     server server2;
     fair;
 }
```



url_hash（第三方）

在upstream中加入hash语句，server语句中不能写入weight等其他的参数，hash_method是使用的hash算法



```bash
# 定义负载均衡设备的Ip及设备状态
upstream resinserver{
    ip_hash;
    server 127.0.0.1:8000 down;
    server 127.0.0.1:8080 weight=2;
    server 127.0.0.1:6801;
    server 127.0.0.1:6802 backup;
}

在需要使用负载均衡的server中增加
proxy_pass http://resinserver/;

每个设备的状态设置为:
1.down 表示单前的server暂时不参与负载
2.weight 默认为1.weight越大，负载的权重就越大。
3.max_fails ：允许请求失败的次数默认为1.当超过最大次数时，返回proxy_next_upstream 模块定义的错误
4.fail_timeout:max_fails次失败后，暂停的时间。
5.backup： 其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻。

nginx支持同时设置多组的负载均衡，用来给不用的server来使用。

client_body_in_file_only 设置为On 可以讲client post过来的数据记录到文件中用来做debug
client_body_temp_path 设置记录文件的目录 可以设置最多3层目录
location 对URL进行匹配.可以进行重定向或者进行新的代理 负载均衡
```





[nginx使用指南](https://www.jianshu.com/p/fd25a9c008a0)