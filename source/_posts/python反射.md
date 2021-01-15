---
title: python反射
date: 2020/11/17 14:20:56
toc: true
tags:
- python
---


* getattr()
* hasattr()
* delattr()
* setattr()
实现基于字符串的反射机制
<!--more-->
```py
import commons

def run():
    inp = input("请输入您想访问页面的url：  ").strip()
    if hasattr(commons,inp):
        func = getattr(commons,inp)
        func()
    else:
        print("404")

if __name__ == '__main__':
    run()

```

[参考](https://www.liujiangblog.com/course/python/48)

