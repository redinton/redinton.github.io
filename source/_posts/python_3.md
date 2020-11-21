[TOC]





#### is not None

is 是比较 内存地址，而None是单例模式生成的，类型是NoneType  除了None 本身，其余对象 is not None的结果都是True

哪些形式的数据为空

* None ， False
* 任何形式数值类型 0 , 0.0
* 空的序列 "" ()  []
* 空的字典
* 用户定义类中定义了nonzero() 和 len , 并且该方法返回0或者false

a = []

a is not None -> return True

if a ->  用于判断a是否为空, 调用的是 a自身的 \__nonzero__() 或者 在没有nonezero的时候调用 len()



#### eval 函数
* str to list/dict/tuple
  * 实现把字符串常量转成变量
* 慎用的原因是 针对不可信的str，转化成命令后可能造成漏洞，如rm 数据
* 有这个函数的原因:
  * 动态语言支持动态地产生代码，对于已经部署好的工程，也可以只做很小的局部修改，就实现 bug 修复