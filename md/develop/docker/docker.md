[TOC]





##### 运行image

```
docker run hello-world
```

```bash
docker run -d -p 80:80 --restart=always  nginx:latest

# 参数说明： 
# run 启动某个镜像 名称就是nginx:latest
# -d 让容器在后台运行
# -p 指定端口映射，宿主机的80端口映射到容器的80端口
# --restart 重启模式，设置 always，每次启动 docker 都会启动 nginx 容器。
```

访问http://localhost:80



##### 进入容器 & kill 容器

```bash
docker exec -it 4591552a4185 bash
# exec 对容器执行某些操作
# -it 让容器可以接受标准输入并分配一个伪tty
# 4591552a4185 是刚刚启动的 nginx 容器唯一标记 通过docker ps 查看
# bash 指定交互的程序为 bash

docker kill 4591552a4185 
```



#####   退出容器

ctrl + D 对容器的直接修改不会持久保存，如果容器被删，数据也会跟着丢失。



#####  数据挂载

每次修改内容都需要手动进入容器，太过繁琐，并且👆提到了，对容器的直接修改不会持久保存，如果容器被删，数据也会跟着丢失。

Docker 提供数据挂载的功能，即可以**指定容器内的某些路径映射到宿主机器上**，修改命令，添加 `-v` 参数，启动新的容器。

```bash
docker run -d -p 80:80  -v ~/docker-demo/nginx-htmls:/usr/share/nginx/html/ --restart=always  nginx:latest
```



#### 删除container

先停止container

```
docker stop container_id
```

再删除container

```
docker rm container_id
```





### Ubuntu 配置docker

#### 配置docker源

[参考](https://www.cnblogs.com/journeyonmyway/p/10318624.html)

```
# 更新源
$ sudo apt update

# 启用HTTPS
$ sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# 添加GPG key
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加稳定版的源
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

#### 安装docker CE

```
# 更新源
$ sudo apt update

# 安装Docker CE
$ sudo apt install -y docker-ce
```

#### 验证docker CE

```
 sudo docker run hello-world
```

#### 安装docker-compose

[参考](https://zhuanlan.zhihu.com/p/34935579)

docke-compose 用法 [参考](https://zhuanlan.zhihu.com/p/34935579)

```
#下载
sudo curl -L https://github.com/docker/compose/releases/download/1.20.0/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
#安装
chmod +x /usr/bin/docker-compose
#查看版本
docker-compose version
```

### Docker 配置 ELK

[参考](https://zhuanlan.zhihu.com/p/138128187)



docker带cuda [数据](https://zhuanlan.zhihu.com/p/83663496)





#### docker 修改配置文件yml后

```bash
 docker-compose build
 docker-compose up -d 创建与启动容器，会重建有变化的服务器（删掉以前建立的容器）

## docker-compose up -d --no-create 如果存在与yaml中描述的容器就会直接启动，不会重建
stop start retart只是针对已存在容器的操作。
```



#### docker es 安装analyzer

https://blog.csdn.net/a243293719/article/details/82021823



