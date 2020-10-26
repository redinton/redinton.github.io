---
title: embedding 对比
date: 2019-04-21 14:56:34
tags:
- nlp
- text classification
toc: true
mathjax: true
---



### word2vec和fasttext对比

- fasttext会考虑subword(应对OOV)
- fasttext可进行有supervised learning for text classification
  - 结构与CBOW类似
  - 采用hierarchical softmax对输出标签建立哈弗曼树，样本中标签多的类别对应更短的搜索路径
  - N-gram，考虑词序特征

<!--more--> 

### glove和word2vec,LSA对比

- LSA，由全局语料得到共现矩阵，用SVD分解
- glove可看做是对LSA一种优化的高效矩阵分解，用adagrad对最小平方损失进行优化
- word2vec，局部语料库训练，特征提取基于滑窗，可以在线学习，而glove需要事先统计全局信息，做不到增量学习。
- glove在一定程度上有label，即共现次数log(![X_{ij}](https://www.zhihu.com/equation?tex=X_%7Bij%7D) )
- word2vec损失函数是带权重的交叉熵，权重固定，glove损失函数最小平方损失函数，

### elmo,GPT,BERT三者区别

- GPT采用单向语言模型，elmo和bert采用双向语言模型
- GPT和bert都采用Transformer，Transformer是encoder-decoder结构
  - GPT的单向语言模型采用decoder部分，decoder的部分见到的都是不完整的句子
  - bert的双向语言模型则采用encoder部分，采用了完整句子。



### word2vec 详解 (挖坑)

- skip-gram
  - central 预测context
  - training samples： (central, context1), (central,context2)…..
  - The network is going to tell us the **probability for every word in** our vocabulary of **being the “nearby word”** that we chose.



word2vec, glove , fasttext 参数调优选择经验

### Glove 详解

- 基于**全局词频统计**（count-based & overall statistics）的词表征（word representation）工具。
- 根据语料库构建一个共现矩阵，矩阵中的每一个元素 ![X_{ij}](https://www.zhihu.com/equation?tex=X_%7Bij%7D) 代表单词 ![i](https://www.zhihu.com/equation?tex=i) 和上下文单词 ![j](https://www.zhihu.com/equation?tex=j) 在**特定大小**的**上下文窗口**内共同出现的次数
- ![J = \sum_{i,j=1}^V f\Big(X_{ij}\Big)\Big(w_i^T\tilde{w_j} + b_i + b_j -\log{X_{ij}} \Big)^2](https://www.zhihu.com/equation?tex=J+%3D+%5Csum_%7Bi%2Cj%3D1%7D%5EV+f%5CBig%28X_%7Bij%7D%5CBig%29%5CBig%28w_i%5ET%5Ctilde%7Bw_j%7D+%2B+b_i+%2B+b_j+-%5Clog%7BX_%7Bij%7D%7D+%5CBig%29%5E2)  目标函数 - 类似一个MSE
  - w代表词向量，原本LSA的方法是对一个VxV大小的共现矩阵做SVD,w_i 和w_j 代表对应的词i,j的词向量
- 向量 ![w](https://www.zhihu.com/equation?tex=w) 和 ![\tilde{w}](https://www.zhihu.com/equation?tex=%5Ctilde%7Bw%7D)为学习参数
- 为了提高鲁棒性，我们最终会选择两者之和 ![w+\tilde{w}](https://www.zhihu.com/equation?tex=w%2B%5Ctilde%7Bw%7D) 作为最终的vector。



### ELMO 详解

- 词向量不是一成不变的，而是**根据上下文而随时变化**，这与word2vec或者glove具有很大的区别
- ELMo是双向语言模型biLM的**多层表示的组合**，基于大量文本，ELMo模型是从深层的**双向语言模型**（deep bidirectional language model）中的内部状态(internal state)学习而来的。
- ELMO 用法
  - 输入：输入是一个list，每个元素是一个句子 string
    - 也可以是list嵌套list，其中的list就是每个句子tokenize的结果,但是也要对应指明句子长度
  - 输出:
    - 输出有多个选项
      - word_emb
        - [batch_size, max_length, 512] - 训练ELMO语言模型的时候里面的embedding
      - lstm_outputs1
        - [batch_size, max_length, 1024] , 第一层LSTM的hidden_state (双向，因此concat)
      - lstm_outputs2
        - [batch_size, max_length, 1024], 第二层LSTM hidden_state
      - elmo
        - the weighted sum of the 3 layers, where the weights are trainable. 
        - [batch_size, max_length, 1024]
      - default:
        - a fixed mean-pooling of all contextualized word representations
        - [batch_size, 1024]
  - 可训练的参数
    - tf给的接口一共有四个可以训练的参数，三个是"elmo"中三个层的 wighted sum的权值,还有一个缩放系数。

$\mathbf{E} \mathbf{L} \mathbf{M} \mathbf{o}_{k}^{t a s k}=E\left(R_{k} ; \Theta^{\operatorname{task}}\right)=\gamma^{\operatorname{tas} k} \sum_{j=0}^{L} s_{j}^{\operatorname{task}} \mathbf{h}_{k, j}^{L M}$





[tensorflow hub elmo 官方文档](https://tfhub.dev/google/elmo/2)

### 词向量调参经验

#### gensim word2vec

- -sg 0 使用cbow模型， 默认0 , 1是skip-gram， cbow有向量相加
  - **skip-gram慢，但对罕见词有利**，cbow快
- -size 经验超过1000，感觉去sqrt(dict_size)/2，多试
- -window 窗口大小,往前看window个词，往后看window个词，一般cbow取5，skip-gram一般10
  - 小语料的window可以设小一点
- -hs 0是指Negative Sampling，是1的话并且负采样个数negative大于0， 则是Hierarchical Softmax。默认是0即Negative Sampling
- -negative:即使用Negative Sampling时负采样的个数，默认是5。推荐在[3,10]之间
  - 5\~20适合小数据，2\~5适合大数据
- -cbow_mean 仅用于CBOW在做投影的时候，为0，则算法中的X_w为上下文的词向量之和，为1则为上下文的词向量的平均值,默认1
- -min_count:需要计算词向量的最小词频
  - 小语料则可以调低
- -iter: 随机梯度下降法中迭代的最大次数，默认是5。对于大语料，可以增大这个值。
- 拿到了分词后的文件，在一般的NLP处理中，会需要去停用词。由于word2vec的算法依赖于上下文，而上下文有可能就是停词。**因此对于word2vec，我们可以不用去停词**。



#### Fasttext 调参

http://albertxiebnu.github.io/fasttext/



#### LDA 调参

- 直接把短文档（比如一个微博，一个查询）作为输入，不如先做预处理把这些短文章聚合成一些长文章（比如把同一作者的微博合一块)。

- 文档长度不能太短，至少是文档数目的log，所以对于太短的文档，我们必须把他们聚合

  

### 面试可能会问的东西

1.词向量好坏怎么评估

2.word2vec和glove优劣



**参考链接**

[知乎](https://zhuanlan.zhihu.com/p/56382372)

[word2vec参数调整 及lda调参](https://www.cnblogs.com/zidiancao/p/5522511.html)

[用gensim学习word2vec](https://www.cnblogs.com/pinard/p/7278324.html)