---
title: mysql问题
date: 2020/11/21 19:23:44
toc: true
tags:
- mysql
---


<!--more-->


#### mysql如何实现不同的隔离级别
* read commited
  * 只**对记录加记录锁**，而不**会在记录之间加间隙锁**
  * 允许新的记录插入到被锁定记录的附近，所以再多次使用查询语句时，可能得到不同的结果（Non-Repeatable Read）
* REPEATABLE READ
  * 多次读取同一范围的数据会**返回第一次查询的快照**，不会返回不同的数据行
  * 可以用过 MySQL 提供的 Next-Key 锁解决幻读问题
    * 幻读： 在一个事务中，同一个范围内的记录被读取时，其他事务向这个范围添加了新的记录。
* SERIALIZABLE 
  * InnoDB 隐式地将全部的查询语句加上共享锁，解决了幻读的问题
[浅入浅出 MySQL 和 InnoDB](https://draveness.me/mysql-innodb/)
