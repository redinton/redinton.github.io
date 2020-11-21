

[TOC]





涉及到的库

* gunicorn web server
* django
* nginx 分发，静态资源处理
* redis 缓存处理
* elasticsearch
* kibana



#### 踩过的坑

##### gunicorn 起服务的ip是 localhost/127.0.0.1 还是 0.0.0.0 还是本机地址ip

* localhost(经过本机的DNS解析后会变成 127.0.0.1)，限于本机访问，
* 本机地址ip的话，能被同网段其他机器访问
* 0.0.0.0 代表本机所有的ip地址

##### 容器之间的网络连接

容器之间可以用类似于局域网的方式连接(容器之间连接的端口就是容器内部的端口，而不是映射到外部的端口)

* 在docker-compose file中定义 networks的方式



```
nginx:
    build: deployment/nginx
    ports:
      - "81:80"
      - "443:443"
    depends_on:
      - web
    restart: always
    networks:
      - web_network

networks:
  web_network:
    driver: bridge
```



通过 sudo docker network ls

```
8e76cd1d1602        bridge              bridge              local
b35689c432eb        dockerelk_elk       bridge              local
c1e8997cf8b7        fasys_default       bridge              local
849837706d9e        fasys_web_network   bridge              local
45ebac5ce86a        host                host                local
eb86ded15530        none                null                local
```

默认情况下 在未指定networks时，所有container会被加入同一个网络