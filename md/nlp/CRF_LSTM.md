

[TOC]





### CRF

[理解CRF](<https://www.jianshu.com/p/55755fc649b1>)

词性任务标注问题 - 对于一个句子可能有多种标注序列，从中挑选出最靠谱的作为我们对这句子的标注

判断标注是否靠谱， 常识告诉我们，动词后面一般不会再接动词，因此动词后面再接动词的标注通常可以认为是不好的标注，将他打负分。

上面的"动词后面接动词"就是一个特征函数。通过定义一个特征函数集合，用这个特征函数集合来为标注序列打分。把集合中所有特征函数对同一个标注序列的评分综合起来，就是这个标注序列的最终的评分值。

#### 特征函数

接受四个参数：

- 句子s（就是我们要标注词性的句子）
- i，用来表示句子s中第i个单词
- $l_i$，表示要评分的标注序列给第i个单词标注的词性
- $l_{i-1}$，表示要评分的标注序列给第i-1个单词标注的词性

输出值是**0或者1**。0表示要评分的标注序列不符合这个特征，**1表示要评分的标注序列符合这个特征**。

特征函数仅仅依靠**当前单词的标签和它前面的单词的标签**对标注序列进行评判，这样建立的CRF也叫作线性链CRF，这是CRF中的一种简单情况。



定义好一组特征函数后，我们要给每个特征函数$f_j$赋予一个权重$λ_j$。现在，只要有一个句子s，有一个标注序列l，我们就可以利用前面定义的特征函数集来对l评分。

$\operatorname{score}(l | s)=\sum_{j=1}^{m} \sum_{i=1}^{n} \lambda_{j} f_{j}\left(s, i, l_{i}, l_{i-1}\right)$

外面的求和用来求每一个特征函数$f_j$评分值的和，里面的求和用来求句子中每个位置的单词的的特征值的和。

对**所有序列**的值score  用softmax归一化后

$p(l | s)=\frac{\exp [\operatorname{score}(l | s)]}{\sum_{l^{\prime}} \exp \left[\operatorname{score}\left(l^{\prime} | s\right)\right]}$



#### CRF++

* 通过定义特征模板，用模板自动批量产生大量的特征函数
* 每一个模板在每一个token处产生若干个特征函数
* 模板有U系列(unigram)，B系列(bigram)
* 需要定义 状态特征函数， 转移特征函数



* CRF是判别式模型
  * CRF是全局范围内统计归一化的条件状态转移概率矩阵，再预测出一条指定的sample的每个token的label
  * LSTM 在训练时将samples通过复杂到让你窒息的高阶高纬度异度空间的非线性变换，学习出一个模型，然后再预测出一条指定的sample的每个token的label。
  * 关键区别在于，在LSTM+CRF中，**CRF的特征分数直接来源于LSTM传上来的Hi的值**；而在general CRF中，**分数是统计来的。**所有导致有的同学认为LSTM+CRF中其实并没有实际意义的CRF。其实按刚才说的，Hi本身当做特征分数形成transition matrix再让viterbi进行路径搜索，这整个其实就是CRF的意义了。所以LSTM+CRF中的CRF没毛病
* HMM是生成式模型

![image-20190604231835015](/Users/K/Library/Application Support/typora-user-images/image-20190604231835015.png)



####CRF与HMM的比较

$p(l, s)=p\left(l_{1}\right) \prod_{i} p\left(l_{i} | l_{i-1}\right) p\left(w_{i} | l_{i}\right)$

HMM的思路是用生成办法，就是说，在已知要标注的句子s的情况下，去判断生成标注序列l的概率

$p(l_i|l_{i-1})$是转移概率，比如，$l_{i-1}$是介词，$l_i$是名词，此时的p表示介词后面的词是名词的概率。$p(w_i|l_i)$表示发射概率（emission probability），比如$l_i$是名词，$w_i$是单词“ball”，此时的p表示在是名词的状态下，是单词“ball”的概率。

* HMM模型中存在两个假设：一是输出观察值之间严格独立，二是状态的转移过程中当前状态只与前一状态有关。但实际上序列标注问题不仅和单个词相关，而且和观察序列的长度，单词的上下文，等等相关
  * HMM只限定在了观测与状态之间的依赖
* HMM是有向图 而 CRF是无向图



###Bi-LSTM CRF

![image-20190530141106917](/Users/K/Library/Application Support/typora-user-images/image-20190530141106917.png)

BiLSTM层的输出表示该单词对应各个类别的分数。这些分数将会是**CRF层的输入**。

* **CRF层可以学习到句子的约束条件**

  加入一些**约束来保证最终预测结果是有效**的。这些约束可以在训练数据时被CRF层自动学习得到。

  * 句子的开头应该是“B-”或“O”，而不是“I-”
  * “B-label1 I-label2 I-label3…”，在该模式中，类别1,2,3应该是同一种实体类别。比如，“B-Person I-Person” 是正确的，而“B-Person I-Organization”则是错误的。
  * “O I-label”是错误的，命名实体的开头应该是“B-”而不是“I-”。

* CRF的损失函数

  * **Emission score**

    * 来自BiLSTM层的输出

  * transmission score

    * 有一个所有类别间的转移分数矩阵。
    * 为了使转移分数矩阵更具鲁棒性，我们加上START 和 END两类标签。START代表一个句子的开始（不是句子的第一个单词），END代表一个句子的结束。

    ![image-20190530141532715](/Users/K/Library/Application Support/typora-user-images/image-20190530141532715.png)

在训练模型之前，你可以**随机初始化转移矩阵**的分数。这些分数将随着训练的迭代过程被更新，换句话说，CRF层可以自己学到这些约束条件。

CRF损失函数由两部分组成，真实路径的分数 和 所有路径的总分数。真实路径的分数应该是所有路径中分数最高的。

每种可能的路径的分数为Pi，共有N条路径，则路径的总分是

$P_{\text {total}}=P_{1}+P_{2}+\ldots+P_{N}=e^{s_{1}}+e^{s_{2}}+\ldots+e^{s_{N}}$

$\text {LossFunction}=\frac{P_{\text {Realpath}}}{P_{1}+P_{2}+\ldots+P_{N}}$

**Si = EmissionScore + TransitionScore**

以**“START B-Person I-Person O B-Organization O END”这条真实路径来说**,句子中有5个单词, w1,w2,w3,w4,w5, 加上START和END 在句子的开始位置和结束位置，记为，w0，w6

$\text {EmissionScore}=x_{0, S T A R T}+x_{1, B-P e r s o n}+x_{2, I-P e r s o n}+x_{2, I-P e r s o n}+x_{3, O}+x_{4, B-O r g a n i z a t i o n}+x_{5, O}+x_{6, E N D}$

这些分数来自BiLSTM层的输出，至于x0,START 和x6,END ，则设为0。

$\begin{array}{l}{\text {TransitionScore}=} \\ {t_{S T A R T->B-P e r s o n}+t_{B-P e r s o n->I-P e r s o n}+ t_{I-P e r s o n->} O+t_{0->B-\text {Organization}}+t_{B-\text {Organization}->O}+t_{O->E N D}}\end{array} $ 

**这些分数来自于CRF层，将这两类分数加和即可得到Si 和 路径分数**$e^{Si}$



$\text {LOGLossFunction}=log\frac{P_{\text {Realpath}}}{P_{1}+P_{2}+\ldots+P_{N}}$

![image-20190530142409350](/Users/K/Library/Application Support/typora-user-images/image-20190530142409350.png)

