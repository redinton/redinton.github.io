---
title: docker_registry_局部网配置
date: 2020/11/26 15:38:59
toc: true
tags:
- docker,develop
---




#### 创建 Docker Registry

```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
<!--more-->
可以把镜像文件存放在本地的指定路径， 默认是在/var/lib/docker/volumes/ hashid / _data/docker/registry

```
docker run -d \
    -p 5000:5000 \
    -v /opt/data/registry:/var/lib/registry \
    registry
```



可以先给本地的image打tag

```bash
docker tag autocv_test localhost:5000/autocv:20200924   20200924就是tag
```

然后docker images查看 发现两个镜像的tag不一样，但是image_id都是一样的

接着把镜像push到本地的registry 中

``` 
docker push localhost:5000/autocv:20200924
```

从本地的库中pull 镜像

```
docker pull localhost:5000/autocv:20200924
```

#### 创建局域网可用的docker Registry

机的镜像推送操作默认采用的都是 https 协议,为了在局域网内使用 Docker Registry， 我们必须配置 https 版的 Registry 服务器

##### 通过IP地址访问registry

内网环境没有有效的域名，但IP地址固定。 10.127.3.109

##### 创建自签名的证书

缺点: 需要在作为客户端的 docker daemon 中安装这个根证书



一个很隐晦的 openssl 配置问题，当我们使用 IP 地址作为访问服务器的名称时就会碰到。解决的方法也很简单，就是在生成证书的配置文件中指定 subjectAltName 。打开文件 **/etc/ssl/openssl.cnf**，在 [v3_ca] 节点添加配置项：subjectAltName = IP:10.32.2.140

先在当前目录创建 dcerts目录，

```
openssl req \
    -newkey rsa:4096 -nodes -sha256 \
    -keyout dcerts/domain.key \
    -x509 -days 356 \
    -out dcerts/domain.crt
```

会在 dcerts 目录下生成私钥和自签名的证书

##### 运行https版的registry

```
docker run -d -p 5000:5000 \
    --restart=always \
    --name registry \
    -v `pwd`/dstorage:/var/lib/registry \
    -v `pwd`/dcerts:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    registry:2
```

把证书所在的目挂载到了容器的 /certs 目录。然后分别指定了容器的环境变量 REGISTRY_HTTP_TLS_CERTIFICATE 和 REGISTRY_HTTP_TLS_KEY，这两个环境变量会引用我们常见的秘钥文件和证书文件。



##### 配置client端根证书

必须把我们生成的根证书安装到每一个需要访问 Registry 服务器的客户端上。具体做法如下：
把前面生成的证书文件 dcerts/domain.crt 复制到需要访问 Registry 服务器的机器上。放到目录 /etc/docker/certs.d/10.32.2.140:5000/ 中，并重命名为 ca.crt。当然这个目录需要你自己创建。最后重新启动 docker 服务

```bash
sudo systemctl restart docker.service
```





[参考](https://www.cnblogs.com/sparkdev/p/6890995.html)