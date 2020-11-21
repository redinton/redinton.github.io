---
title: gevent源码
date: 2020/11/13 14:16:22
toc: true
tags:
- python,gevent
---

```py
import gevent
gevent.sleep(1)

def sleep(seconds=0):
    hub = get_hub()
    loop = hub.loop
    hub.wait(loop.timer(seconds))

# hub是一个单例

class Hub(greenlet):
    loop_class = config('gevent.core.loop','GEVENT_LOOP')

    def __init__(self):
        greenlet.__init__(self)
        loop_class = _import(self.loop_class)
        self.loop = loop_class()

    def wait(self,watcher):
        waiter = Waiter()
        watcher.start(waiter.switch) # watcher.start(method),当给定的几秒钟过后，会调用这里的函数也就是waiter.switch
        waiter.get()

class Waiter:
    def __init__(self):
        self.hub = get_hub()
        self.greenlet = None

    def switch(self):
        assert getcurrent() is self.hub
        self.greenlet.switch()
    
    def get(self):
        assert self.greenlet is None
        self.greenlet = getcurrent()
        try:
            return self.hub.switch()
        finally:
            self.greenlet = None


hub.wait(loop.timer(seconds))
# loop有一堆接口,对应底层libev的各个功能, 这里用 timer(seconds) 返回一个watcher对象
hub.wait()



```


相关资料

[ython 协程库gevent学习--gevent源码学习(二)](https://www.cnblogs.com/piperck/p/5719163.html)

