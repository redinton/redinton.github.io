[TOC]





#### 读取大文件

场景: 文件10G， 内存4G

```python
def get_lines():
        l = []
        with open('file.txt','r') as f:
            data = f.readlines(60000) # 60000是读取字节数
          
        l.append(data)
        yield l
```

需要考虑：

* 内存只有4G，无法一次性读入10G文件。
* 分批读入数据要记录每次读入数据的位置，且分批每次读取得太小会在读取操作上花费过多时间。

特殊模块 linecache 适合输出大文件的第n行：

```python
# 输出第2行
text = linecache.getline(‘a.txt’,2)
print text,
```



