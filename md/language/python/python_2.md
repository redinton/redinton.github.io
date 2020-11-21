[TOC]

#### type 和 object的关系

* 面向对象中存在两种关系
  * 父子关系，即继承关系，子类继承于父类，查看一个类型的父类，使用`__bases__`属性
  * 类型实例关系，表现为某个类型的实例化，查看实例的类型, 使用`__class__`属性，或者用type()函数

```
>>> object
<type 'object'>
>>> type
<type 'type'>
它们都是type的一个实例，表示它们都是类型对象。
```

* object是父子关系的顶端，所有的数据类型的父类都是它；

* type是类型实例关系的顶端，所有对象都是它的实例的

object是一个type，object is and instance of type。即Object是type的一个实例。





#### 函数的参数

* 不要使用可变类型作为参数的默认值

```python
class HauntedBus:
	def __init__(self, passengers=[]):
		self.passengers = passengers
	def pick(self, name):
		self.passengers.append(name)
	
	

bus2 = HauntedBus()
bus2.pick('Carrie')
bus2.passengers
['Carrie']
bus3 = HauntedBus()
bus3.passengers
['Carrie']
	
	# 修改版
    def __init__(self, passengers=None):
        if passengers is None:
        	self.passengers = []
        else:
        	self.passengers = passengers
 
	# 修改版
    def __init__(self, passengers=None):
        if passengers is None:
        	self.passengers = []
        else:
            # 通过创建副本维护自己的list
        	self.passengers = list(passengers)
 
```





* `__slots__` 节省内存
  * 默认下，python在实例中`__dict__`的字典中存储实例属性，底层是用散列表来提升速度，会消耗大量内存。如果数百万个属性不多的实例，用`__slots__` ，在元组中存储实例属性，而不是字典。那么实例就不会有 `__slots__` 属性
  * 每个子类需要定义`__slots__`属性，解释器会忽略继承的`__slots__`属性
* `__format__` 会被内置的format()函数和str.format()调用，使用特殊格式代码显示对象的字符串表示
* py3中 `__repr__`,`__str__`,`__format__` 都必须返回Unicode字符串(str类型)， `__bytes__` 返回字节序列(bytes 类型)
* `__iter__` 变成可迭代的对象
* `__dict__` 实例的`__dict__` 只会显示实例的属性
* `__dir__`  显示所有的method
* `__getiterm__`  支持迭代
* `__contains__`  支持in运算符
* `__mro__` method resolution order 方法解析顺序。 按顺序列出类及其超类。 多重继承的时候，一般是从左到右，再往上(往父类)





#### 运算符重载

* `__eq__`  ==
* `__pos__` +
* `__neg__` - 





#### 序列迭代

* 解释器需要迭代对象x时，会自动调用 iter(x) 
* 内置 iter 函数
  * 检查对象是否有`__iter__` 方法，有的话就调用它获取迭代器
  * 若没有`__iter__` 但有`__getitem__` , python 会创建一个迭代器，按顺序(索引0开始) 获取元素
  * 尝试失败就抛出 TypeError 异常
* 检查对象是否可迭代
  * 最好用iter () 还会考虑 `__getitem__`
  * 不用 isinstance(x,abc.iterable) 只考虑有无`__iter__`

#### 标准迭代器Iterator接口

* `__next__` 返回下一个元素，如果没有抛出StopIteration
* `__iter__` 返回self



####  可迭代对象和迭代器

* 可迭代对象
  * 有个`__iter__` 方法，每次实例化一个新的迭代器
  * 可迭代的对象一定不能是自身的迭代器，可迭代的对象必须实现`__iter__` 但不能实现 `__next__` 
* 迭代器
  * 要有`__next__` 返回单个元素，
  * 还要实现`__iter__` 返回迭代器本身



#### 迭代器和生成器

* 函数定义体中有yield ，该函数是生成器函数
* 调用生成器函数时，会返回一个生成器对象
* 生成器其实是迭代器，有 `__iter__` 和`__next__`



#### itertools 库

* chain(it1,it2, ... ,itN)
  * 先产出 it1 中的所有元素，然后it2的 ，然后所有都连接在一起
* zip_longest(it1,it2m fillvalue=None)
  * zip 取最长的iterator，剩余确实的补全





#### else 与 for/while/try 使用

* for 
  * 当for循环运行完(即for循环没有被break语句中止) 才运行else模块
* while
  * while 循环因为条件为false退出(不是因为break退出)才运行else
* try
  * try 中没有异常抛出时运行else

所有情况下，如果异常或return，break，continue导致控制权跳到了复合语句的主块之外，else也会被跳过

