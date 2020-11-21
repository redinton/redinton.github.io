



[TOC]



#### OOV 情况的处理

1.简单的方法: 训练时, 针对出现频率小于k的词统一用\<UNK\> 代替, 测试时, 针对OOV都用\<UNK\>代替。

缺点是无法区分不同的\<UNK\> 词语, either for identity or meaning.

可以考虑用 char-level model来构造向量。

2.在一些任务例如QA中，需要分辨word identity 即使word是OOV的

2.1如果test time 的 UNK对应的词在预训练的词向量中，用对应的词向量

2.2此外，对于其他词给他们赋值一个随机初始化向量，然后加入词典中

3.collapsing things to word classes(like unknown number, capitalized thing, etc and having an UNK-class for each thing)



#### 当前词向量的不足

1.没有考虑到语境的情况

2.just have one representation for a word,but words have different aspects, including semantics,syntactic behaviour, register/connotations  like arrive and arrival



#### ELMo

有详细介绍



#### ULMfit

train LM on big  general domain corpus  (use biLM)

tune LM on target task data

Fine-tune as classifier on target task

