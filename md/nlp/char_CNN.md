



[TOC]



Character-level Convolutional Networks for Text Classification (2015)



### model overview

![image-20190405103321760](/Users/K/Library/Application Support/typora-user-images/image-20190405103321760.png)

* Feature只是是m个字符表(paper中是70)，26 characters,10 digits , 33 other character. newline

![image-20190405103500311](/Users/K/Library/Application Support/typora-user-images/image-20190405103500311.png)

* character quantinization
  * 每一个字符被转化成m维的one-hot vector, 输出的文本也都转化成固定长度$l_0$ 的序列
  * 对于不在字符表中的字符以及空字符,都用$1*m ​$ 的全零向量表示
  * 文中还提到一个反向处理文本的trick，就是把文本反过来输入，使得最新读入字符总在输出最开始的地方



* model design
  * ![image-20190405110852010](/Users/K/Library/Application Support/typora-user-images/image-20190405110852010.png)
  * ![image-20190405110901289](/Users/K/Library/Application Support/typora-user-images/image-20190405110901289.png)
  * 输入固定$l_0​$ = 1014
    * ![image-20190405110956809](/Users/K/Library/Application Support/typora-user-images/image-20190405110956809.png)

* 同义词作数据增强 (data augmentation using  thesaurus同义词典)
  * 英文中用WordNet，对于每个词汇,存在多个同义词，ranked by the semantic closeness to the most frequently seen meaning
  * 找到train corpus中所有在wordnet中存在同义词的词语，从中随机取r个来替换
    * $P[r] ~~~~- ~~~ p^r$
    * $P[s]   -  q^{s}$
    * 



###收获

* n-gram,tfidf 传统方法仍然适用于dataset在几十万，而char-level的ConvNets在daatset达到百旺规模后更有优势
* 适用于 user-generated data - 拼写错误，口语化， 表情符号之类的
* 百万级的语料，不区分字母大小写结果可能会好一点，字母大小写和语义关系不大



### 拓展

* 在中文上如何应用character_based CNN
* [ ] 看Character-level Convolutional Network for Text Classification Applied to Chinese Corpus

* character-level combined with word-level??
  * 中文 
  * 英文
* 

### Ref

[1 **NLP-Papers** notes](https://github.com/llhthinker/NLP-Papers/blob/master/text%20classification/2017-10/Character-level%20Convolutional%20Networks%20for%20Text%20Classification/note.md)

[2. 知乎阅读笔记](https://zhuanlan.zhihu.com/p/51698513)