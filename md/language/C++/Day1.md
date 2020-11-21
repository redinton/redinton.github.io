

[TOC]

#### 头文件声明

防御式声明

![image-20190831153043271](/Users/K/Library/Application Support/typora-user-images/image-20190831153043271.png)

#### 内联函数 (inline)

函数在class 本体里定义 就是 inline

![image-20190831132644314](/Users/K/Library/Application Support/typora-user-images/image-20190831132644314.png)

#### 构造函数

创建对象时，自动被调用

函数名称与类名称相同，变量有默认值，没有返回类型

构造函数可以有多个 (相同函数有多个 - overloading 重载)

![image-20190831133605332](/Users/K/Library/Application Support/typora-user-images/image-20190831133605332.png)

建议初始化的写法如上，时间效率更优



构造函数还可以放在private中 ， 要定义一个新的setup函数来

![image-20190831134337016](/Users/K/Library/Application Support/typora-user-images/image-20190831134337016.png)



#### 常量成员函数

![image-20190831134945237](/Users/K/Library/Application Support/typora-user-images/image-20190831134945237.png)

常量成员函数需要加const，以防万一出现右下角调用方式。



#### 参数传递 : by value / by reference(to const)

* 引用传递的话 速度上会更快 因为数据可能会很大，但是如果只是传一个指针的话，只有4个byte那么速度就会很快。
* 指针传递的话，传递的变量一旦被改动，会改动到原始的变量，如果追求速度快又不想数据被改动，用const

![image-20190831140823060](/Users/K/Library/Application Support/typora-user-images/image-20190831140823060.png)



#### 返回值传递

尽量by reference

![image-20190831140916231](/Users/K/Library/Application Support/typora-user-images/image-20190831140916231.png)



#### 友元函数

![image-20190831141017497](/Users/K/Library/Application Support/typora-user-images/image-20190831141017497.png)



![image-20190831141337829](/Users/K/Library/Application Support/typora-user-images/image-20190831141337829.png)



* 数据是private
* 传参数 reference，加不加const 看情况
* 返回值 尽量reference形式传递
* 函数如果可以定义成const 尽量定义成const



#### 什么时候return 不能传reference

需要return的东西是在函数中被创建的

![image-20190831141758953](/Users/K/Library/Application Support/typora-user-images/image-20190831141758953.png)

比如 the.rs + r.re 返回给一个新的变量，而非上图的 += ， 那么这个时候如果用

reference传递，对应的地址的东西可能已经被销毁了。



#### 操作符重载

![image-20190831145234961](/Users/K/Library/Application Support/typora-user-images/image-20190831145234961.png)

成员函数都有一个隐藏变量 this. 是一个指针



#### 临时对象

![image-20190831150625374](/Users/K/Library/Application Support/typora-user-images/image-20190831150625374.png)

![image-20190831151123453](/Users/K/Library/Application Support/typora-user-images/image-20190831151123453.png)

![image-20190831151843494](/Users/K/Library/Application Support/typora-user-images/image-20190831151843494.png)

