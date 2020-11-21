







Pytorch loss function 总结

由于一般损失函数都是直接用 batch的数据计算，返回的loss 维度是 (batch_size, )

* reduce
  * False, size_average 失效， 返回 vector 形式的 loss
* size_average
  * 当且仅当reduce = True 时，返回标量
    * True , 返回 loss.mean()
    * False. 返回 loss.sum( )



#### torch.nn.L1Loss

$$
\operatorname{loss}(x, y)=1 / n \sum\left|x_{i}-y_{i}\right|
$$

x,y 的维度需要一致, 除以n是 size_average = True的情况

#### torch.nn.SmoothL1Loss

$$
\operatorname{loss}\left(x_{i}, y_{i}\right)=\left\{\begin{array}{c}{0.5 *\left(x_{i}-y_{i}\right)^{2},\left|x_{i}-y_{j}\right|<1} \\ {\left|x_{i}-y_{i}\right|-0.5, \text { otherwise }}\end{array}\right.
$$

* 也叫做Huber loss, 在(-1,1)上是L2 loss
* 其他情况是L1 loss
* 对于异常点的敏感性不如MSELoss, 但在某些情况下防止了梯度爆炸



#### torch.nn.MSELoss

$$
\operatorname{loss}(x, y)=1 / n \sum\left(x_{i}-y_{i}\right)^{2}
$$

除以n是 size_average = True的情况



### 按照功能划分

#### 多分类 torch.nn.CrossEntropyLoss

这里指的是多类别，类别之间互斥。

将NLLLoss和LogSoftMax集成到一个类中。
$$
\operatorname{loss}(x, \text { class })=-\log \frac{\exp (x[\text {class}])}{\sum_{j} \exp (x[j]) )} \quad=-x[\text {class}]+\log \left(\sum_{j} \exp (x[j])\right)
$$
使用时，前面不需要经过softmax层。class是one-hot的形式。

样本不均衡时，同样可以考虑设置 weights,把样本少的类别，权重设大一点。

target 类型为torch.LongTensor



#### 多分类 torch.nn.NLLLoss

Negative log likelihood 用于训练一个n类分类器。

使用时，需要在model输出加上LogSoftmax 来获得类别的log-probabilities

若不加LogSoftmax可以考虑直接用CrossEntropyLoss



#### 多标签分类 torch.nn.BCELoss

* 计算 target 与 output之间的 二分类 交叉熵。

* 在该层之前需要加一个**Sigmoid 函数**
* 有一个 **weight** 参数
  * 用于**样本数目不均衡的**时候，修改各类的权重

 $$  loss(o,t)=-\frac{1}{n}\sum_i(t[i] *log(o[i])+(1-t[i])*log(1-o[i]))  $$

x,y,w的维度都一致

**对于每个sample的每一列都算一次二分类的cross-entropy loss, 然后按列取平均,相当于每个标签的二分类。**

```python
input = torch.randn(2,3)  ## 两个sample，三个标签
input:
  [[-0.4089,-1.2471,0.5907],
   [-0.4897,-0.8267,-0.7349]]
m = nn.Sigmoid()
m(input)
  [[0.3992,0.2232,0.6435]
   [0.3800,0.3044,0.3241]]
target = torch.FloatTensor([[0,1,1],
                            [0,0,1]])
## 按照公式计算
## 对于第一个sample
(0*ln(0.3992)+(1-0)*ln(1-0.3992) + 1*ln(0.2232)+(1-1)*ln(1-0.2232) + 1*ln(0.6435)+(1-1)*ln(1-0.6435)) / 3
```

#### 多标签分类 torch.nn.BCELogitsLoss

同上，只不过省去了Sigmoid这一步。



#### torch.nn.MultiLabelMarginLoss







#### torch.nn.KLDivLoss

KL散度常用来描述俩个分布的距离，并在输出分布的空间上执行直接回归,KL散度，又叫做相对熵

输入是log-probabilities
$$
\operatorname{loss}(x, \text { target })=\frac{1}{n} \sum_{i}\left(\text { target }_{i} *\left(\log \left(\text {target}_{i}\right)-x_{i}\right)\right)
$$