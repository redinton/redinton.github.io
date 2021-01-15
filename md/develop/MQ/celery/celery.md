---
title: celery
date: 2020/11/26 15:29:58
toc: true
tags:
- mq
---

 ### Celery 简介

专注于实时处理和任务调度的分布式任务队列, 任务就是消息。
<!--more-->
#### 常见场景

* web应用

  用户触发一个操作**需要长时间才能执行完**成，可以把他作为任务交给Celery去异步执行。

* 定时任务

  可以用来跑一些**定时**任务

* 同步完成的附加工作异步完成

  **发短信/邮件, 推送消息**, 清缓存
  
#### 架构

* Celery beat

  * 任务调度, Beat进程读取配置文件的内容,周期性将配置文件中到期需要执行的任务发送给任务队列
  * 用于定时任务

* Worker

  **消费者-执行任务**， 通常在多个服务器运行多个消费者来提高执行效率

* Broker

  消息代理(消息中间件),  通常是消息队列或者数据库

  接受任务生产者发送顾过来的任务消息, **存进队列**再按序分发给任务消费方

  Celery目前支持RabbitMQ、Redis、MongoDB、Beanstalk、SQLAlchemy、Zookeeper等作为消息代理，但适用于生产环境的只有RabbitMQ和Redis

  Celery最初的设计就是基于RabbitMQ，所以使用RabbitMQ会非常稳定, 使用Redis，则需要能接受发生突然断电之类的问题造成Redis突然终止后的数据丢失等后果。

* Producer

  生产者, 调用celery的api，函数，装饰器而产生任务并交给任务队列处理都是任务生产者

* Result Backend

  任务处理完保持状态信息和结果，供于查询

  Celery  默认支持 Redis、RabbitMQ、MongoDB、Django ORM、SQLAlchemy


####  Celery 序列化

在客户端和消费者之间传输数据需要序列化和反序列化。


#### Celery 的具体运用

* 创建一个celery application 用来定义你的任务列表
* 编写需要异步执行的任务函数，并用celery实例的task修饰器修饰
* 调用异步任务时， 用函数名.delay(参数）形式调用为异步调用。 函数名（参数）方式为同步调用。
* 执行celery监听服务

main.py 来实例化文件

```python
from celery import Celery
import os

# 读取django项目的配置，若执行的任务在配置文件中有相关配置，则要加载
# os.environ["DJANGO_SETTINGS_MODULE"] = "project.settings.dev"

# 创建celery对象
app = Celery('celery_test')

# 加载配置
app.config_from_object('celery_tasks.config')

# 注册需执行的任务
app.autodiscover_tasks([
    'celery_tasks.sms',
   ])
```



config.py 配置文件

```python
# 指定rabbitmq或则redis作为celery的队列
# broker_url= 'amqp://guest:guest@127.0.0.1:5672'
broker_url = 'redis://127.0.0.1:6379/14'
```



sms.tasks.py 编写需要执行的异步任务函数

```python
# bind：保证task对象会作为第一个参数自动传入
# name：异步任务别名
# retry_backoff：异常自动重试的时间间隔 第n次(retry_backoff×2^(n-1))s
# max_retries：异常自动重试次数的上限
@celery_app.task(bind=True, name='ccp_send_sms_code', retry_backoff=3)
def ccp_send_sms_code(self, mobile, sms_code):
    """
    发送短信异步任务
    :param mobile: 手机号
    :param sms_code: 短信验证码
    :return: 成功0 或 失败-1
    """
    try:
        send_ret = CCP().send_template_sms(mobile, [sms_code, 5], 1)
    except Exception as e:
        logger.error(e)
        # 有异常自动重试三次
        raise self.retry(exc=e, max_retries=3)
    if send_ret != 0:
        # 有异常自动重试三次
        raise self.retry(exc=Exception('发送短信失败'), max_retries=3)

    return send_ret
```

#### 运行

```shell
 celery -A celery_tasks.main worker -l info
 # 运行定义app的文件
```


#### 参考链接

[1. 简书](https://www.jianshu.com/p/bced1b38c8c7)

[2.知乎](https://zhuanlan.zhihu.com/p/22304455)