



#### Java和JavaScript区别

* Java 面向对象，需要设计对象
  * Java源码执行前，必须经过编译
  * 强类型变量(所有变量编译之前必须作声明)
* JS 脚本语言，基于对象和事件驱动(Event-driven) 
  * 解释性语言，源码不需编译，由浏览器解释执行(目前浏览器几乎使用JIT(及时编译) 技术来提升JavaScript运行效率 
  * 弱类型变量，甚至使用变量前可以不作声明，JS解释器在运行时检查推断其数据类型



#### String 和 StringBuffer 区别

都可以存储和操作字符串

* String类提供数值不可变的字符串
* StringBuffer提供的字符串可以修改

StringBuilder 和 StringBuffer 区别

单线程且操作大量字符串用StringBuilder，速度快，但线程不安全，可修改

多线程且操作大量字符串用StringButter，线程安全，可修改



#### Array 和 ArrayList

* Array 可以包含基本类型和对象类型
  * 大小固定
* ArrayList 只能包含对象类型
  * 大小可以动态变化
  * 更多方法如 addAll() removeAll() iterator()



#### 值传递 引用传递

* 值传递 - 针对基本类型变量而言，传的是该变量的一个副本
* 引用传递 - 对于对象型变量，传递的是对象地址的一个副本
* Java内的传递是值传递



#### 十进制数在内存中存储

以补码的形式存储

* 数字有三种表现形式 - 原码，反码， 补码
  * 第一位是符号位
  * 反码对于负数来说就是，其原码除了符号位其余都取反，补码是反码加1
* 正数的原码，反码， 补码都是自身
* 之所以用补码来表示数字
  * 符号位参与运算，只保留加法，适用于补码的计算

#### ==

Java中 == 对比两个对象基于内存引用，如果两个对象的引用完全相同即指向同一个对象，返回true， 如果==两边是基本类型，那么就比较数值是否相等



#### Map的分类

四个实现类 - HashMap, Hashtable,LinkedHashMap,TreeMap

* HashMap 
  * 遍历时，取数顺序完全随机
  * HashMap最多允许一条记录的键为null，值可以多条为空
  * 不支持线程同步，即任一时刻，多个线程同时写HashMap可能导致数据的不一致
    * 同步可以用Collections的synchronizedMap或者ConcurrentHashMap
* HashTable
  * 继承自Dictionary类
  * 不允许记录的键或值为空
  * 支持线程同步
    * 任一时刻，只有一个线程能写Hashtable，也导致在写入时比较慢
* LinkedHashMap
  * 保存了记录的插入顺序
  * 用Iterator遍历时，先得到的记录肯定是先插入的
* TreeMap
  * 实现sortMap接口
  * 支持记录按照键排序



#### final 关键字

* final修饰一个类
  * 表示这个类不能被继承
    * final类成员变量可以根据需要设为final
      * 若是基本数据类型，数值一旦初始化便不能更改
      * 引用类型，初始化后便不能让其指向另一个对象
    * final类成员方法被隐式指定为final方法

