---
title: HMM
date: 2019-06-15 09:51:44
tags:
- HMM
- nlp
- NER
toc: true
mathjax: true
---





![image-20190615091128686](http://ww2.sinaimg.cn/large/006tNc79ly1g41m1u2u76j30if09y3zp.jpg)



#### 定义

HMM是关于时序的概率模型，描述一个由隐藏的马尔科夫链随机生成不可观测的状态随机序列，再由各个状态生成一个可观测的观测随机序列。

* 随机生成的状态序列 - state sequence

* 每个状态生成一个观测，由此产生的观测随机序列- 观测序列 (observation sequence)

  * 前提假设，当前时刻的观测值只依赖于当前时刻的隐状态

    > Hence we have assumed that the value for the random variable X_i depends only on
    > the value of Y_i. 

<!--more--> 

$$Q = \{q_1,q_2,…,q_N\}, V = \{v_1,v_2,…v_M\}$$

Q表示所有可能的状态集合，V是所有可能的观测集合

* 词性标注中，q代表要预测的词性(一个词可能对应多个词性)，是隐状态，v代表词语，是可以观测到的
* 分词，q代表标签(B,E这种标签，代表一个词的开始，或者中间)， v代表词语，可以观测到
* NER中，q代表标签(地点词，或者时间词)， v代表词语



#### 三要素

$\lambda = (A,B,\pi)$ 再加上 具体的状态集合Q和观测序列V构成HMM五元组

* A为状态转移概率矩阵

$a_{i j}=P\left(i_{t+1}=q_{j} | i_{t}=q_{i}\right), \quad i=1,2, \cdots, N ; j=1,2, \cdots, N$

在时刻t处于状态$q_i$的条件下在时刻t+1转移到状态$q_j$的概率

* B 是观测概率矩阵

$b_{j}(k)=P\left(o_{t}=v_{k} | i_{t}=q_{j}\right), \quad k=1,2, \cdots, M ; j=1,2, \cdots, N$ 

是在时刻t处于状态$q_j$的条件下生成观测$v_k$的概率。 (同发射概率 emmision)

* $\pi​$ 初始状态概率向量

$\pi = (\pi_{i})$

$\pi_i = P(i_1 = q_i)$, i=1,2,..N

 

#### 三个基本问题

> 1.概率计算问题
>
> 给定模型 $\lambda = (A,B,\pi)$ 和观测序列O=($o_1,o_2,...o_r$) 计算在模型$\lambda$下观测序列O出现的概率
>
> 2.学习问题
>
> 已知观测序列O=($o_1,o_2,...o_r$), 估计模型参数  $\lambda = (A,B,\pi)$ ，使得在该模型下观测序列概率P(O|$\lambda$ )最大 (极大似然估计方法)
>
> 3.预测问题
>
> decoding问题，已知$\lambda = (A,B,\pi)​$ 和观测序列O=($o_1,o_2,...o_r​$) ， 给定观测序列，求对应的最有可能的状态序列





#####针对第一个问题

假设状态数目N，观察值K，总共观察长度T

总共路径个数是 $N^T$ 

* 前向算法
* 后向算法



##### 针对第二个问题

利用极大似然估计的方法，从training samples中估计出 状态转移概率，以及发射概率。

一阶马尔科夫:

q(s|u) = $\frac{c(u,s)}{c(u)}$  c(u,s) 指的是training samples中 state u, state s 同时出现的概率

e(x|s) = $\frac{c(s->x)}{c(s)}​$  c(s->x) 指的是训练集中 state s 对应的观测值是 x的次数

初始隐状态分布 $\pi$ 的估计

> generates sequence pairs $ y_1 . . . y_{n+1}, x_{1} . . . x_{n}:$  其中 $y_i$ 代表隐状态, $x_i$ 代表观测状态
>
> 1. Initialize  i=1and  $y_0$ = *. 
>
> 2. Generate $y_i$ from the distribution $q(y_i|y_{i-1})$   状态转移概率
>
> 3. If $y_i$ = STOP, then return $y_{1} \ldots y_{i}, x_{1} \ldots x_{i-1}$ , otherwise, generates $x_i$ from distribution $e(x_i|y_i)$ 
>
>    set i = i + 1, return to step 2



##### 针对第三个问题

从训练集中学到了 $\lambda = (A,B,\pi)$ ， 测试的时候，给定一个观测序列，如何求其对应的可能性最大的隐状态。

* 一种思路是遍历所有可能的隐状态序列，求出其中probability最大的隐状态序列
  * 序列长度n,隐状态空间可能取值一共K种，那么所有的隐状态序列一共有$K^n$ 种情况
* 上述方法当序列长度较大时，复杂度极高，因此采用 Viterbi算法来求解



Viterbi



$r\left(y_{-1}, y_{0}, y_{1}, \ldots, y_{k}\right)=\prod_{i=1}^{k} q\left(y_{i} | y_{i-2}, y_{i-1}\right) \prod_{i=1}^{k} e\left(x_{i} | y_{i}\right)$

$\begin{aligned} p\left(x_{1} \ldots x_{n}, y_{1} \ldots y_{n+1}\right) &=r\left(*, *, y_{1}, \ldots, y_{n}\right) \times q\left(y_{n+1} | y_{n-1}, y_{n}\right) \\ &=r\left(*, *, y_{1}, \ldots, y_{n}\right) \times q\left(\operatorname{STOP} | y_{n-1}, y_{n}\right) \end{aligned}$

$\pi(k, u, v)=\max _{\left\langle y_{-1}, y_{0}, y_{1}, \ldots, y_{k}\right\rangle \in S(k, u, v)} r\left(y_{-1}, y_{0}, y_{1}, \ldots, y_{k}\right)$

$\pi\left(0,^{*},^{*}\right)=1$

$\pi(k, u, v)=\max _{w \in \mathcal{K}_{k-2}}\left(\pi(k-1, w, u) \times q(v | w, u) \times e\left(x_{k} | v\right)\right)$ simply search over all possible values for w, and return the maximum

> The running time for the algorithm is O(n|K|3), hence it is linear in the length of the sequence, and cubic in the number of tags.



#### 应对序列标注中OOV情况

在HMM中的参数估计部分 $e(x|s) = \frac{c(s->x)}{c(s)}$ 发射概率

>c(s -> x) is the number of times state s is paired with word x in the training
>data, and c(s) is the number of times state s is seen in training data.

对于那些只出现在test data 而没有出现在training data中的x e(x|s) 为0



* 缓解方式

>map low frequency words in training data, and in addition words seen in test data but never seen in training, to a relatively small set of pseudo-words.

思想就是低频词以及OOV的映射。 映射样例如下

通过这种映射可以cover某些OOV，以及减少词库大小 ，保证测试数据中的词至少在training data 中都出现一次(assuming that each pseudo-word is seen at least once in training, which is generally the case))

![image-20190615094837961](http://ww4.sinaimg.cn/large/006tNc79ly1g41m1upbg3j30jf0c9q5d.jpg)