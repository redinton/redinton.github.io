---
title: django_ORM
date: 2020/11/04 16:09:23
toc: true
tags:
- django
---


### annotate和aggregate
初级查询方法如filter()和exclude().  
涉及对queryset某些字段进行计算或分组计算排序时
<!--more-->
student和hobby多对多关系
```python
class Student(models.Model):

    name = models.CharField(max_length=20)
    age = models.IntegerField()
    hobbies = models.ManyToManyField(Hobby)
    

class Hobby(models.Model):
    name = models.CharField(max_length=20)
```

* 所有学生的平均年龄
* 统计最受学生欢迎的5个爱好

#### 学生的平均年龄
利用aggregate可以实现SQL中的一些agg操作

```python
from django.db.models import Avg, Max, Min

Student.objects.all().aggregate(Avg('age')) # all并非必须的
# { 'age__avg': 12 }
Student.objects.aggregate(average_age = Avg('age')) #设置字典的key
# { 'average_age': 12 }

# 根据Hobby反查学生最大年龄。查询字段student和age间有双下划线哦。
Hobby.objects.aggregate(Max('student__age'))
# { 'student__age__max': 12 }

# 同时获取学生年龄均值, 最大值和最小值, 返回字典
Student.objects.aggregate(Avg('age'), Max('age'), Min('age'))
# { 'age__avg': 12, 'age__max': 18, 'age__min': 6, }
```

#### 统计最受学生欢迎的5个爱好
对数据集先进行分组然后再进行某些聚合操作或排序时，需要使用annotate方法.  
annotate方法返回结果的不仅仅是含有统计结果的一个字典，而是包**含有新增统计字段的查询集**(queryset）.
```python
# 按学生分组，统计每个学生的爱好数量
Student.objects.annotate(Count('hobbies'))
# 返回的结果依然是Student查询集，只不过多了hobbies__count这个字段

# 按爱好分组，再统计每组学生数量。
Hobby.objects.annotate(Count('student'))

# 按爱好分组，再统计每组学生最大年龄。
Hobby.objects.annotate(Max('student__age'))
```



```python
Annotate方法与Filter方法联用
# 先按爱好分组，再统计每组学生数量, 然后筛选出学生数量大于1的爱好。
Hobby.objects.annotate(student_num=Count('student')).filter(student_num__gt=1)


Annotate与order_by()联用
# 统计最受学生欢迎的5个爱好。
Hobby.objects.annotate(student_num=Count('student')).order_by('-student_num')[:5]


Annotate与values()联用
# 按学生名字分组，统计每个学生的爱好数量。
Student.objects.values('name').annotate(Count('hobbies'))
# 在前例中按学生对象进行分组，我们同样可以按学生姓名name来进行分组。唯一区别是本例中，如果两个学生具有相同名字，那么他们的爱好数量将叠加

# values方法从annotate返回的数据集里提取你所需要的字段
Student.objects.annotate(hobby_count=Count('hobbies')).values('name', 'hobby_count')

```


### F 表达式
[Django F()表达式](https://www.jianshu.com/p/6cad2bf1eb6a)  
F()用于操作table中的某列值, F()允许Django直接引用模型字段的值并执行数据库操作，不用把他们导入到python的内存中。
Django使用F()对象生成一个**描述数据库级别所需操作的SQL**表达式。
```python
reporter = Reporters.objects.get(name='Tintin')
reporter.stories_field += 1
reporter.save()
```
从数据库中取出reporter.stories_field的值放入内存中并使用我们熟悉的python运算符操作它，然后把对象保存到数据库中.
```py
from django.db.models import F
reporter = Reporters.objects.get(name='Tintin')
reporter.stories_field = F('stories_field') + 1
reporter.save()
```
实例对象必须重新加载后才能获取以这种方式保存的值
```py
reporter = Reporters.objects.get(pk=reporter.pk)
# 或者，更简洁的操作
reporter.refresh_from_db()
```
使用update()来增加多个对象的字段值
```py
Reporters.objects.all().update(stories_field=F('stories_field') + 1)
```

#### 在annotate中使用F()

F()可以使用算术运算组合不同字段在模型中创建动态字段
```py
company = Company.objects.annotate(chairs_needed=F('num_employee') - F('num_chairs'))
```

