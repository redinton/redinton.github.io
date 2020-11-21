



[TOC]

###RNN-self attention

A STRUCTURED SELF-ATTENTIVE  SENTENCE EMBEDDING (2017 ICLR)



![image-20190404215152575](/Users/K/Library/Application Support/typora-user-images/image-20190404215152575.png)

* 长度为n的sentence经过一层Bi-LSTM得到n个hidden_state(每个hidden_state前后向拼接在一起得到2u),然后通过加权得到矩阵M.
* $W_{s1}$维度是$d_a * 2u$, concat hidden_state维度是 $2u * n$ ,两者相乘得到 $d_a * n$ 暂时记作tmp
* 原本$W_{s2}$是$1 * d_a$, 最后得到的结果是  $ 1 * n$ , softmax后刚好可以作为每个hidden_state的权重
* **$W_{s2}$的维度变为$r * d_a$ 的初衷是希望每一个 $1*d_a$ 关注到句子的某一部分，这样可以分别关注句子的r个**部分



weight的计算方式如下

$A = softmax(W_{s2}tanh(W_{s1}H^{T}))$ 

最终得到的所谓的句子的embedding matrix  $r * 2u$

$M = AH​$





#### 模型的修正方式

* 虽然设想 r个“attention”，每个可以关注到sentence的不同部分，但很多时候都是类似的。

  * 问题在于**如何增加weight vector(指的就是每一个attention)的diversit**y？

  * 衡量两个vector之间的diversity有一个不错的方式就是KL-divergence。 这时候我们要maximize多个KL-divergence(r个attention两两之间的KL)。但是我们想要每一个attention尽可能focus在一个aspect上，意味着每个attention中权重中的"probability mass"尽可能出现的集中。

  本文提出了 $P = ||(AA^T-I)||_F^2$ 作为一个penalization的方式,衡量redundency

  $||*||_F$ 是Frobenius norm of a matrix,类似于加一个L2



####Conclusion

引入 attention，使得最终的sentence embedding可以直接访问到之前每一个时刻的hidden_state，

对于LSTM来说，每一个hidden_state只能捕捉到短期的一个context 信息，而长期的依赖还是需要通过"attention"来捕捉

![image-20190404222128079](/Users/K/Library/Application Support/typora-user-images/image-20190404222128079.png)



![image-20190404222209911](/Users/K/Library/Application Support/typora-user-images/image-20190404222209911.png)

#### Contribution

本文借助两个矩阵$W_{S_{1}},W_{S_{2}}$ 实现了对LSTM所有hidden_state的一个映射，最终得到r个attention weight分布。作者解读是这样可以让模型分别关注r处句子的不同部分。(r是$W_{s_{1}}$)的维度。



####个人问题

* 为什么需要两个矩阵来映射得到r个attention分布，不能一个吗？ 是否可以理解成是 2-layer的一种表示，相当于加了一层hidden_state可以学到更多信息？





### DCNN - dynamic k-max pooling

A Convolutional Neural Network for Modelling Sentences



![image-20190411155659033](/Users/K/Library/Application Support/typora-user-images/image-20190411155659033.png)

上图就是一个动态CNN处理输入句子的过程，卷积filters的宽度是2和3，通过动态pooling，可以在高层获取句子中相离较远词语间的联系





![image-20190411153046040](/Users/K/Library/Application Support/typora-user-images/image-20190411153046040.png)

* 宽卷积

  * ![image-20190411153324399](/Users/K/Library/Application Support/typora-user-images/image-20190411153324399.png)

  * 宽卷积使得conv后的feature map更宽

* k-max pooling 

  * 给定一个K值和一个序列P，选择序列P中得分最大的前k个特征值组成的子序列，并且保留原来序列的次序。
  * 好处在于**提取了句子中不止一个的重要信息**，**保留了它们的相对位置**。

* dynamic k-max pooling

  * $k_{l}=\max \left(k_{t o p},\left\lceil\frac{L-l}{L} s\right\rceil\right)$
  * $l$是当前卷积层的层数，L是网络中总共卷积层的层数，Ktop为最顶层对应的K值，是固定值，s是句子的长度。例如网络中有3个卷积层，Ktop=3，s=18，第一层卷积层下面的pooling参数K1=12，K2=6，K3=3。
  * 假设固定了最后一层输出位置的K max-pooling的k值，然后自定义深度，通过这个公式可以计算出每一层k-max pooling的k值

* Folding

  * 沿着embedding方向相加，比如原来embedding 300维 一次folding后变成150维



#### Contribution

- 保留了句子中词序信息和词语之间的相对位置；
- 宽卷积的结果是传统卷积的一个扩展，某种意义上，也是n-gram的一个扩展；
- 模型不需要任何的先验知识，例如句法依存树等，并且模型考虑了句子中相隔较远的词语之间的语义信息；



[参考1](https://zhuanlan.zhihu.com/p/29925124) [code](https://github.com/hritik25/Dynamic-CNN-for-Modelling-Sentences/blob/master/architecture.py)

[参考2](http://www.jeyzhang.com/cnn-apply-on-modelling-sentence.html)

