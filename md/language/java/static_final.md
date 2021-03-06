

[TOC]





#### static

* 加载
  * static在类加载时初始化完成
* 含义
  * 凡被static修饰说明属于类，**不属于类的对象**

* 可修饰
  * 内部类，方法，成员变量，代码块
* 不可修饰
  * 外部类，局部变量
    * 局部变量属于方法的，不属于类，而static 属于类
  * static 方法不兼容 this 关键字
    * static 代表类层次， this代表当前类的对象
* 作用
  * 方便调用没有创建对象的方法/变量



#### final

* 加载

  * 可以在编译(类加载)时初始化，也可以在运行时初始化，初始化后不能被改变

* 含义

  * 常量？ 被final修饰的只能初始化一次
    * final 修饰基本类型， 值不能修改
    * final 修饰引用类型
      * 引用不可被修改也就是不能指向其他对象，但引用的对象内容可以修改
    * 修饰方法， 方法不可被重写，但可以被子类访问(方法不是private的)
    * 修饰类， 类不可以被继承

* 可修饰

  * 类，内部类，方法，成员变量，局部变量，基本类型，引用类型

  

#### static final

* 含义
  * 应该是static和final的共同体
* 可修饰
  * 成员变量，方法，内部类
    * 修饰成员变量： 属于类的变量且只能赋值一次
    * 方法: 属于类的方法且不可以被重写
    * 内部类：属于外部类，且不能被继承



###  参考

[简单谈谈Static、final、Static final各种用法吧](https://juejin.im/post/5db99657f265da4cfb51252f)

[深入理解static关键字](https://blog.csdn.net/qq_44543508/article/details/102736466)

[程序员你真的理解final关键字吗？](https://blog.csdn.net/qq_44543508/article/details/102720206)