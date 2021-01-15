---
title: redis基础(-)
date: 2020/11/06 13:27:35
toc: true
tags:
- redis
---






### redis 配置

101服务器上的redis 服务是通过以下命令安装

```bash
sudo apt-get update
sudo apt-get install redis-server
```
<!--more-->
* 启动 redis

  ```
  redis-server
  ```

* 启动客户端

  ```
  redis-cli
  ```

* redis 的配置文件位置

  ```
  /etc/redis/redis.conf
  需要用ip访问的话
  #bind 127.0.0.1 ::1
  protected-mode no
  ```

#### python 操作 redis

[参考连接](https://segmentfault.com/a/1190000014416025)


#### Redis介绍
* Redis是开源的内存中的数据结构存储系统，可以用作：数据库，缓存和消息中间件。
* Redis 内置了复制(replication), LUA脚本，LRU驱动事件(LRU eviction), 事务和不同级别的磁盘持久化(Persistence),并通过Redis 哨兵(Sentinel)和自动分区(Cluster)提供高可用性。




#### redis-cli操作

[设置密码](https://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247487010&idx=2&sn=5ef9a8e55b19f2b2d3e0237356c52347&chksm=eb538b14dc2402023cb03c6cd63fd320d21e0854f8f78fccb0e970b4a04a379ccda25f1da334&scene=21#wechat_redirect)

* `redis-cli` 刚进入的时候是默认db 0， 一共是16个db

* ```bash
  127.0.0.1:6379> select 6
  OK
  127.0.0.1:6379[6]> keys *
  ```

* ```
  127.0.0.1:6379[6]> TYPE rq:workers
  set
  127.0.0.1:6379[6]> smembers rq:workers
  1) "rq:worker:156ffde747464e0f877b940a9d515a7d"
  127.0.0.1:6379[6]> TYPE rq:worker:156ffde747464e0f877b940a9d515a7d
  hash
  127.0.0.1:6379[6]> HGETALL rq:worker:156ffde747464e0f877b940a9d515a7d
   1) "hostname"
   2) "xyu3"
   3) "pid"
   4) "32228"
   5) "birth"
   6) "2020-10-19T03:02:02.953304Z"
   7) "total_working_time"
   8) "1.792315"
   9) "queues"
  10) "cpu_high,cpu_default,cpu_low"
  11) "successful_job_count"
  12) "16"
  13) "last_heartbeat"
  14) "2020-10-19T03:33:46.949179Z"
  15) "state"
  16) "idle"
  127.0.0.1:6379[6]>
  ```

[如何使用redis构建异步任务处理程序](https://my.oschina.net/letiantian/blog/526024)