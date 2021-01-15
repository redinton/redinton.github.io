---
title: redis集群方案
date: 2020/12/21 20:53:54
toc: true
tags:
- redis
---


redis单线程，一台机子只运行一个实例比较浪费。管理一个巨大内存不如管理相对较小的内存高效。实际使用中,一台机器会跑多个redis实例。

#### redis cluster 官方集群
* 3.0后开始提供，Sharding采用slot概念，一共分成16384个slot。
* 每个进入redis的key-value，根据key进行散列，分配到这么多slots里的一个
  * hash算法就是CRC16后对16384取模
* redis集群中每个node负责一部分slot,当node发生变动(动态增加或减少),需要对slot重新分配
  * 意味着slot中的key-value要迁移
  * 这一过程目前还是半自动状态，要人工介入
* redis集群中,一旦某个node故障,其负责的slots也失效,集群就不work了
  * 把node配置成主从结构,一个master node挂n个slave node.
  * 若master node失效, cluster会根据选举算法从slave中选择一个作为master node
  * redis cluster提供的故障转移容错能力
* redis cluster的新节点识别能力,故障判断,故障迁移
  * 通过集群中的每个node与其他nodes之间通信--称为集群总线
  * 使用特殊的端口号即对外服务端口号加10000
  * nodes之间通信采用特殊的二进制协议
* 客户端可以任意连接一个node操作,像操作单一redis实例一样
  * 若操作的key没有被分到当前的node,redis执行转向命令，指向正确的node