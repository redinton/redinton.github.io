[TOC]



### 中文文本的预处理

- [x] 标点符号, 奇怪字符(日文,韩文,表情符号),  数字的去除, 英文字母的去除 (一个函数)

  - [x] 标点符号的去除(中英文分开写)
  - [ ] 回车,制表符一类的字符去除？
  - [ ] html标签的去除？
  - [x] 数字的去除 或 替换
  - [x] 英文字母的去除

- [x] 全角字符 半角字符的转换  (全角的目的是为了某些字符看起来占了一个汉字的位置)

- [x] 只保留中文汉字 

- [ ] 混淆映射

  某些敏感词的映射(同音词,或者字母数字的映射)

- [ ] 预留自定义接口



#### 数字怎么去除

---

* 数字没有意义直接用正则去除
* GloVe中对数字进行了一个很有趣的处理方式，0~9的数字是有对应向量的。对于10以上的数位数进行了转化。比如“10”转化为“##”，“1000”转化为“####”。如果我们使用GloVe词向量，也可以这样处理。

```python
def clean_numbers(x):
    x = re.sub('[0-9]{5,}', '#####', x)
    x = re.sub('[0-9]{4}', '####', x)
    x = re.sub('[0-9]{3}', '###', x)
    x = re.sub('[0-9]{2}', '##', x)
    return x
clean_numbers("1,20,300,4000,50000,600000")
#输出：'1,##,###,####,#####,#####'
```



### 英文的预处理

- [ ] tokenization, stop words removal
- [ ] capitalization, slang, abbrevication
- [ ] spelling correction
- [ ] stemming(词干提取), lemmatization(词形还原)
- [ ] contraction (如I'm -> I am)







#### spell correction

---

```python
#hashing-based and context-sensitive spelling correction techniques, or spelling correction using trie and damerau-levenshtein distance bigram.
from autocorrect import spell

print spell('caaaar')
print spell(u'mussage')
caesar
message
```



#### stemming , lemmatization

---

stemming(词干提取)主要针对**提取词干** ，主要是采用“缩减”的方法，将词转换为词干

lemmatization(词形还原)，主要采用“转变”的方法，将词转变为其原形

词干提取更多被应用于**信息检索**领域，如Solr、Lucene等，用于扩展检索，**粒度较粗**。词形还原更主要被应用于文本挖掘、自然语言处理，用于**更细粒度、更为准确的文本分析**和表达。



### 资料合集

[正则的语法](<https://blog.csdn.net/langhong8/article/details/47064143>)

