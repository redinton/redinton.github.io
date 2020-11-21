[TOC]





#### Questions

##### bert的mask任务中15%怎么得来的



##### bert的mask相对于CBOW有什么相同与不同



##### bert有哪些tricks，为什么会好用，mask的方法最开始怎么被提出



##### bert的损失



#####bert有哪些优点，bert是怎样构建的。你是如何应用bert的。



#####Bert的输入是啥



### Pretrain

#### Masked LM(MLM)

* ELMo只是将left-to-right和right-to-left分别训练拼接起来
* 直觉上来讲我们其实想要一个deeply bidirectional的模型，但是普通的LM无法做到
* 随机mask 15%的token，而不是把像cbow一样把每个词都预测一遍。**最终的损失函数只计算被mask掉那个token。**
* 随机mask的时候10%的单词会被替代成其他单词，10%的单词不替换，剩下80%才被替换为[MASK]。
* Masked LM预训练阶段模型是不知道真正被mask的是哪个词，所以模型每个词都要关注。



#### Next Sentence Prediction

涉及到QA和NLI之类的任务,增加了第二个预训练任务，目的是让模型理解两个句子之间的联系。

* 训练的输入是句子A和B，B有一半的几率是A的下一句，输入这两个句子，模型预测B是不是A的下一句。预训练的时候可以达到97-98%的准确度。

* **语料的选取很关键，要选用document-level的而不是sentence-level的，这样可以具备抽象连续长序列特征的能力。**



### Fine-tuning

关于下游任务如何接BERT

* sentence-pair classification 类型的任务
  * MNLI,...
* single sentence classification tasks
* question answering task
* single sentence tagging task



### Pros & Cons

#### Pros

* Transformer，也就是相对rnn更加高效、能捕捉更长距离的依赖。



#### Cons

* 预训练时的mask问题

  * [MASK]标记在实际预测中不会出现，训练时用过多[MASK]影响模型表现
  * 每个batch只有15%的token被预测，所以BERT收敛得比left-to-right模型要慢（它们会预测每个token

  

### 与GPT,ELMO对比

* 双向 Transformer 在文献中通常称为“Transformer 编码器”（Transformer encoder
* 只关注左侧语境的Transformer被称为“Transformer 解码器”（Transformer decoder），因为它能用于文本生成



* BERT 使用双向 Transformer
* OpenAI GPT 使用从左到右的 Transformer
* ELMo 使用独立训练的从左到右和从右到左 LSTM 的级联，来生成下游任务的特征。
* 三种模型中，只有 BERT 表征是联合的，基于所有层中的左右两侧语境。





#### Bert 应用模式

ELMO／GPT／Bert这几个自然语言预训练模型，首先是利用通用语言模型任务，采用自监督学习方法，选择某个具体的特征抽取器来学习预训练模型；第二个阶段，则针对手头的具体监督学习任务，**采取特征集成或者Fine-tuning的应用模式，**

##### **特征集成**

ELMO在下游任务使用预训练模型的时候，把当前要判断的输入句子，走一遍ELMO预训练好的的双层双向LSTM网络，然后把每个输入单词对应位置的高层LSTM激活embedding（或者输入单词对应位置的若干层embedding进行加权求和），作为下游任务单词对应的输入。这是一种典型的应用预训练模型的方法，更侧重于单词的上下文特征表达方面。

**集成了几层LSTM的输出**

##### **Fine-tuning**

获得了预训练模型以及对应的网络结构（Transformer）后，第二个阶段仍然采用与预训练过程相同的网络结构，拿出手头任务的部分训练数据，直接在这个网络上进行模型训练，以针对性地修正预训练阶段获得的网络参数，一般这个阶段被称为Fine-tuning



对于句子匹配类任务，或者说是输入由多个不同组成部分构成的NLP任务，那么在应用Bert的时候，采用Fine-tuning效果是要明显好于特征集成模式的。



#### Bert Fine tune

分类层的输入信息来自于Bert的Transformer特征抽取器的**最高层输出**, 如果不只用最高层，下面几层的输出也拿来用，可能编码了输入句子的不同抽象粒度的特征信息。

* 对于句子对匹配任务，这个[CLS]标记已经编码了足够多的句子匹配所需要的特征信息，所以不再需要额外的特征进行补充。
* 在序列标注任务中，倾向于选择多层特征融合的应用模式。



#### QA 相关

QA的核心问题是：给定用户的自然语言查询问句Q,希望系统从大量候选文档里面找到一个语言片段，这个语言片段能够正确回答用户提出的问题，最好是能够直接把答案A返回给用户.

![image-20190705081608612](/Users/K/Library/Application Support/typora-user-images/image-20190705081608612.png)

检索+QA问答判断

* 首先，把长文档切分成段落或者句子n-gram构成的语言片段(passage), 然后利用搜索的倒排索引建立快速查询机制。
* 第一阶段：检索，通常规搜索过程相同，一般用BM25(或者BM25+RM3)根据问句查询可能的答案所在候选段落或者句子
* 第二阶段:  问答判断
  * 模型训练时，用SQuAD等较大的问答数据集对Bert Fine-tuning, 
  * 应用阶段, 对于第一阶段返回的得分靠前的Top K候选Passage, 将用户问句和候选passage作为Bert的输入，用Bert来做个分类
    * 判断当前Passage是否包括问句的正确答案
    * 或者输出答案的起始终止点



#### 阅读理解与QA区别

* QA中找答案的时候，依赖的上下文更短，参考的信息更局部，答案更表面化
* 阅读理解，要正确定位答案，参考的上下文范围更长，



#### 搜索与信息检索(IR)与QA区别

