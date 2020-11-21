[TOC]





### SQL

#### 基本操作语句

```sql
show databases;
create databse test; / drop database test;
use test; 
show tables;
desc students; / 查看表结构
create table students; / drop table students;
alter table students add column birth  VARCHAR(10) NOT NULL;

```

#### 实用操作语句

```
INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99) ON DUPLICATE KEY UPDATE name='小明', gender='F', score=99;
insert into .. on duplicate key update ... ; // 插入如果有重复就更新

INSERT IGNORE INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99);
insert ignore into...; //插入如果有重复就忽略



```





#### 事务 (transaction)

把多条语句作为一个整体进行操作 -- 成为数据库事务

* 确保该事务范围内的所有操作全部成功或全部失败

数据库事务具有ACID 四个属性

* A: Atomic ， 原子性 所有SQL作为原子工作单元执行，要么全部执行，要么全部不执行
* C: Consistent  一致性， 事务完成后， 所有数据状态都是一致 , A账户减去100， B账户肯定加上100
* I: Isolation  隔离性 多个事务并发，每个事务作出的修改必须与其他事务隔离
* D: Duration  持久性 ， 事务完成后， 对数据库数据的修改被持久化存储



单条SQL语句，数据库系统自动作为一个事务执行，这种事务称为**隐式事务**。

手动将多条SQL语句作为一个事务执行， 使用BEGIN开启一个事务，使用COMMIT提交一个事务，成为**显式事务**。

主动让事务失败， 用ROLLBACK回滚事务，整个事务会失败。

```SQL
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
ROLLBACK;
```

#### 事务隔离级别

事务支持并发执行。 但若涉及到操作同一条记录的时候，可能会有问题。

并发操作会带来数据的不一致性，包括脏读(dirty read), 不可重复读(Non repeatable read ), 幻读(phantom  read).

![image-20200307113840232](sql.assets/image-20200307113840232.png)

##### read uncommitted

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

一个事务可能读取到另一个事务更新但未提交的数据，这个数据有可能是脏数据。 例如一个事务更新了数据，然后这个时候另一个事务读了就可以读到， 但是原来那个事务可能下一步就回滚导致数据更新失效。

##### read commited

在这个级别，事务对 其余事务更新数据的操作只能读到commit后的结果。

事务可能遇到不可重复读情况。 即指，在一个事务内，多次读同一数据。

在这个事务还没有结束时，如果另一个事务恰好修改了这个数据，那么，在第一个事务中，两次读取的数据就可能不一致。

##### repeatable read

这个级别就是， 某个事务在读数据的时候保持一致，例如起初事务A读数据的时候是空， 然后在这期间事务B插入并commit了这条数据， 这个之后事务A再读数据的时候也是空的。这就是保持 repeatable read。 但是这个时候如果事务A去update 这条数据，是可以成功的，并且之后再读这条数据也是成功的。--  这个情形就是幻读。