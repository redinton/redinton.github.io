---
title: linux_1
date: 2020/11/21 21:01:14
toc: true
tags:
- linux
---

[linux-守护进程](#linux-守护进程)
[linux-直接查看某个进程的占用端口-命令](#linux-直接查看某个进程的占用端口-命令)
[ubuntu下使用apt-get-install安装的软件的相关位置](#ubuntu下使用apt-get-install安装的软件的相关位置)
<!--more-->

#### Linux 守护进程

“守护进程”  daemon 就是一直在**后台运行**的进程

如何让web应用变成系统的守护进程daemon,成为一种服务，一直运行

成为守护进程

* step 1

  * 改成 "后台任务"

    ```
    blabla &
    ```

    命令的尾部加上符号`&`，启动的进程就会成为"后台任务"

"后台任务"有两个特点。

* 继承当前 session （对话）的标准输出（stdout）和标准错误（stderr）。因此，后台任务的所有输出依然会同步地在命令行下显示。 -- 加了 &后 其实，输出结果还会在命令行中

* 不再继承当前 session 的标准输入（stdin）。**你无法向这个任务输入指令了。**如果它试图读取标准输入，就会暂停执行（halt）。

后台任务的标准I/O也要重定向

[参考](http://www.ruanyifeng.com/blog/2016/02/linux-daemon.html)

nohup的作用

- 阻止`SIGHUP`信号发到这个进程。
- 关闭标准输入。该进程不再能够接收任何输入，即使运行在前台。
- 重定向标准输出和标准错误到文件`nohup.out`。



#### Linux 直接查看某个进程的占用端口 命令

查看端口被哪个进程占用

```
lsof -i:端口号
或者
netstat -tunpl | grep 端口号
```

查看进程占用端口

```
查看对应的进程号 ps -ef|grep 进程名
查看进程号所占用的端口号 netstat -nltp | grep 进程号
```



#### ubuntu下使用apt-get install安装的软件的相关位置

有时候需要配置ubuntu安装的软件，一般安装软件都是使用apt-get install。那么安装完后，软件的安装目录在哪里呢，可执行文件又放在哪里呢。

A、下载的软件的存放位置：/var/cache/apt/archives

B、安装后软件的默认位置：/usr/share

C、可执行文件位置：/usr/bin

D、配置文件位置：/etc

E、lib文件位置：/usr/lib

