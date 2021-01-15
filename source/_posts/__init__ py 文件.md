---
title: __init__ py 文件
date: 2020/11/26 16:32:41
toc: true
tags:
- python
---


python 包管理

<!--more-->
* module
  * 模块，就是各种.py 文件，模块名就是文件名
* build-in module
  * 内置模块，安装python时，系统编译在python解释器中的
* package
  * 任何包含`__init__.py`文件的文件夹就是一个package,python3.3 以上，即使没有`__init__.py`文件，文件夹也自动被视作一个package



* `__init__.py`的作用
  * 可以导入一些次级目录文件中通用的包或者操作。

* regular package

py 3.2 之前的packages 称为regular packages，也就是当前目录下有 `__init__.py` 文件。

```
parent/
    __init__.py
    one/
        __init__.py
    two/
        __init__.py
    three/
        __init__.py
```

导入paratent.one 的时候，会去执行 `parent/__init__.py` and `parent/one/__init__.py`.

Subsequent imports of `parent.two` or `parent.three` will execute `parent/two/__init__.py` and `parent/three/__init__.py` respectively.

* namespace package

之后新出的 namespace packages，可以没有`__init__.py文件`

