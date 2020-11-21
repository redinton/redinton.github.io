---
title: redis内存淘汰机制
date: 2020/11/07 17:26:46
toc: true
tags:
- redis
---

当缓存内存不足时，通过淘汰旧数据处理新加入数据选择的策略.
<!--more-->
#### 如何配置最大内存？
* 通过配置文件配置  
  * 修改redis.conf配置文件  
  maxmemory 1024mb //设置Redis最大占用内存大小为1024M 注意：maxmemory默认配置为0，在64位操作系统下redis最大内存为操作系统剩余内存，在32位操作系统下redis最大内存为3GB
* 通过动态命令配置
  * Redis支持运行时通过命令动态修改内存大小：
```bash
127.0.0.1:6379> config set maxmemory 200mb //设置Redis最大占用内存大小为200M
127.0.0.1:6379> config get maxmemory //获取设置的Redis能使用的最大内存大小
1) "maxmemory"
2) "209715200"
```

#### 淘汰策略
* noeviction
  * 默认策略，对于写请求直接返回错误，不进行淘汰
* allkeys-lru
  * 从所有的key中使用近似LRU算法进行淘汰
* volatile-lru
  * 从设置了过期时间的key中使用近似LRU算法进行淘汰
* allkeys-random
  * 从所有的key中随机淘汰
* volatile-random
  * 从设置了过期时间的key中随机淘汰
* volatile-ttl
  * ttl(time to live)，在设置了过期时间的key中根据key的过期时间进行淘汰，越早过期的越优先被淘汰
* allkeys-lfu
  * 从所有的key中使用近似LFU算法进行淘汰。从Redis4.0开始支持
* volatile-lfu
  * lfu(Least Frequently Used)，最少使用频率。从设置了过期时间的key中使用近似LFU算法进行淘汰。从Redis4.0开始支持。
  
注意：当使用volatile-lru、volatile-random、volatile-ttl这三种策略时，如果没有设置过期的key可以被淘汰，则和noeviction一样返回错误

#### LRU和LFU在redis中实现
LRU在Redis中的实现  

Redis使用的是近似LRU算法，它跟常规的LRU算法还不太一样。近似LRU算法通过**随机采样法淘汰数据，每次随机出5个**（默认）key，从里面淘汰掉最近最少使用的key。

可以通过maxmemory-samples参数修改采样数量， 如：maxmemory-samples 10

maxmenory-samples配置的越大，淘汰的结果越接近于严格的LRU算法，但因此**耗费的CPU也很**高。

Redis为了实现近似LRU算法，给每个key增加了一个额外增加了一个24bit的字段，用来**存储该key最后一次被访问的时**间。

Redis3.0对近似LRU的优化

Redis3.0对近似LRU算法进行了一些优化。新算法会维护一个候选池（大小为16），池中的**数据根据访问时间进行排序**，第一次随机选取的key都会放入池中，随后每次随机选取的key只有在访问时间小于池中最小的时间才会放入池中，直到候选池被放满。当放满后，如果有新的key需要放入，则将池中最后访问时间最大（最近被访问）的移除。

当需要淘汰的时候，则直接从池中选取最近访问时间最小（最久没被访问）的key淘汰掉就行

LFU算法能更好的表示一个key被访问的热度。如果使用的是LRU算法，一个key很久没有被访问到，只刚刚是偶尔被访问了一次，那么它就被认为是热点数据，不会被淘汰，而有些key将来是很有可能被访问到的则被淘汰了。如果使用LFU算法则不会出现这种情况，因为使用一次并不会使一个key成为热点数据