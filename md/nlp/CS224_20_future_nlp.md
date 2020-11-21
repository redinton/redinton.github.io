[TOC]





#### Using unlabeled data to improve

##### pre-training

![image-20190422152357791](/Users/K/Library/Application Support/typora-user-images/image-20190422152357791.png)



* pre-training 的坏处在于 **no intertaction between these two language**s

##### self-training

![image-20190422153112571](/Users/K/Library/Application Support/typora-user-images/image-20190422153112571.png)

流程上先用已有的model来translate unlabeled data，然后把translate的结果结合对应的unlabeled的data再来train已有的model。

这里存在一个"circular"的问题，用model translate出来的结果返回去train model。

##### back-translation

更常用的是这个。假设要训练一个 fr-en的翻译用model translate的结果 作为input, 原始的对应的unlabeled的sample作为outpu来 train en-fr model。注意这里需要同时train两个model，英到法和法到英。

![image-20190422154506938](/Users/K/Library/Application Support/typora-user-images/image-20190422154506938.png)

好处主要有 

* 没有cirular的问题
* 模型不会看到不好的"target"(即翻译的结果), only bad inputs.





####What if there is no bilingual data

仅有一种语言的语料库，来train一个NMT。

#### Word-level unsupervised training

* cross-lingual **word embeddin**g  

  * shared embedding space for both language

  ![image-20190422113956945](/Users/K/Library/Application Support/typora-user-images/image-20190422113956945.png)
  * 在embedding space 想要实现，**代表不同语言同样意思的point 彼此靠近**。

* 基于的假设

  * word embedding **have a lot of structure** and **structure similar across language**.

  ![image-20190422114248492](/Users/K/Library/Application Support/typora-user-images/image-20190422114248492.png)
  * structure 指的就是图中近义词之间存在的某种关系，我的理解是类似 king-queen = woman - man 类似

* 做法：
  * ![image-20190422120412573](/Users/K/Library/Application Support/typora-user-images/image-20190422120412573.png)
  * 先分别用两种语料库训练两种word embedding
  * 然后学一个**正交矩阵W**能够把embeding X 投影到 embedding Y 的space
  *  BTW: 之所以要train一个**正交的**矩阵，主要还是为了防止过拟合。intuition在于两种embedding的结构十分类似，相当于只是借助W做一个rotation操作。

* how to learn the orthogonal matrix W
  * 视频中提到一种用GAN的方式来train 参考这篇论文[Word Translation Without Parallel Data](<https://arxiv.org/abs/1710.04087>)
  * discriminator 用来区别 embedding 是属于 语料 1 还是语料 2 (语料1,2代指两种不同的语言), 而那个用来区别的embedding 就是用W来投影 embedding 1



#### Sentence level unsupervised training

![image-20190422121437969](/Users/K/Library/Application Support/typora-user-images/image-20190422121437969.png)

同一个encoder-decode框架用来做 EN->FR 和 FR->EN, 输出哪种语言就看在decoder中输入的第一个状态是\<Fr>还是\<En>

* 图中initialize with cross-lingual word embedding,其中的intuition在于用cross-lingual word embedding初始化后，对于一开始的encoder来说 英语的I am a student和法语的这个"Je suis blabla" 句子的representation是类似的，所以有了下图从法语翻译出对应的英文的效果。

![image-20190422123126629](/Users/K/Library/Application Support/typora-user-images/image-20190422123126629.png)

* 训练的过程

  ![image-20190422121821894](/Users/K/Library/Application Support/typora-user-images/image-20190422121821894.png)
  * 输入一个打乱的句子(scrambled?) ，然后decode的target是没有打乱的句子，intuition是autoencoder中encoder输出的那个single vector应该包含了句子的全部信息，decoder应该能够解码出原始句子

  ![image-20190422122130206](/Users/K/Library/Application Support/typora-user-images/image-20190422122130206.png)
  * 第二步就是用back translation，先用当前的模型，把法语翻译成英语，然后用这个翻译的英语以及对应的正确的法语作为一个pair去train model。 这个时候model的input可能是noise的，但是model的target一定**是正确**的。



![image-20190422123711679](/Users/K/Library/Application Support/typora-user-images/image-20190422123711679.png)





用类似的机器翻译的思想也可以train一个风格转移？的翻译

![image-20190422123555983](/Users/K/Library/Application Support/typora-user-images/image-20190422123555983.png)