* 虽然都是query和document的匹配，但匹配侧重的因素不同

  * 文本的“相关性”和“语义相似性”：
    * 相关性，更强调字面内容的精确匹配， 搜索更偏重文本匹配相关性
    * 语义相似性，尽管字面不匹配，但是深层语义方向相近，QA更侧重语义相似性
  * 文档的长度差异，
    * QA中答案可能是一小段语言片段，在passage的较短的范围内，一般包含正确答案，因此QA答案一般比较短，QA倾向于短文本
    * 搜索中，文档普遍长。尽管判断文档与query是否相关是，也许只依赖于长文档中的几个关键passage或者关键句子，但这些片段可能分散在文档的不同地方，而Bert的输入长度有限制
  * 对于QA这种任务，可能文本包含的信息足够作出判断，所以不需要额外的特征信息
    * 搜索这种任务，仅靠文本可能无法特别有效判断查询和文档的相关性，还有其他因素影响例如，链接分析，网页质量，用户行为数据

  

#### Bert 的局限

* 输入文本长度受限
  * **Simple Applications of BERT for Ad Hoc Document Retrieval**





#### 文本数据增强

* **Conditional BERT Contextual Augmentation**

通过改造Bert预训练模型，来产生新增的训练数据，以此来增强任务分类效果。就是说对于某个任务，输入训练数据a，通过Bert，产生训练数据b，利用b来增强分类器性能。

![image-20190705084257386](/Users/K/Library/Application Support/typora-user-images/image-20190705084257386.png)

* 所谓“条件”，意思是对于训练数据a，Mask掉其中的某些单词，要求Bert预测这些被Mask掉的单词，但是与通常的Bert预训练不同的是：它在预测被Mask掉的单词的时候，在输入端附加了一个条件，就是这个训练数据a的类标号，假设训练数据的类标号已知，要求根据训练数据a的类标号以及上下文，通过Bert去预测某些单词。
* 之所以这样，是为了能够产生更有意义的训练数据。比如对于情感计算任务来说，某个具备正向情感的训练实例S，mask掉S中的情感词“good”，要求Bert生成新的训练实例N，如果不做条件约束，那么Bert可能产生预测单词“bad”，这也是合理的，但是作为情感计算来说，类别的含义就完全反转了，而这不是我们想要的。我们想要的是：新产生的训练例子N，也是表达正向情感的，比如可以是“funny”，而如果加上类标号的约束，就可以做到这一点。具体增加约束的方式，则是将原先Bert中输入部分的Sentence embedding部分，替换成输入句子的对应类标号的embedding，这样就可以用来生成满足类条件约束的新的训练数据。这个做法还是很有意思的。

##### 测评结果的方式

通过Bert产生的新训练数据增加到原有的训练数据中，论文证明了能够给CNN和RNN分类器带来稳定的性能提升。



##### 如何使用这些增强的训练数据

* Data Augmentation for BERT Fine-Tuning in Open-Domain Question Answering
  * 如果同时增加通过增强产生的正例和负例，有助于增加Bert的应用效果
  * Stage-wise方式增加增强数据（就是原始训练数据和增强训练数据分多个阶段依次进行训练，而且距**原始训练数据越远的**应该越先进行Fine-tuning），效果好于把增强数据和原始数据混合起来单阶段训练的模式



#### 文档分类

**DocBERT: BERT for Document Classification**

* 对于文本分类，Bert并未能够获得非常大的效果提升
* 把一个还比较长的文档分到一个类别里，这种任务偏语言浅层特征的利用，而且指示性的单词也比较多，应该算是一种比较好解决的任务，任务难度偏简单，Bert的潜力感觉不太容易发挥出来



##### 问题的重构

* 貌似Bert更适合处理句子对关系判断问题。而对于单句分类，或者序列标注问题，尽管有效，但是貌似效果没那么好， 能不能把单句分类问题，或者序列标注问题，转化下问题的表达形式，让它以双句关系判断的表现形态出现呢？
* 

#### 序列标注



BERT-WWM(whole word masking)

原来的BERT是char-level的，因此有可能会出现同一个word中某些char被mask，而某些没有。





#### Fine-tuning的in-domain 和 out-domain

* Out-Domain意思是你手头任务有个数据集合A，但是在Bert的Fine-tuning阶段，用的是其它数据集合B
* In-Domain就是说用手头任务数据集合A去Fine-tune参数，不引入其它数据。



##### 当前任务数据不够

* 如果你手上的任务A训练数据太小，一般而言，尽管也可以用它去做Bert的Fine-tuning，但是无疑，效果可能有限，因为对于参数规模这么大的Bert来讲，太少的Fine-tuning数据，可能无法充分体现任务特点。

* 引入和手头任务A有一定相近性的数据集合B，用B或者A+B去Fine-tune Bert的参数，期待能够从数据集合B Transfer些共性知识给当前的任务A，以提高任务A的效果。某种角度上，这有点像Multi-Task任务的目标

期待数据集合B能够迁移些知识给当前任务A，那么这两个任务或者训练数据之间必然应该有些**共性存在**。

* This Is Competition at SemEval-2019 Task 9: BERT is unstable for out-of-domain samples

* Simple Applications of BERT for Ad Hoc Document Retrieval

Fine-tuning任务B和下游任务A的任务相似性对于效果影响巨大，我们尽可能找相同或者相近任务的数据来做Fine-tuning，哪怕形式上看上去有差异。



假设有几个新增的训练集合，比如B，C，D三个新数据集合，每个和Target任务A的数据差异远近不同，假设B最远，C次之，D和A最像。

* 一种做法是把A+B+C+D放到一起去Fine-tune 模型，
* 另外一种是由远及近地分几个阶段Fine-tune模型，比如先用最远的B，然后用C，再然后用最近的D，再然后用A，这种叫Stage-wise的方式。
* 结论是Stage-wise模式是明显效果好于前一种方式的。
  

