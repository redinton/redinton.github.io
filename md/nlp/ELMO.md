



[TOC]



### ELMo

论文 Deep contextualized word representations

* complex **characteristics of word** use (e.g., syntax and semantics)
* how these uses vary across linguistic **contexts** (i.e., to model polysemy)



ELMO的本质思想是：我事**先用语言模型学好一个单词的Word Embedding**，此时多义词无法区分，不过这没关系。在我实际使用Word Embedding的时候，单词已经具备了特定的上下文了，这个时候我可以**根据上下文单词的语义去调整单词的Word Embedding表示**，这样经过调整后的Word Embedding更能表达在这个上下文中的具体含义，自然也就解决了多义词的问题了。所以ELMO本身是个**根据当前上下文对Word Embedding动态调整**的思路。





#### LM  简介

一般涉及到用多层RNN结构来做nlp task的都是取最后一层RNN的output, 而本模型模型所学到的是 a l**inear combination** of the vectors stacked above each input word for each end task. 也就是每层rnn的输出的线性组合。



forward LM： $p\left(t_{1}, t_{2}, \ldots, t_{N}\right)=\prod_{k=1}^{N} p\left(t_{k} | t_{1}, t_{2}, \ldots, t_{k-1}\right)$

backward LM : $p\left(t_{1}, t_{2}, \ldots, t_{N}\right)=\prod_{k=1}^{N} p\left(t_{k} | t_{k+1}, t_{k+2}, \ldots, t_{N}\right)$

BiLM: maximize the log likelihood of the forward and backward directions:

$\begin{array}{l}{\sum_{k=1}^{N}\left(\log p\left(t_{k} | t_{1}, \ldots, t_{k-1} ; \Theta_{x}, \vec{\Theta}_{L S T M}, \Theta_{s}\right)\right.} {\quad+\log p\left(t_{k} | t_{k+1}, \ldots, t_{N} ; \Theta_{x}, \widetilde{\Theta}_{L S T M}, \Theta_{s}\right) )}\end{array}$

share some weights between directions instead of using completely independent parameters.



#### ELMo的内部

ELMo word representations are functions of the entire input sentence,

ELMo is a task specific **combination of the intermediate layer representations** in the biLM.

对于每一个token $t_k$ , a L-layer biLM computes a set of 2L +1 representations

$R_{k}=\left\{\mathbf{x}_{k}^{L M}, \overrightarrow{\mathbf{h}}_{k, j}^{LM},\overleftarrow{\mathbf{h}}_{k, j}^{LM} | j=1, \ldots, L\right\}$ 每一层LSTM的双向表示,一共L层，就是2L representation

而在下游任务中，ELMO一般不会给一个$R_k$这样的表示，而是把所有R中的representation整合成一个single vector。 简单的话，直接取top layer。 Generally，一般如下表示

$\mathbf{E} \mathbf{L} \mathbf{M} \mathbf{o}_{k}^{t a s k}=E\left(R_{k} ; \Theta^{t a s k}\right)=\gamma^{t a s k} \sum_{j=0}^{L} s_{j}^{t a s k} \mathbf{h}_{k, j}^{L M}$

第k个token, L+1层layer的linear combination(第0层指的是token本身的word embedding)。

* $s^{task}$是softmax-normalized weights, 这组权重不仅仅代表的是权重, 因为每层LSTM内部状态,也就是 h 的分布是不同的, 这个也可以用作layer normalization.

* scalar $r^{task}​$ 允许缩放整个elmo vector.

* 针对$r^{task}$ 变量的作用，论文说是

  > r is of practical importance to aid the optimization process",Considering that the activations of each biLM layer have a different distribution, in some cases it also helped to apply layer normalization to each biLM layer before weighting
  >
  > BiLM的内部表征和具体任务的表征的分布是不一样的. 在没有这个的情况下, 只采用该模型的最后一层输出作为词向量的时候的效果甚至差于 baseline



#### ELMo中原始token对应的embedding怎么获得



#### ELMo 学到了什么？

