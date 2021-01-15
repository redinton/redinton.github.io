





### Flask

```python
app.run(host=HOST, port=PORT, threaded=True)
```

Flask中通过threaded变量控制是单线程还是多线程模式

* 默认threaded=False即单线程模式, parallel requests是被sequentialy处理的
* threaded=True,对于每个request会起一个新的线程
* processes 该参数用于指定进程数，flask可以指定用多进程或是多线程部署(flask自带的dev  server)，但不能同时启用。



用Apache bench工具作压测。

* 不仅可以对Apache server作压测，也可以对其他类型的server作压测，如Nginx,tomcat
* ab通过创建多个并发访问线程，模拟多个访问者对某个url进行访问

参数说明

* -n 在测试会话中所执行的请求个数。默认时，仅执行一个请求
* -c：一次产生的请求个数。默认是一次一个
* -r:  don't exit on socket receive errors

`ab -r -n 10 -c 5 http://127.0.0.1:3000/?delay=1`

一共发10个请求，并发数是5





* Gunicorn
  * workers
  * threads
  * worker-class
    * sync(默认) - 每个请求由一个process去处理
    * gthread - 每个请求由一个thread处理
      * 另有参数thread可以指定每个process能开的thread数量
    * eventlet , gevent, tornado 异步IO
* uWSGI
  * workers
  * threads



| Mode                                   | concurrency | transaction rate (trans/sec) |
| -------------------------------------- | ----------- | ---------------------------- |
| sync + gunicorn (4 worker + 50 thread) | 921         | 192                          |
| sync + uWSGI (4 worker + 50 thread)    | 236         | 136.07                       |
| async + gunicorn (4 worker + gevent)   | 842         | 616                          |
| async + uWSGI (4 worker + gevent )     | 759         | 575                          |
| nginx + sync + uWSGI                   |             |                              |
| nginx + async + uWSGI                  |             |                              |



* async + uWSGI
  * flask服务首先要用gevent的monkey patched, 否则并发上不去
    * 我的理解: flask的服务没有用gevent开异步的话，其实还是sequence处理的
  * uWSGI的配置不用threads改用gevent参数，否则无效



* 横向扩展
  * 增加server数量
* 垂直扩展
  * 提高单机硬件性能，如增加CPU核数，用更好的网卡(万兆)，升级更好的硬盘
  * 提升单机架构性能,使用Cache减少I/O次数,异步来增加单服务吞吐量；用无锁数据结构来减少响应时间



#### 高并发经典问题

* 单台服务器最大并发
  * 单台server支持多少TCP并发连接
    * 理论是受端口号范围限制, 1024-65535是用户可以使用的，每个TCP连接都要占一个端口号
    * 实际单机并发连接数还受硬件资源(内存，网卡 带宽等影响)
* C10K并发连接
  * requests per second
  * 创建的进程线程多了，数据拷贝频繁（缓存I/O、内核将数据拷贝到用户进程空间、阻塞）， 进程/线程上下文切换消耗大， 导致操作系统崩溃，这就是C10K问题的本质
* C10M并发连接

* **去掉自增主键**
  * 自增主键的存在写库存在抢锁, 可以利用全局id生成器提前生成id直接写入数据库
* **异步任务去写库**
  * 数据只是存在mysql中做备份，建议使用异步的方式写入库，先把数据写到缓存下发给用户，之后在利用后台异步任务一点点的写入，例如聊天系统可以这样干
* **uwsgi + nginx**
  * 使用uwsgi协议让它配合nginx处理django的request，参数为4进程+2线程
  * uwsgi在处理请求的时候发送了队列溢出的问题，因为当前测试设置的并发数为每秒1000次并发，而uwsgi的处理队列容量默认为100，导致处理请求的时间加长，而这个问题则可以通过修改somaxcon的大小解决，总的来说，使用uwsgi+nginx是一个理想的选择
* **gunicorn + nginx**
  * gunicorn跟uwsgi类似，也是一个高性能的http服务器
* **gunicorn + nginx + gevent**
  * gunicorn是同步（sync）单线程模型的，有的时候它不免会发生一些阻塞问题，这时候我们为gunicorn加上-k gevent参数来用gevent做处理接口，这就比较靠谱地处理了阻塞问题





#### Django带数据库连接

* Django本身dev server是单进程多线程的模式，支持一定的并发 60,70吧
  * 在runserver的时候指定 --nothreading 就可以关闭多线程模式



#### MySQL 查看状态

* show processlist
* show status
* show status like '%connect%'



#### Django 实现数据连接池

https://yunsonbai.top/2017/07/02/gunicorn-gevent-django/