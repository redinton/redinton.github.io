---
title: python_动态加载
date: 2020/11/11 15:46:27
toc: true
tags:
- python 
---


python 实现动态加载模块和类

* 系统函数 import 
* importlib 模块
* exec 函数

```py
class Hello:
    def test(self):
        print "test"

    int_value = 123456
    str_value = "a python string"

if __name__ == '__main__':
    print __file__, __name__
```



```py
#!/usr/bin/python
#coding: utf-8

import importlib


def f1():
    """
    使用__import__来实现动态加载
    """
    module_name = "module"
    module1 = __import__(module_name)
    h = module1.Hello()
    h.test()


def f2():
    """
    使用importlib
    importlib相比__import__()，操作更简单、灵活，支持reload()
    """
    module_name = "module"
    class_name = "Hello"
    test_module = importlib.import_module(module_name)
    # 使用getattr()获取模块中的类
    test_class = getattr(test_module, class_name)
    # 动态加载类test_class生成类对象
    test_obj = test_class()
    test_obj.test()


    # reload()重新加载，一般用于原模块有变化等特殊情况。
    reload_module = importlib.import_module(module_name)
    print(getattr(reload_module, class_name).int_value)
    print(getattr(reload_module, class_name).str_value)



if __name__ == '__main__':
    f1()
    f2()
```

