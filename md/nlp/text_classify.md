

 

[TOC]

文本分类综述

https://mp.weixin.qq.com/s/FIkx8ZJkWV-IIad79aJDHw

### Text CNN 用来文本分类

---



![preview](https://pic1.zhimg.com/v2-02c5985f40e98d0d748bdb7e7e4698a4_b.jpg)



#### Embedding

* 第一个矩阵(输入矩阵)维度 n_word x  n_embedding.
* 第一层的输入有多个channel 
  * embedding的**权重freeze - Static**
  * embedding的权**重可以被train - dynamic**
  * 也可以将如glove和word2vec的embedding concat一起，如300，300 concat后变成600维这样



#### max pooling 

* max pooling thourgh time

  * 每个 convolution后的结果 取最大 组成一个feature vector
  * 例如100个filter_size 3 * 100(embedding)的filter 和输入卷积后，得到一个100维的feature vector
  * 缺点：
    * 未考虑任何特征的位置信息，如情感分析这种粒度较细的分类问题位置信息不足便会导致一些问题，如"虽然他长的很帅，但是人品不好"和"虽然他人品不好，但他长得帅啊
    * 只取feature map中一个得分最高的特征，会容易忽视特征的强度，如得分最高的特征只出现了一次，而得分第二高的特征出现了很多次
  * 好处是：
    * 每次输入的句子word数目可以不一样，因为只是取最大的话，最终feature vector的维度和输入的句子单词数目没有关系

  

* K-Max pooling

  * **保留位置顺序**,每次选取得分最高的前K个特征

    * ![preview](https://pic4.zhimg.com/v2-8a35b7c85b9dd82116f178b836b004cd_r.jpg)

    * 例子中对每个feature map取top2

* Chunk-max pooling
  * 将一个**feature map分为若干段，每段选取一个得分最高的特征**。至于划分的方式，既可以在最开始就确定如何划分，也可以根据输入的不同"动态"地进行划分，论文*Event Extraction via Dynamic Multi-Pooling Convolutional Neural Networks* 中便提出动态划分chunk的方案。
  * ![img](https://pic4.zhimg.com/v2-8d6cf40b71f61d40287c7a484090604d_b.jpg)



![preview](https://pic1.zhimg.com/v2-03d8cf94a773f362bc2b916b6bd33f71_r.jpg)



| model                                                        | MR   | SST  |
| :----------------------------------------------------------- | ---- | ---- |
| CNN - emb rand initialization                                |      |      |
| CNN - pretrained emb - static                                |      |      |
| CNN - pretrained emb - dynamic                               |      |      |
| CNN - “multichannel” pretrained emb(one static, one dynamic) |      |      |

* multiple filter widths and feature map
* dropout
* randomly initialized words not in pretrain-embedding
* 



* What about the unknown words?

  


### 长短文本分类

---

* 长短文本分类难点
  * textCNN 相对更适合长文本，加HAN准确率会上一点
* 上万个类别的短文本怎么分类
* 长短不一的文本怎么分类？
  * 构建一个合适的模型对长短不一的文本自动抽取特征
  * 词向量的相加或是average学不了 由于长度相差太大
  * 文本的**层次化**表示
    * 用RNN/CNN 对逐个句子学习表示，输入一句话中每个词的词向量，输出是**句子的特征表示**(一个向量)
    * 用RNN/CNN对整个文本学习表示，输入每个句子的特征，输出学得的**文本的特征表示**(一个向量)
    * 用这个**文本的特征向量**结合一些人工特征送给分类器





### CNN based

---

#### 1.TextCNN (Kim 2014)

#### 2.Char_level CNN

基于字符级的文本分类 , 训练集规模足够大时，卷积网络不需要单词层面的意义。

#### 3.VDCNN

Very Deep Convolutional Networks for Text Classification

code:<https://github.com/vietnguyen91/Very-deep-cnn-pytorch/blob/master/src/very_deep_cnn.py>

用非常深的卷积神经网络模型（称为 VDCNN）进行分层特征学习

实验证明，模型的性能随着深度的增加而增加：最后达到29个卷积层，并在多个文本分类任务上的取得了最优的成绩.

* 用ConvNets的原因是，首先由于图像的结构性特征，一幅图像由很多要素组成，因此ConVnets能够成功，而文本也有着类似的结构char -> n-gram , stems, words, phrase, sentences

![image-20190622150521904](/Users/K/Library/Application Support/typora-user-images/image-20190622150521904.png)

* char-level : 固定sentence长度是s个字符单位，embedding size是 16
* 为了减少内存占用，参考VGG和ResNets的涉及规则
  * 对于相同的输出特征图，Conv有相同数量的filter
    * 上图，从下往上看，从Temp Conv 输出的feature map size是64，后接的Conv filter数目也是64
  * 如果特征图的大小被减半，filter数量增加一倍
    * 第二个Conv Block 64 经过pool/2 后到 Conv Block 128
  * 减少内存使用的理由
    * VGG采用连续的几个3\*3卷积核代替较大size的卷积核，在感受野相同的情况下，**小卷积核的堆叠优于直接使用大size的卷积核**，因为**增加网络深度可以使用更小的代价学得更复杂**的模型。
    * 3个3x3卷积核可以代替7x7卷积核. 长度为7,经过一次3*3卷积核变成 5,再经过一次变成3,在经过一次变成1, 同之间apply 7\*7卷积核
    * 7x7卷积核的参数总量为49\*输入通道数\*输出通道数。3个3x3卷积核的参数总量为27\*输入通道数\*输出通道数。小卷积核的叠加参数量明显少于大卷积核。
    * Stacking 4 layers of such convolutions results in a span of 9 tokens, but the network can learn by it- self how to best combine these different “3-gram features” in a deep hierarchical manner. Our
* conv block是下面这种单元 conv + batchNorm + relu 

![image-20190622154328971](/Users/K/Library/Application Support/typora-user-images/image-20190622154328971.png)

#### 4.DCNN

A convolutional neural network for modelling sentences.(2014 ACL)



提出一种动态pooling的方式来对句子进行语义建模,可以解决输入句子的变长问题，并且引入了能明确捕获short and long-range关系的feature graph

底层通过组合邻近的词语信息，逐步向上传递，上层则又组合新的语义信息，从而使得句子中相离较远的词语也有交互行为（或者某种语义联系）。从直观上来看，这个模型能够通过词语的组合，再通过池化层提取出句子中重要的语义信息

池化过程中，该模型采用动态k-Max池化，这里池化的结果不是返回一个最大值，而是返回k组最大值，

![image-20190622134848089](/Users/K/Library/Application Support/typora-user-images/image-20190622134848089.png)

* 用了宽卷积而不是窄卷积

  * ![image-20190622135635836](/Users/K/Library/Application Support/typora-user-images/image-20190622135635836.png)
  * 保证不会因为深度的加深，导致最后长度减少

* 不同于Kim的TextCNN，**DCNN中卷积核是一维的不是二维的**(TextCNN中 n*emb_size)

* 另外有一个Folding 操作，假设原本emb_size 是4 经过folding后就变成2，fold也就是直接相加。

  



#### 5.DPCNN

 **Deep Pyramid Convolutional Neural Networks for Text Categorization (ACL 2017)**

https://github.com/Cheneng/DPCNN

![image-20190622220420981](/Users/K/Library/Application Support/typora-user-images/image-20190622220420981.png)

* regional embedding
* 如果特征图的大小被减半，filter数量不变
* Shortcut connections with pre-activation and identity mapping



### RNN based

---

#### 1.TextRNN

#### 2. C-LSTM

* 先用CNN对输入的词向量进行卷积，例如100个filter=3的卷积可以得到100个不同的feature_map，然后把这100个feature_map($$)按照列concat变成($length*100$),然后每一行作为一个time-stamp输入到LSTM中。这里的CNN可以理解为起到了特征提取的作用。

#### 3. RCNN

* RNN擅长处理序列结构，能够考虑到句子的上下文信息，但RNN属于“biased model”，一个句子中越往后的词重要性越高，这有可能影响最后的分类结果，因为对句子**分类影响最大的词可能处在句子任何**位置。

* CNN属于**无偏模型，能够通过最大池化获得最重要的特征**，但是CNN的滑动窗口大小不容易确定，选的过小容易造成重要信息丢失，选的过大会造成巨大参数空间。

* 先用Bi-LSTM 获取上下文信息，这比传统的基于窗口的神经网络更能减少噪声，而且在学习文本表达时可以大范围的保留词序。其次使用最大池化层获取文本的重要部分，自动判断哪个特征在文本分类过程中起更重要的作用。



###Attention based

---

####1. RNN Attention (soft atten)

#### 2. HAN 

分级注意力模型。模型有两个显著特征：1）文档是分层结构，单词组成句子，句子组成文档，与之类似，模型也是一种分层结构，对单词和句子级别分别建模，形成最终的文档表示。2）该模型有两个层次的attention机制，分别应用于单次级别和句子级别。attention机制让模型基于不同的单词和句子给予不同的注意力权重，让最后的文档表示更精确、有效。

#### 3. Self attention



### Memory based

---

#### 1.Dynamic Memory Network

Ask Me Anything: Dynamic Memory Networks for Natural Language Processing”一文提出来的。他的思路是所有的NLP任务都可以归为QA任务，也就是由输入、问题、答案构成。所以DMN是构建了一个QA的模型，然后也可以用于分类、翻译、序列数据等多重任务中

#### 2. Entity Network

EntNet是为了QA问题提出来的， 对应论文为Tracking the World State with Recurrent Entity Networks，EntNet延续了Facebook基于Memory Network在QA问题上的模型和成功经验。 MemNN相比RNN或者LSTM来说，强调专门的外部存储来保存以前的样本。

#### 3. Transformer





### 文本分类有哪些分类任务

#### 1. 文本的二分类或者多分类任务

---

* 

#### 2. 文本的多标签分类

---





### Trick篇

#### 1.小数据场景下的分类Trick

* L1/L2 正则 , DropOut , Early Stop, Small number of Param
* 数据增强(Augmentation)
  * **Synonym replacement** 近义词替代, **Back translation** 即先翻译成其他语言，再从其他语言翻译回来
  * **Document cropping** 新闻文章这种较长的文本，切分成多个sample,  **GAN**
* 迁移学习
  * 利用在大数据集下train过的模型的weights
  * 有时候可以作某些层的weights初始化，有时可以作为特征选择器
* 预训练的word embedding - glove，Word2Vec, FastText

* 预训练的sentence encoder [**InferSent**](<https://github.com/facebookresearch/InferSent>) , [universal-sentence-encoder](<https://tfhub.dev/google/universal-sentence-encoder/1>)
* 自己利用unlabel的data [训练一个sentence encoder](<https://blog.myyellowroad.com/unsupervised-sentence-representation-with-deep-learning-104b90079a93>) ,借助skip-thought vectors or language models
* 预训练好的语言模型 如 ELMO，[ULMFIT](https://arxiv.org/abs/1801.06146) [Open-AI transformer](https://blog.openai.com/language-unsupervised/), and [BERT](https://arxiv.org/abs/1810.04805v1)   参考[这个](<http://ruder.io/nlp-imagenet/>)
* 如果有**大量未标注**的数据
  * 非监督学习- auto encoder, masked language model,来预训练模型
* 预训练的时候用另一个task作为目标来train，然后把train完后的model



* 特征工程
  * the author, the newspaper, the number of comments, tags, and more features
  * multimodal architecture
    * combine document level features into our model. 
    * In multimodal we build two different networks, one for the text and one for features, merge their output layers (without softmax) and add a few more layers
    * word-level feature
      * combine one hot encoded representation or an embedding of the word feature with the embedding of the word 
      *  take a sentiment dictionary and add another dimension to the embedding with 1 for words that we have in our dictionary and 0 for other words, this way the model can easily learn some of the words that it needs to focus on. 
      * added dimensions with certain entities that were important
  * Stemming
    * 如果sports的种类如football之类的对task影响不大，可以考虑把这些都映射到"sport"这个类
    * 对于长文本，借助textrank这种方法，先从文本中提取出重要的句子，然后送给模型

[参考1](<https://towardsdatascience.com/lessons-learned-from-applying-deep-learning-for-nlp-without-big-data-d470db4f27bf>)