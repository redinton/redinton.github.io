



[TOC]





很多NLP任务中，都是取word作为最小单元，而其实char-level的model在某些情况下会有奇效。

1.在char model中word的embedding就是通过char embedding拼接起来，此举可以缓解OOV的问题

2.实验证明在某些任务中,小样本情况下word-level的model 表现好，大数据集情况下char-level可能表现更好



Sub-word model

有两个反向

1.same architecture as for word-level model

use samller units like "word pieces"

2.hybrid architectures

main model has words, something else has char



#### BPE

Byte pair encoding

representing pieces of words to have an infinite effective vocab while actually working with finite vocab

![image-20190721130208804](/Users/K/Library/Application Support/typora-user-images/image-20190721130208804.png)

1.起初vocab中都是char

2.然后找到经常出现的bi-char 组成一个词添加入vocab中

3.停止的标志就是生成了指定数目的字典词数

![image-20190721130331096](/Users/K/Library/Application Support/typora-user-images/image-20190721130331096.png)



#### word piece/sentence piece model

原始的BPE在选取bi-char时是根据出现的频率，现在修改成根据 greedy approximation to maximizing language model log likelihood to choose the pieces

add n-gram  that maximally reduces perplexity



BERT 的词库也是用了 word-piece

![image-20190721134044543](/Users/K/Library/Application Support/typora-user-images/image-20190721134044543.png)

对于不在词库里的hypatia，把他拆分成四个部分，由于BERT中针对 none-initial word pieces are represented with ## at start