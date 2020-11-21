[TOC]



#### 容器结构与分类

1. Sequence container

![image-20190901115211132](/Users/K/Library/Application Support/typora-user-images/image-20190901115211132.png)

vector: 会自动增长

deque: 双向队列 (念dic)

List: 每个元素并不是连续的，而是通过指针连接的双向链表

forward-list: 耗用的内存少于 List， 单向链表



2. Associative container

关联式的容器 key-value

![image-20190901115507311](/Users/K/Library/Application Support/typora-user-images/image-20190901115507311.png)



set: 内部是 红黑树 (高度平衡的)，key和value是一个东西

map:内部也是红黑树实现 (分为key value)，multiset意味着key可以重复

3. unordered container (C++ 11出来的)

不定序的容器

![image-20190901120221772](/Users/K/Library/Application Support/typora-user-images/image-20190901120221772.png)

![image-20190901120252940](/Users/K/Library/Application Support/typora-user-images/image-20190901120252940.png)



#### array样例使用

![image-20190901124758859](/Users/K/Library/Application Support/typora-user-images/image-20190901124758859.png)

 array.data 传回这个数组在内存里的起点地址



