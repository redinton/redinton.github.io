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


#### 面试问题

* redis是单线程，为什么这么快
  * 完全基于内存，内存操作比较快
  * 单线程，避免了不必要的上下文切换和竞争条件，不存在多进程或多线程导致的切换消耗CPU，不考虑各种锁的时间
  * 多路I/O复用，非阻塞IO
    * 多路指的是多个网络连接
    * 复用指的是复用同一个线程
    * 利用select,poll,epoll同时监察多个流的I/O事件的能力

* redis 单线程原因
  * reids通过I/O多路复用同时监听多个文件描述符(客户端连接)的可读和可写状态，一旦收到网络请求会在内存中快速处理
  * redis是基于内存的操作，**CPU不是redis瓶颈**，r**edis瓶颈最有可能是内存大小或者网络带宽**
  * 单线程指的是在处理网络请求的时候只有一个线程处理，起redis server时肯定不止一个线程
  * 新版redis引入多线程
    * DEL 删除一个键对应的值，若删除的key-value很大，redis会在释放内存空间上消耗较多时间，这些操作会阻塞待处理的任务，因此可以改成后台线程异步执行


#### redis与memcached，mongodb区别
* memcached中key和value都是字符串
* mongodb由Json组成的文档
* redis的value有多种类型 string,list,hash,set,zset

#### Memcache与Redis的区别
* 存储方式
  * Memecache把数据全部存在内存之中，断电后会挂掉，数据不能超过内存大小。
  * Redis有部份存在硬盘上，这样能保证数据的持久性。
* 数据支持类型
  * Memcache对数据类型支持相对简单。
  * Redis有丰富的数据类型。
* 使用底层模型不同
  * 它们之间底层实现方式 以及与客户端之间通信的应用协议不一样。
  * Redis直接自己构建了VM 机制 ，因为一般的系统调用系统函数的话，会浪费一定的时间去移动和请求。

#### 如果有大量的key需要设置同一时间过期，一般需要注意什么
大量的key过期时间设置的过于集中，到过期的那个时间点，Redis可能会出现短暂的卡顿现象(因为redis是单线程的)。严重的话可能会导致服务器雪崩，所以我们一般在过期时间上加一个随机值，让过期时间尽量分散。

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