---
title: mysql存储过程
date: 2020/11/05 11:06:55
toc: true
tags:
- mysql
---

存储过程和函数是事先经过编译并存储在数据库中的一段SQL语句集合。调用存储过程和函数，减少数据在db和应用服务器之间的传输。
<!--more-->
* 存储过程和函数的区别在于
  * 函数必须有返回值，而存储过程没有
  * 存储过程的参数可以使用IN、OUT、INOUT 类型，而函数的参数只能是IN 类型的。
  * 如果有函数从其他类型的数据库迁移到MySQL，那么就可能因此需要将函数改造成存储过程。