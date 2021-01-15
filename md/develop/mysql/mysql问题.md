---
title: mysql问题
date: 2020/11/21 19:23:44
toc: true
tags:
- mysql
---

[B+树的搜索次数、为什么不用二叉树,哈希表,B树](#b树的搜索次数为什么不用二叉树哈希表b树)
[mysql如何实现不同的隔离级别](#mysql如何实现不同的隔离级别)  
[mysql的wait_timeout和interactive_timeout](#mysql的wait_timeout和interactive_timeout)

<!--more-->

#### B+树的搜索次数、为什么不用二叉树,哈希表,B树
* 不用哈希表
  * 哈希表虽然更快，但是Hash 索引仅仅能满足”=”,”IN”和”<=>”查询， **不支持范围查询**
  * Hash索引不能用**来优化排序**操作
  * 在有大量重复键值情况下，因为存在哈希碰撞，所以哈希索引效率也低
* 不用二叉树
  * AVL 树（平衡二叉树）和红黑树（二叉查找树）基本都是存储在内存中才会使用的数据结构
  * 大规模数据存储的时候，红黑树往往出现由于**树的深度过大而造成磁盘IO读写过于频繁**，进而导致效率低下的情况
  * 磁盘IO代价主要花费在查找所需的柱面上，树的深度过大会造成磁盘IO频繁读写。根据磁盘查找存取的次数往往由树的高度所决定
* 不用B树
  * B 树能够在非叶节点中存储数据，但是这也导致在**查询连续数据时**可能会带来**更多的随机I/O**
  * B+ 树的所**有叶节点可以通过指针相互连接**，能够减少顺序遍历时产生的额外随机 I/O


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


#### mysql的wait_timeout和interactive_timeout
* interactive_timeout
  * 服务器关闭交互式连接前等待的时间(s)
  * 交互式连接就是在终端打开mysql连接，小黑框里进行sql的操作
* wait_timeout
  * 服务器关闭非交互式连接前等待的时间(s)
  * 非交互式连接就是通过类似jdbc hibernate这种插件调用mysql的连接。
  * 到点就会自动kill掉mysql的一部分连接线程
* 修改方式
  * 修改当前的session
  * 修改全局的属性值
    * my.ini配置文件添加wait_timeout=10, 然后重启服务
* 对于非交互式连接，类似于jdbc连接，wait_timeout的值继承自服务器端全局变量wait_timeout。
* 对于交互式连接，类似于mysql客户单连接，wait_timeout的值继承自服务器端全局变量interactive_timeout。


#### ACID以及如何实现
MySQL服务器逻辑架构从上往下可以分为三层：
* 第一层：处理客户端连接、授权认证等。
* 第二层：服务器层，**负责查询语句的解析**、优化、缓存以及内置函数的实现、存储过程等。
* 第三层：存储引擎，负责MySQL中**数据的存储和提取**。MySQL中服务器层不管理事务，**事务是由存储引擎实现**的。MySQL支持事务的存储引擎有InnoDB、NDB Cluster等，其中InnoDB的使用最为广泛；其他存储引擎不支持事务，如MyIsam、Memory等。


衡量事务的维度是ACID(原子性,一致性,独立性,持久性)
* InnoDB默认事务隔离级别是可重复读，不满足隔离性

实现方式
* MySQL的日志有二进制日志,错误日志,查询日志,慢查询日志. 此外InnoDB还实现了两种事务日志, redo log和undo log
* redo log [参考](https://www.cnblogs.com/kismetv/p/10331633.html)
  * 保证持久性
  * InnoDB中，数据放在磁盘，若每次读写数据都要磁盘IO，效率会低。InnoDB提供Buffer pool(缓存)，缓存中包含磁盘部分数据页的映射。
    * 从数据库读数据时,会先从buffer pool中读取，若没有，则从磁盘读取然后放入buffer pool
    * 写数据到数据库,会先写入buffer pool,buffer pool中修改的数据会定期刷新到磁盘中
      * 若MySQL宕机,buffer pool中修改的数据还没有刷新到磁盘中，导致数据丢失，无法保证持久性。
      * redo log:在修改数据时,除了修改buffer pool中的数据，还会在redo log中记录。
        * 事务提交时，调用Fsync接口对redo log刷盘
        * 宕机重启时，读取redo log对数据库进行恢复。
* undo log
  * 保证原子性和隔离性的基础
  * 原子性:当事务回滚时能够撤销所有已经成功执行的sql语句
  * 当事务对数据库进行修改时，InnoDB会生成对应的undo log；如果事务执行失败或调用了rollback，导致事务需要回滚，便可以利用undo log中的信息将数据回滚到修改之前的样子,记录的是**sql执行相关的信息**

#### redo log也需要在事务提交时将日志写入磁盘，为什么它比直接将Buffer Pool中修改的数据写入磁盘(即刷脏)要快呢？主要有以下两方面的原因：
* 刷脏是随机IO，因为每次修改的数据位置随机，但写redo log是追加操作，属于顺序IO。
* 刷脏是以数据页（Page）为单位的，MySQL默认页大小是16KB，一个Page上一个小修改都要整页写入；而redo log中只包含真正需要写入的部分，无效IO大大减少。

#### redo log 和 bin log 区别
* bin log 二进制文件也可以记录写操作并用于数据的恢复，但binlog是用于point-in-time recovery的，保证服务器可**以基于时间点恢复数据**，此外binlog还用于主从复制，redo log是用于crash recovery的，保证MySQL宕机也不会影响持久性
* 层次不同：redo log是InnoDB存储引擎实现的，而binlog是MySQL的服务器层(可以参考文章前面对MySQL逻辑架构的介绍)实现的，同时支持InnoDB和其他存储引擎
* 内容不同：redo log是物理日志，内容基于磁盘的Page；binlog的内容是二进制的，根据binlog_format参数的不同，可能基于sql语句、基于数据本身或者二者的混合
* 写入时机不同：binlog在事务提交时写入；redo log的写入时机相对多元：


#### 一条SQL执行的过程
MySQL 8.0的版本去除了缓存模块。
* 查询语句(Select类型)
  * 连接器, 来管理连接,校验权限
  * server先检查查询缓存,如果命中直接返回.否则下一步
    * SQL以及结果会以 Key-Value 的形式缓存在内存中
    * MySQL查询不建议用缓存,因为查询缓存失效在实际业务中比较频繁
  * 进入解析器
    * 词法解析 -- 提取关键字如查询的表，条件之类的
    * 语法分析 -- 判断输入的SQL是否正确
  * 优化器
    * 选择它认为最优的方案执行SQL语句,如多个索引的时候如何选择索引,多表查询的如何选择关联顺序
  * 执行器
    * 首先执行前会校验该用户有没有权限
      * 如果没有权限，就会返回错误信息
      * 如果有权限，就会去调用存储引擎(InnoDB,MyISAM之类)的接口，返回接口执行的结果。

* 更新语句(update)
  * 大致流程同上
  * 执行更新的时候要记录日志
    * MySQL自带日志模块 bin log, InnoDB自带redo log
  * 执行过程
    * 调用存储引擎API接口,写入数据的时候, InnoDB会把数据存在内存中,同时记录redo log,此时redo log进入prepare状态,然后告诉执行器,执行完成,随时可以提交
    * 执行器收到后记录bin log,然后调用存储引擎接口, 提交redo log为commit状态

[参考这个](#https://juejin.cn/post/6844903655439597582?hmsr=joyk.com&utm_source=joyk.com&utm_source=joyk.com&utm_medium=referral%3Fhmsr%3Djoyk.com&utm_medium=referral#heading-1)


#### MVCC



#### MySQL的事务是否支持跨table/schema
在单机单实例的情况下,MySQL事务是支持跨table/schema的。  
多实例的情况下,需要分布式事务。


#### 索引失效
* 条件中有or,但有条件没有加索引
* 使用is null, is not null 或者使用 != <>
* 联合索引从左开始匹配
* like操作以%开头
* 字符串不加单引号
* mysql估计用全表扫描更合理的时候
* 使用运算符时 如 d.data_value+1='47475.998'
