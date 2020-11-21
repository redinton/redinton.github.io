---
title: SQL语法
date: 2020/11/05 23:05:59
toc: true
tags:
- mysql
---


#### 常用SQL语句
##### 查询table的主键
<!--more-->
```SQL
 SELECT column_name
 FROM INFORMATION_SCHEMA.`KEY_COLUMN_USAGE` 
 WHERE table_name='表名' 
 AND CONSTRAINT_SCHEMA='数据库名称'
 AND constraint_name='PRIMARY'
```

```SQL
SELECT column_name 
FROM INFORMATION_SCHEMA.`KEY_COLUMN_USAGE`  
WHERE table_name='keliuliang_daily'  
AND CONSTRAINT_SCHEMA='hexindao_ods' 
AND constraint_name='PRIMARY';
```



##### 生成复合主键

```SQL
ALTER TABLE table_name ADD PRIMARY KEY(字段A，字段B，字段C)；
```

```SQL
ALTER TABLE keliuliang_daily ADD PRIMARY KEY('dpcode', 'curr_date')；
```



##### 插入语句应对重复情况

* 方法一
  *  不冲突时，相当于insert，其余列默认值
  * 当与主键冲突时，只updae对应的字段

```SQL
insert into 表名 (列名1,列名2) values(值1,值2) on duplicate key update ...
```

* 方法二
  * 不冲突时，相当于insert, 其余列默认值
  * 主键冲突时，会先delete原来的记录，然后做 insert， 未指定的列用默认值， 会导致自增主键发生变化

```sql
replace into 表名 (列名) values (值)
```

##### 基本操作语句

```sql
show databases;
create databse test; / drop database test;
use test; 
show tables;
desc students; / 查看表结构
create table students; / drop table students;
alter table students add column birth  VARCHAR(10) NOT NULL;

```

##### 实用操作语句

```
INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99) ON DUPLICATE KEY UPDATE name='小明', gender='F', score=99;
insert into .. on duplicate key update ... ; // 插入如果有重复就更新

INSERT IGNORE INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'F', 99);
insert ignore into...; //插入如果有重复就忽略



```