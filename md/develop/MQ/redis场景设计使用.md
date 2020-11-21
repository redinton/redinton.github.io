---
title: redis场景设计使用
date: 2020/11/11 09:48:18
toc: true
tags:
- redis
---


### 用redis实现购物车的功能
在修改频繁的情况下，不会用关系型数据库来存储购物车的信息。 可以考虑用redis或者mongodb这种非关系型数据库

设计: 用户ID作为key,商品ID作为field，商品数量作为value
增加购物车内商品
```bash
hset cart:1001 10021 1
hset cart:1001 10025 1
hset cart:1001 10079 1


```

* 全选功能
  * 获取某用户购物车内的所有商品
  * > hgetall cart:1001 # 获取某个key下的所有field和value
* 商品数量
  * 显示购物车内商品总数量
  * > hlen cart:1001 # 显示某个key下所有field的数量
* 删除某商品
  * 删除购物车内的某个商品
  * > hdel cart:1001 10079
* 增加或减少商品的数量
* > hincrby cart:1001 10021 1 


购物车
* 未登录时暂存购物车
  * 如果存在服务端，需要每个暂存购物车有一个全局唯一标识，比较浪费服务端资源
  * 存客户端，选项是session，cookie，localstorage
    * session的保留时间短，且数据实际还是存服务端
    * cookie存储实现简单，加减购物车，合并购物车中由于服务端可以读写cookie，全部逻辑都可以在服务端实现，并且客户端和服务端请求的次数也相对少一些。
    * LocalStorage 存储，客户端和服务端都要实现一些业务逻辑，但 LocalStorage 的好处是，它的存储容量比 Cookie 的 4KB 上限要大得多，而且不用像 Cookie 那样，无论用不用，每次请求都要带着，可以节省带宽。
    * 小型电商，那用 Cookie 存储实现起来更简单。再比如，你的电商是面那种批发的行业用户，用户需要加购大量的商品，那 Cookie 可能容量不够用，选择 LocalStorage 就更合适。
* 登录后的购物车


