

[TOC]



### Gradient vanishing

#### 原因

![image-20190720205251661](/Users/K/Library/Application Support/typora-user-images/image-20190720205251661.png)

$j^4(\theta)$对$h^(1)$的导数, 可能很小 由于 chain rule 连乘的关系

![image-20190720205425720](/Users/K/Library/Application Support/typora-user-images/image-20190720205425720.png)



#### 导致的后果

1.某个时间刻的值受到更靠近这个时刻的loss的影响, 因为越靠近 越不容易 梯度消失

![image-20190720205613190](/Users/K/Library/Application Support/typora-user-images/image-20190720205613190.png)

2.更难捕捉长距离的依赖关系

![image-20190720205715137](/Users/K/Library/Application Support/typora-user-images/image-20190720205715137.png)

#### 解决方法

LSTM

![image-20190720221408385](/Users/K/Library/Application Support/typora-user-images/image-20190720221408385.png)

GRU

![image-20190721093305806](/Users/K/Library/Application Support/typora-user-images/image-20190721093305806.png)





### Gradient exploding

#### 可能导致的问题

$$
\theta^{n e w}=\theta^{o l d}-\alpha \nabla_{\theta} J(\theta)
$$

gradient 很大意味着在SGD更新的时候会 take a big step

最坏情况可能导致 inf or Nan 在网络中

#### 解决方法

1.gradient clipping: scale the gradient down if its norm is greater than threshold

![image-20190720220424396](/Users/K/Library/Application Support/typora-user-images/image-20190720220424396.png)

ituition 的解释就是 take a step in the same direction  but a smaller step



### Skip-connection

同样也可以用来解决梯度消失的问题

![image-20190721093626306](/Users/K/Library/Application Support/typora-user-images/image-20190721093626306.png)

1.identity connection 保留原始的信息，如果左边的两层weight layer 都接近于0,那么输出的结果相当于noisy identity connection

2.F(x) + X



### Highway connection

Similar  to residual connection, but the identity connection vs the transformation layer is controlled by a **dynamic gate.**

