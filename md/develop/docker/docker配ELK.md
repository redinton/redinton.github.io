---
title: docker配ELK
date: 2020/11/26 15:43:31
toc: true
tags:
- docker
---

### Ubuntu 配置docker

#### 配置docker源

[参考](https://www.cnblogs.com/journeyonmyway/p/10318624.html)
<!--more-->

```bash
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
