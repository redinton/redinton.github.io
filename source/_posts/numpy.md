---
title: numpy
date: 2020/11/26 16:30:52
toc: true
tags:
- python
---

#### array 数组的展开

如a是3*4 展开成12，有 ravel 和flatten 两种方式
<!--more-->
```python
from numpy import *

a = arange(12).reshape(3,4)
print(a)
# [[ 0  1  2  3]
#  [ 4  5  6  7]
#  [ 8  9 10 11]]
print(a.ravel())
# [ 0  1  2  3  4  5  6  7  8  9 10 11]
print(a.flatten())
# [ 0  1  2  3  4  5  6  7  8  9 10 11]
```

在平时使用的时候flatten()更为合适

使用过程中flatten()分配了新的内存,

但ravel()返回的是一个数组的视图.视图是数组的引用(说引用不太恰当,因为原数组和ravel()返回后的数组的地址并不一样), 虽然他们是不同的对象,但在修改ravel后的结果的时候,ravel前的结果中相应的数也改变了

