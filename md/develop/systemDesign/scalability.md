---
title: scalability
date: 2020/10/31 17:31:32
toc: true
tags:
- 系统设计
---

可扩展性

* clone
  * 通常一个web服务背后有多台server通过load balancer来协调
  * user-related data例如session,profile pictures之类的,不能存在某台server的本地,应该存在某个centralized data store可以被所有application server访问到
    * 例如存在 external database or external persistent cache like redis
  * 代码的部署
    * 当代码有所改动，如何保证所有application server的代码都有变动

* database
  * mysql的主从结构, master负责写,然后slaves负责读
    * sharding, denormalization, SQL tuning
  * 用NoSQL, 不在任何databse query中加join操作
    * join操作放在代码里执行

* cache
  * memory-cache Key-Value结构
  * cache database query
    * 每次去数据库取数的时候,把query和取回来的result存在cache中
      * 数据库中数据变化的时候，需要删除cache中对应的所有记录
  * cache objects
    * 直接cache objects 可以是一个classes或者是instances

* asynchronous
  * 把耗时的工作变成异步来做


* 水平扩展
* 垂直扩展
* 负载均衡
* 数据库复制
* 数据库分区


#### 性能和可扩展性
服务性能的增长与资源的增加是成比例的,服务是可扩展的。




