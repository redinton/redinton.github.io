

[TOC]



#### 解决什么问题

* Bert在应用transformer的时候需要定义seq-length,也就是输入的sequence长度有限制。原因是太长的序列对内存的开销很大。

* 对于长文本语料，若想要用transformer来train势必需要切割或者padding，会造成语义的不连贯(因为transformer并没有hidden_state加以链接)



#### 解决方法

transformer xl通过引入类似RNN recurrence机制。