- higher-level LSTM states capture **context-dependent** aspects of word meaning
  - 通过对比在 supervised word sense disambiguation任务上的表现,用high level的rnn的hidden state效果更好得出的结论，high level的rnn hidden state学到的更多是 semantic层面的知识，且与context相关
- lower- level states model aspects of syntax
  - 通过对比在part-of-speech tagging 任务上的表现,用lower level的rnn的hidden state效果更好得出的结论，lower level的rnn hidden state学到的更多是 syntax层面的知识。





#### 正则参数怎么选？

> The choice of the regularization parameter  \lambda is also important, as large values such as \lambda =1 effectively reduce the weighting function to a simple average over the layers, while smaller values (e.g., \lambda =0.001) allow the layer weights to vary



#### ELMo vector 加在什么位置？

> * include word embeddings only as input to the lowest layer biRNN.
>
> * including ELMo at the output of the biRNN by introducing another set of output specific linear weights and replacing h_k with  [h_k; ELMo_k]   in task-specific architectures improves overall results for some tasks.
>   *  针对SNLI and SQuAD 有效, 针对 SRL and coreference resolution没有起到作用



#### Sample efficiency

* 实验还发现，添加ELMo可以有效减少模型收敛所需的epoch

> For example, the SRL model reaches a maximum development F1 after 486 epochs of training without ELMo. After adding ELMo, the model exceeds the baseline maximum at epoch 10, a 98% relative decrease in the number of updates needed to to reach  the same level of performance

* 此外，ELMo-enhanced model 相对没有ELMo的 在小数据集上表现更好

![image-20190604103454577](/Users/K/Library/Application Support/typora-user-images/image-20190604103454577.png)

横坐标是数据集大小，纵坐标是performance





### Char CNN

ELMo中的word embedding来自于 char CNN, 其结构来自于下面这篇文章。

Character-Aware Neural Language Models



![image-20190604161844371](/Users/K/Library/Application Support/typora-user-images/image-20190604161844371.png)



* 首先单词"absurdity",每一个char先经过一个char embedding matrix投影，然后concat在一起。
* 之后经过multiple narrow filter 卷积后的结果，再经过maxpooling over time
  * 此时输出的结果的维度是 number of filters, 是一个定值，一定程度上可以看作为word embedding dimension
* 之后输入到highway network中，再把结果输入到LSTM中



#### Char embedding

Let C be the vocabulary of characters, d be the dimensionality of character embeddings, and Q ∈ $R^{d×|C|}$ be the matrix character embeddings. 

Suppose that word k ∈ V is made up of a sequence of characters [$c_1$, . . . , $c_l$], where l is the length ofword k. Then the character-level representation of k is given by the matrix $C^{k} ∈ R^{d×l}$, where the j-th column corresponds to the character embedding for $c_j$ (i.e. the $c_j$-th column of Q).

通常词汇表V(指的是char的数目)很小，有些文章中会用one-hot来represent char embedding, 然而作者发现

> that using lower dimensional representations of characters (i.e. d < |C|) performed slightly better



#### Highway

原始的MLP如下：$\mathbf{z}=g(\mathbf{W} \mathbf{y}+\mathbf{b})$

one layer of a highway network does the following: 

$\mathbf{z}=\mathbf{t} \odot g\left(\mathbf{W}_{H} \mathbf{y}+\mathbf{b}_{H}\right)+(\mathbf{1}-\mathbf{t}) \odot \mathbf{y}$ 

其中 y是当前的输入，t是transforma gate $\mathbf{t}=\sigma\left(\mathbf{W}_{T  \mathbf{Y}}+\mathbf{b}_{T}\right)$ 而 1-t 指的是 carry gate (这里是为了节省参数量用了 1-t 一般carry gate 的参数也可以通过设置变量来学习), g 是nonlinearity



#### Metric

ppl

Perplexity of a model over a sequence [w1, . . . , wT] is given by  PPL

$P P L=\exp \left(\frac{N L L}{T}\right)$ 



#### Bi-LSTM Highway

![image-20190604183348469](/Users/K/Library/Application Support/typora-user-images/image-20190604183348469.png)

B 指的是 Bi-LSTM， T指的是 Transform gate， C指的是 carry gate。

