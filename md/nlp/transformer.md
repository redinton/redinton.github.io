[TOC]



### Transformer

#### model overview

![image-20190405165847168](/Users/K/Library/Application Support/typora-user-images/image-20190405165847168.png)



And the specific part inside the encoder and decoder

![image-20190405170051456](/Users/K/Library/Application Support/typora-user-images/image-20190405170051456.png)



#### Encoder

![image-20190405170531735](/Users/K/Library/Application Support/typora-user-images/image-20190405170531735.png)



What does the self-attention exactly do ?

![image-20190405170605860](/Users/K/Library/Application Support/typora-user-images/image-20190405170605860.png)

Help the model to learn that it refers to "animal"



 #### Self-attention 

![image-20190405170722712](/Users/K/Library/Application Support/typora-user-images/image-20190405170722712.png)

* 有三个matrix $W^{Q},W^{K},W^{V}$ 维度是 $r * embedding\_size$ .

* 每一个输入词的embedding通过这三个矩阵可以分别映射成 三个 vector , q和k 之间的点乘 可以得到一个数值。

* 对于每一个输入的词的q，与所有的输入词的k点乘，得到的结果softmax后作为权重，加权对应的v，得到每一个词的表示。



![image-20190405171306240](/Users/K/Library/Application Support/typora-user-images/image-20190405171306240.png)

图中的$d_k$就是key vector的维度

一般对于每个词来说，其对应位置得到的$q*k$的值一般会处于dominate，因此更新后的$z_i$ 向量其中更多来自于对应的$v_i$.



#### Self attention 计算的矩阵表示

![image-20190405171739602](/Users/K/Library/Application Support/typora-user-images/image-20190405171739602.png)

![image-20190405171757250](/Users/K/Library/Application Support/typora-user-images/image-20190405171757250.png)



#### Multi-heads

1. It expands the model’s ability to focus on different positions. Yes, in the example above, z1 contains a little bit of every other encoding, but it could be dominated by the the actual word itself. It would be useful if we’re translating a sentence like “The animal didn’t cross the street because it was too tired”, we would want to know which word “it” refers to.
2. It gives the attention layer multiple “representation subspaces”. As we’ll see next, with multi-headed attention we have not only one, but multiple sets of Query/Key/Value weight matrices (the Transformer uses eight attention heads, so we end up with eight sets for each encoder/decoder). Each of these sets is randomly initialized. Then, after training, each set is used to project the input embeddings (or vectors from lower encoders/decoders) into a different representation subspace.

![image-20190405172553784](/Users/K/Library/Application Support/typora-user-images/image-20190405172553784.png)

multi-heads 意味着有多组self-attention，每一组self-attention最终都可以输出一组Z matrix， 例如8个heads就得到如下的结果

![image-20190405172813210](/Users/K/Library/Application Support/typora-user-images/image-20190405172813210.png)

对于self-attention之后的feed-forward来说，需要的是一组输入，而不是多组

transformer的处理方式如下

* 1. 把这8个matrix 先concatenate在一起然后，通过一个额外的矩阵投影成原始大小
     1. ![image-20190405173106617](/Users/K/Library/Application Support/typora-user-images/image-20190405173106617.png)

整个的流程图也如下

![image-20190405173242123](/Users/K/Library/Application Support/typora-user-images/image-20190405173242123.png)



从图片中可以看到，在8个head的self-attention下，每个head的attention都关注在不同的区域，如图中第一个head，表示it关注某个。

![image-20190405173334600](/Users/K/Library/Application Support/typora-user-images/image-20190405173334600.png)





#### position embedding



![image-20190405181703166](/Users/K/Library/Application Support/typora-user-images/image-20190405181703166.png)



输入model的embedding都是position的+word embedding



#### encoder detail

![image-20190405181829606](/Users/K/Library/Application Support/typora-user-images/image-20190405181829606.png)

![image-20190405182043778](/Users/K/Library/Application Support/typora-user-images/image-20190405182043778.png)

In the decoder, the self-attention layer is only allowed to attend to earlier positions in the output sequence. This is done by masking future positions (setting them to `-inf`) before the softmax step in the self-attention calculation.



#### 几个问题

* 算self attention的时候 为什么归一化是除以$\sqrt{d_k}$

To illustrate why the dot products get large, assume that the components of q and k are independent random variables with mean 0 and variance 1. Then their dot product, $q \cdot k=\sum_{i=1}^{d_{k}} q_{i} k_{i}$ has mean 0 and variance $d_{k}$). To counteract this effect, we scale the dot products by $\frac{1}{\sqrt{d_k}}$

* 左边stack的6层encoder 怎么和右边的decoder连接

![image-20190602164913889](/Users/K/Library/Application Support/typora-user-images/image-20190602164913889.png)

encoder的输出会和每一层的decoder结合。

### Ref

[jalammar](<http://jalammar.github.io/illustrated-transformer/>)

