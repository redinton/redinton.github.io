---
title: nginx原理
date: 2020/12/02 17:30:11
toc: true
tags:
- nginx
---


#### nginx多进程单线程
* nginx支持的高并发通过多进程+异步非阻塞(IO多路复用)实现了EPOLL
* nginx的worker进程数目一般设置为CPU核数，更多的worker数只会导致进程来竞争CPU资源,带来不必要的上下文切换