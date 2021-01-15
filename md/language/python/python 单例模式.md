---
title: python 单例模式
date: 2020/11/26 16:29:01
toc: true
tags:
- python
---


单例 (Singleton) 一种设计模式 ,应用该模式的类只会**生成一个实例**

* 实例不存在，会创建一个实例；如果已存在就会返回这个实例

* 单例模式保证了在程序的不同位置都**可以且仅可以取到同一个对象实例**：

<!--more-->

### 单例模式的实现

#### 使用函数装饰器实现单例

```python
def singleton(cls):
    # 使用不可变的类地址作为键，其实例作为值，每次创造实例时，首先查看该类是否存在实例，存在的话直接返回该实例即可，否则新建一个实例并存放在字典中。
    _instance = {}

    def inner():
        if cls not in _instance:
            _instance[cls] = cls()
        return _instance[cls]
    return inner
    
@singleton
class Cls(object):
    def __init__(self):
        pass

cls1 = Cls()
cls2 = Cls()
print(id(cls1) == id(cls2)) # id 关键字可用来查看对象在内存中的存放位置
```



#### 使用类装饰器实现单例

```python
class Singleton(object):
    def __init__(self, cls):
        self._cls = cls
        self._instance = {}
    def __call__(self):
        if self._cls not in self._instance:
            self._instance[self._cls] = self._cls()
        return self._instance[self._cls]

@Singleton
class Cls2(object):
    def __init__(self):
        pass

cls1 = Cls2()
cls2 = Cls2()
print(id(cls1) == id(cls2))
```



####  使用 __new__ 关键字实现单例

 Python 中一个类和一个实例是通过哪些方法以怎样的顺序被创造的

简单来说，

* **元类**(**metaclass**) 可以通过方法 **__metaclass__** 创造了**类(class)**，
* 而**类(class)**通过方法 **__new__** 创造了**实例(instance)**。

```
class Single(object):
    _instance = None
    def __new__(cls, *args, **kw):
        if cls._instance is None:
            cls._instance = object.__new__(cls, *args, **kw)
        return cls._instance
    def __init__(self):
        pass

single1 = Single()
single2 = Single()
print(id(single1) == id(single2))
```



####  使用 metaclass 实现单例

type 创造类

```python
def func(self):
    print("do sth")

Klass = type("Klass", (), {"func": func})

c = Klass()
c.func()
```



```python
class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]

class Cls4(metaclass=Singleton):
    pass

cls1 = Cls4()
cls2 = Cls4()
print(id(cls1) == id(cls2))
```



### \__new\__ 和 \__init\__ 的区别

\__new\__所接收的第一个参数是cls，而\__init\__所接收的第一个参数是self。这是因为当我们调用\__new\__的时候，该类的实例还并不存在（也就是self所引用的对象还不存在），所以需要接收一个类作为参数，从而产生一个实例。而当我们调用\__init\__的时候，实例已经存在，因此\__init\__接受self作为第一个参数并对该实例进行必要的初始化操作。这也意味着\__init\__是在\__new\__之后被调用的。

* `__new__`是用来**创造**一个类的实例的（constructor），而`__init__`是用来**初始化**一个实例的（initializer）



### @staticmethod和@classmethod 方法

类中定义的方法可以视 @classmethod装饰的**类方法**, 也可以是@staticmethod装饰的**静态方**法, 最多的还是不带装饰器的实例方法.

```python
class A(object):
    def m1(self, n):
        print("self:", self)

    @classmethod
    def m2(cls, n):
        print("cls:", cls)

    @staticmethod
    def m3(n):
        pass

a = A()
a.m1(1) # self: <__main__.A object at 0x000001E596E41A90>
A.m2(1) # cls: <class '__main__.A'>
A.m3(1)
```

* m1是实例方法 第一个参数必须是self

* m2是类方法, 第一个参数必须是cls

* m3是静态方法, 参数根据业务 可有可无

  

```python3
静态方法的使用场景：

如果在方法中不需要访问任何实例方法和属性，纯粹地通过传入参数并返回数据的功能性方法，那么它就适合用静态方法来定义，它节省了实例化对象的开销成本，往往这种方法放在类外面的模块层作为一个函数存在也是没问题的，而放在类中，仅为这个类服务。例如下面是微信公众号开发中验证微信签名的一个例子，它没有引用任何类或者实例相关的属性和方法。
```



#### @classmethod

要写一个**只在类中运行**而**不在实例中运行**的方法**.** 如果我们想让方法不在实例中运行

[参考 不用初始化 就可以调用方法](http://30daydo.com/article/89)



### 参考链接

[1](https://zhuanlan.zhihu.com/p/37534850)

