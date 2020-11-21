[TOC]

https://zhuanlan.zhihu.com/p/56382372



### Word2vec 参数解释

* skip-gram 相对适合数据集小的情况, cbow 适合数据集大的情况
  * skip-gram 是由中心词去预测context,
  * cbow是多个context一起预测中心词
  * CBOW model = dataset with **short sentences** but high number of samples 
  * SG model = dataset with **long sentences** and low number of samples (smaller dataset)

* 关于其他参数的好坏对比- 参考[link](<http://ruder.io/word-embeddings-softmax/index.html#whichapproachtochoose>)
  * 是否用Hierarchical Softmax,Negative Sampling
  * ![image-20190425230108640](/Users/K/Library/Application Support/typora-user-images/image-20190425230108640.png)





### word2vec和fasttext对比

* fasttext会考虑subword(应对OOV)
* fasttext可进行有supervised learning for text classification
  * 结构与CBOW类似
  * 采用hierarchical softmax对输出标签建立哈弗曼树，样本中标签多的类别对应更短的搜索路径
    * 高频词 对应更短的路径
  * N-gram，考虑词序特征



### glove和word2vec,LSA对比

* LSA，由全局语料得到共现矩阵，用SVD分解
* glove可看做是对LSA一种优化的高效矩阵分解，用adagrad对最小平方损失进行优化

* word2vec，局部语料库训练，特征提取基于滑窗，可以在线学习，而glove需要事先统计全局信息，做不到增量学习。
* glove在一定程度上有label，即共现次数log(![X_{ij}](https://www.zhihu.com/equation?tex=X_%7Bij%7D) )
* word2vec损失函数是带权重的交叉熵，权重固定，**glove损失函数最小平方损失函**数，



### elmo,GPT,BERT三者区别

* GPT采用单向语言模型，elmo和bert采用双向语言模型
* GPT和bert都采用Transformer，Transformer是encoder-decoder结构
  * GPT的单向语言模型采用decoder部分，decoder的部分见到的都是不完整的句子
  * bert的双向语言模型则采用encoder部分，采用了完整句子。



### word2vec 详解 (挖坑)

* skip-gram
  * central 预测context
  * training samples： (central, context1), (central,context2)…..
  * The network is going to tell us the **probability for every word in** our vocabulary of **being the “nearby word”** that we chose.

* CBOW
  * context 预测central



* 原始的算word embedding的方式？

  * 如下图所示 会有一个hidden_layer的存在，这个hidden_layer带来了不少的参数量

    

![Pasted Graphic 3.tiff](/var/folders/h9/ngl09bnx5rl4ssdjn51d_sw80000gn/T/abnerworks.Typora/5C11BF22-494E-45DD-B86F-2C2B5B5AC3CB/Pasted%20Graphic%203.tiff)

* 因此开源的word2vec的实现具体如下图

  * 每个词直接赋一个random 初始化的值
  * 对于cbow而言是把context的词向量加起来取平均然后输入hierarchical softmax中
    * 按照原来的话 还需要一个project把向量从emb_size 投影到 vocab_size

* 为**了节省参数**的 inovation

  * 把常见的短语 word pair or phrase 当做 single words
    * count each combination of two words in the training text
    * 把这些counts 用到一个式子来决定 哪些word combination 变成phrase
    * 这个式子为了找出 phrase 出现的次数 和 phrase中单独的单词出现的频率相关
    * 同时，这个式子更加倾向于那些infrequent的词组成的phrase

  * subsampling frequent word

    * 目的是来减少训练样本数量

    * 像 the这种词在很多context中都会出现, 如果像skip-gram训练时,会有很多词(w, the)情况

    * 因此对于training text中的每个词，有一定的概率 将它删除， 这个概率和这个词的词频有关

      * 词频越高，越小的概率被保存

      

  * negative sampling

    * 原来的结构中，对于一个training sample，在反向传播时， 投影层有 emb_size * vocab_size个  param需要更新

    * negative的想法是，只更新对应的positive sample 以及几个negative sample的 param，那么参数量就下降成 emb_size * (1 + 5) 个 1是postive sample 数目, 5是negative sample 数目

    * **随机**取一小部分除(positive sample词)以外的词，作为negative sample

      * 因此这negative sample的词是**来自于全文**的

      * 频率越高，越有可能被作为neg tive sample

      * ![Pasted Graphic 3.tiff](/var/folders/h9/ngl09bnx5rl4ssdjn51d_sw80000gn/T/abnerworks.Typora/A9CD5093-0F99-4279-B9FA-FFA9DA54A508/Pasted%20Graphic%203.tiff)

      * After get the P(w_i ) value:

        there is a large array with 100M elements (which they refer to as the unigram table.

        fill this table with the index of each word in the vocabulary multiple times, and the number of times a word’s index appears in the table is given by  p(w_i) * table_size.



* skip-gram能够很好处理少量的训练数据，更好表示不常见的词或短语
* CBOW：比skip-gram训练快几倍，对出现频率高的单词准确度稍微更好一点
  * 在CBOW中，不常见的单词将只是用于预测目标单词的**上下文单词集合的一部分**。因此，该模型将给不常现的单词分配一个低概率。

![image-20190607230758075](/Users/K/Library/Application Support/typora-user-images/image-20190607230758075.png)

![image-20190609152346722](/Users/K/Library/Application Support/typora-user-images/image-20190609152346722.png)



* 目标函数
  * CBOW
    * 最大化 $L=\frac{1}{T} \sum_{t=1}^{T} \log P\left(w_{t} | w_{t-c} : w_{t+c}\right)$
    * $\begin{array}{l}{P\left(w_{t} | w_{t-c} : w_{t+c}\right)=\frac{\exp \left(\overline{v}^{T} v_{w_{t}}\right)}{\sum_{n=1}^{N} \exp \left(\overline{v}^{T} v_{n}\right)}} \\ {\overline{v}=\frac{1}{2 c} \sum_{-c<j<=c, j \neq 0} v_{j}}\end{array}$  c是上下文大小
  * Skip-gram
    * $\begin{array}{l}{L=\frac{1}{T} \sum_{t=1}^{T} \sum_{-c<=j<=c, j \neq 0} \log P\left(w_{t+j} | w_{t}\right)} \\ {P\left(w_{t+j} | w_{t}\right)=\frac{\exp \left(w_{t+j}^{T} w_{t}\right)}{\sum_{n=1}^{N} \exp \left(w_{t+j}^{T} w_{n}\right)}}\end{array}$ 
* 实现的word2vec相比之前的word embedding的区别
  * 去掉了隐藏层，模型非常简单
    * ![image-20190607233514351](/Users/K/Library/Application Support/typora-user-images/image-20190607233514351.png)
    * projection只是将word投影成word-embedding大小的向量，之后不需要再投影回vocab_size大小的向量



[Word2vec源码建树过程](<https://github.com/tmikolov/word2vec/blob/master/word2vec.c>)

[huffman建树ref](<https://blog.csdn.net/daaikuaichuan/article/details/80441561>)

* Huff-man树的构建

  * 首先根据 corpus的词频数据构建huff-man树，使得高频词更加靠近根部。

    > 1. 按照词频 (w1, cnt1) 排序
    >    1. 合并两个最小的词频成一个节点，该节点的权重就是子节点的词频之和,
    >    2. 从原始序列中删除已用于合成的两个节点，并添加进合成的新节点
    > 2. 注意点:
    >    1. 权重大的点在左子树
    >    2. 左边的点对应的binary code是1
    >    3. 对于中间每个节点是一个logistic regression 值是预测往**左边走的概率大**小

  * 所有的叶子节点是词库中的词，中间节点都不是词

* 构建完树后，得到每个词的binary code 表示

  * 再根据对应的目标函数最大化对应的词出现的概率



##### Negtive sampling 过程

1.[推导过程](https://www.cnblogs.com/pinard/p/7249903.html)

2.[实现的源码](https://github.com/tscheepers/word2vec/blob/master/word2vec.py)

```python
for context_word in context:
		# Init neu1e with zeros
		neu1e = np.zeros(dim)
		classifiers = [(token, 1)] + [(target, 0) for target in table.sample(k_negative_sampling)]
    for target, label in classifiers:
				z = np.dot(nn0[context_word], nn1[target])
				p = sigmoid(z)
				g = alpha * (label - p)
				neu1e += g * nn1[target]              # Error to backpropagate to nn0
				nn1[target] += g * nn0[context_word]  # Update nn1

				# Update nn0
		nn0[context_word] += neu1e
		word_count += 1
```



word2vec, glove , fasttext 参数调优选择经验

### Glove 详解

* 基于**全局词频统计**（count-based & overall statistics）的词表征（word representation）工具。
* 根据语料库构建一个**共现矩阵**，矩阵中的每一个元素 ![X_{ij}](https://www.zhihu.com/equation?tex=X_%7Bij%7D) 代表单词 ![i](https://www.zhihu.com/equation?tex=i) 和上下文单词 ![j](https://www.zhihu.com/equation?tex=j) 在**特定大小**的**上下文窗口**内共同出现的次数

* ![J = \sum_{i,j=1}^V f\Big(X_{ij}\Big)\Big(w_i^T\tilde{w_j} + b_i + b_j -\log{X_{ij}} \Big)^2](https://www.zhihu.com/equation?tex=J+%3D+%5Csum_%7Bi%2Cj%3D1%7D%5EV+f%5CBig%28X_%7Bij%7D%5CBig%29%5CBig%28w_i%5ET%5Ctilde%7Bw_j%7D+%2B+b_i+%2B+b_j+-%5Clog%7BX_%7Bij%7D%7D+%5CBig%29%5E2)  目标函数 - 类似一个MSE
  * w代表词向量，原本LSA的方法是对一个VxV大小的共现矩阵做SVD,w_i 和w_j 代表对应的词i,j的词向量
* 向量 ![w](https://www.zhihu.com/equation?tex=w) 和 ![\tilde{w}](https://www.zhihu.com/equation?tex=%5Ctilde%7Bw%7D)为学习参数
* 为了提高鲁棒性，我们最终会选择两者之和 ![w+\tilde{w}](https://www.zhihu.com/equation?tex=w%2B%5Ctilde%7Bw%7D) 作为最终的vector。



### FastText 详解







### ELMO 详解

* 词向量不是一成不变的，而是**根据上下文而随时变化**，这与word2vec或者glove具有很大的区别
* ELMo是双向语言模型biLM的**多层表示的组合**，基于大量文本，ELMo模型是从深层的**双向语言模型**（deep bidirectional language model）中的内部状态(internal state)学习而来的。

* ELMO 用法

  * 输入：输入是一个list，每个元素是一个句子 string

    * 也可以是list嵌套list，其中的list就是每个句子tokenize的结果,但是也要对应指明句子长度

  * 输出:

    * 输出有多个选项
      * word_emb
        *  [batch_size, max_length, 512] - 训练ELMO语言模型的时候里面的embedding
      * lstm_outputs1
        * [batch_size, max_length, 1024] , 第一层LSTM的hidden_state (双向，因此concat)
      * lstm_outputs2
        * [batch_size, max_length, 1024], 第二层LSTM hidden_state
      * elmo
        * the weighted sum of the 3 layers, where the weights are trainable. 
        * [batch_size, max_length, 1024]
      * default:
        * a fixed mean-pooling of all contextualized word representations
        * [batch_size, 1024]

  * 可训练的参数

    * tf给的接口一共有四个可以训练的参数，三个是"elmo"中三个层的 wighted sum的权值,还有一个缩放系数。


$\mathbf{E} \mathbf{L} \mathbf{M} \mathbf{o}_{k}^{t a s k}=E\left(R_{k} ; \Theta^{\operatorname{task}}\right)=\gamma^{\operatorname{tas} k} \sum_{j=0}^{L} s_{j}^{\operatorname{task}} \mathbf{h}_{k, j}^{L M}$ 



[tensorflow hub elmo 官方文档](https://tfhub.dev/google/elmo/2)

### 词向量调参经验

#### gensim word2vec

* -sg 0 使用cbow模型， 默认0 , 1是skip-gram， cbow有向量相加
  * **skip-gram慢，但对罕见词有利**，cbow快

* -size 经验超过1000，感觉去sqrt(dict_size)/2，多试
* -window 窗口大小,往前看window个词，往后看window个词，一般cbow取5，skip-gram一般10
  * 小语料的window可以设小一点
* -hs 0是指Negative Sampling，是1的话并且负采样个数negative大于0， 则是Hierarchical Softmax。默认是0即Negative Sampling
* -negative:即使用Negative Sampling时负采样的个数，默认是5。推荐在[3,10]之间
  * 5\~20适合小数据，2\~5适合大数据
* -cbow_mean 仅用于CBOW在做投影的时候，为0，则算法中的X_w为上下文的词向量之和，为1则为上下文的词向量的平均值,默认1
* -min_count:需要计算词向量的最小词频
  * 小语料则可以调低
*  -iter: 随机梯度下降法中迭代的最大次数，默认是5。对于大语料，可以增大这个值。

* 拿到了分词后的文件，在一般的NLP处理中，会需要去停用词。由于word2vec的算法依赖于上下文，而上下文有可能就是停词。**因此对于word2vec，我们可以不用去停词**。



#### Fasttext 调参

http://albertxiebnu.github.io/fasttext/







#### LDA 调参

* 

  



### 面试可能会问的东西

#### 1.词向量好坏怎么评估

#### 2. word2vec和glove优劣







Ref：

[word2vec参数调整 及lda调参][https://www.cnblogs.com/zidiancao/p/5522511.html]

[用gensim学习word2vec](https://www.cnblogs.com/pinard/p/7278324.html)