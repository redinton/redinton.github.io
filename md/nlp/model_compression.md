[TOC]

### 模型压缩



#### Network Pruning

Networks are typically over-parameterized (there is significant  redundant weights or neurons

* 基于度量标准

  * Importance of a weight : 权重的大小

  * Importance of a neuron
    * the number of times it wasn’t zero on a given data set …	

  * After pruning, the accuracy will drop (hopefully not too much) Fine-tuning on training data for recover
  * weight pruning
    * hard to implement , hard to speed up
  * Neuron pruning
    * easy to implement, easy to speed up



#### Knowledge Distillation

![image-20200110154317432](/home/xyu3/md/img/image-20200110154317432.png)



* Teacher net 比较大，train完一个比较大的large net
  * 利用teacher net 的输出来 train 一个小模型(student model)
    * 因为teacher net 的输出结果**信息更加的全面**，方便train model

![image-20200110162119597](/home/xyu3/md/img/image-20200110162119597.png)

用于缩放teacher net的 output 结果之间的影响权重

#### Parameter Quantization

*  Using less bits to represent a value
*  Weight clustering
  * ![image-20200110153924858](/home/xyu3/md/img/image-20200110153924858.png)

*  Represent frequent clusters by less bits, represent rare clusters by more bits
  * Huffman encoding

  

#### Architecture  Design

主要用了 low rank approximation

![image-20200110162345621](/home/xyu3/md/img/image-20200110162345621.png)

在两层网络之间再插一层来approximate 之前两层所达到的效果，而且这样利用到的parameter 更少

利用 low rank 的approximation 来拟合



* 卷积也可以用类似的操作减少参数量

  depthwise separable convolution

  ![image-20200110163006471](/home/xyu3/md/img/image-20200110163006471.png)



filter的数目就是输入的channel数目，每一个filter就只去卷积特定的某一channel

![image-20200110163304924](/home/xyu3/md/img/image-20200110163304924.png)

pointwise 用的就是1*1的filter，chanel数目和原来的输入的channel一致。





#### Dynamic  Computation

当资源充足的时候就全力运算，资源不足的时候就少算一点

![image-20200110163851986](/home/xyu3/.config/Typora/typora-user-images/image-20200110163851986.png)

