---
title: django基本操作
date: 2020/11/05 22:51:35
toc: true
tags:
- django
---


### django 基本的操作

<!--more-->

#### 1. 查看版本

```
python -m django --version
```



#### 2. 创建项目

```
django-admin startproject mysite
```

生成的文件架构

```
mysite/
    manage.py
    mysite/
        __init__.py
        settings.py
        urls.py
        asgi.py
        wsgi.py
```

#### 3. 创建一个应用

```
 python manage.py startapp polls
```

文件架构

```
polls/
    __init__.py
    admin.py
    apps.py
    migrations/
        __init__.py
    models.py
    tests.py
    views.py
```



###  django 文件目录

#### 1.  应用可以统一放在某个文件夹下

或者说在某个文件夹下统一 startapp

#### 2.  配置文件

把原本的settings.py 文件可以修改为在settings文件夹下，另外配置 develop 和production的配置文件。

#### 3. 改变模型

- 编辑 `models.py` 文件，改变模型。
- 运行 [`python manage.py makemigrations`](https://docs.djangoproject.com/zh-hans/3.0/ref/django-admin/#django-admin-makemigrations) 为模型的改变生成迁移文件。
- 运行 [`python manage.py migrate`](https://docs.djangoproject.com/zh-hans/3.0/ref/django-admin/#django-admin-migrate) 来应用数据库迁移。

#### 4.makemigrations和migrate分别做了什么



#### App 下的apps.py文件

```python
from django.apps import AppConfig

class ResourceManagementConfig(AppConfig):
    name = 'autocv.api.resource_management'

    def ready(self):
        print('start up gpu failed job scheduler')

        # Delete any existing jobs in the scheduler when the app starts up
        scheduler = django_rq.get_scheduler('high')

        for job in scheduler.get_jobs():
            print("delete")
            job.delete()
```

然后在`__init__.py`中

```python
# resource_management/__init__.py

default_app_config = 'autocv.api.resource_management.apps.ResourceManagementConfig'
```

* 在apps.py中 更像是指定一些 这个app涉及的相关的配置
* 继承AppConfig后，overide  ready这个函数，会在起django服务的时候运行 ready函数



#### DRF django restful framework



#### Django - RQ worker



#### Django 设置默认页面

即运行服务后 , 输入 ip:port 进入的默认页面

* 找到主目录下的 urls.py 文件

* ```python
  from django.views.generic.simple import direct_to_template
  urlpatterns += patterns("",
      (r"^$", direct_to_template, {"template": "index.html"})
  )
  ```