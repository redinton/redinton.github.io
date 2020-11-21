[TOC]





### Bias in the data

#### 有哪些偏差

真实世界中，很多时候数据本身是有偏差的。

* 偏差1

![image-20190412105707901](/Users/K/Library/Application Support/typora-user-images/image-20190412105707901.png)

给定一张香蕉的图片，通常描述是 banana，而不是yellow banana， Yellow就好像是banana的一个固有属性，人们不会刻意的描述出他。因此对应的文本预料中，yellow来描述banana的情况相对其他来说就不会很多。

![image-20190412110024760](/Users/K/Library/Application Support/typora-user-images/image-20190412110024760.png)

* 偏差2

采样的数据很多存在偏差，如印度新娘的例子。

![image-20190412110235109](/Users/K/Library/Application Support/typora-user-images/image-20190412110235109.png)

![image-20190412110248520](/Users/K/Library/Application Support/typora-user-images/image-20190412110248520.png)



#### 在有偏差的数据中, 如何衡量效果 fairness,inclusion

---

* Disaggreated evaluation 计算每个子类的指标
  * 如在man下准确率, woman下准确率
* Intersectional Evaluation 多个类别放在一起
  * 如在 black woman下的指标， white woman 下的指标



![image-20190412112857308](/Users/K/Library/Application Support/typora-user-images/image-20190412112857308.png)

在release一个新的dataset时，不仅介绍dataset的distribution，还要介绍dataset标注的人是谁，什么背景，在哪balbala之类的，要把该数据集所带有的bias也表现出来。



#### Bias mitigation and inclusion

---

![image-20190412113205373](/Users/K/Library/Application Support/typora-user-images/image-20190412113205373.png)



predict text toxic 有一定的应用价值

* 在chatbot中，判断用户输入的句子的toxic 程度  仅通过一些词汇来判断是有bias的，例如gay在某些场合是好的，在某些场合是不好的，需要model结合上下文语境来判断





### NLG 文本生成

#### NLG 包括哪些

* Machine Translation 
* (**Abstractive) Summarizatio**n 
* **Dialogue (chit-chat and task-b**ased) 
* Creative writing: storytelling, poetry-generation 
* F**reeform Question Answ**ering (i.e. answer is generated, not extracted from text or knowledge base) 
* Image captioning 

#### language model

-  the task of predicting the next word, given the words so far 
- 基于已有的history 来预测下一个词的概率
- A system that **produces this probability distributio**n — called LM

* **conditional language model**
  * predicting the next word, given the words so far, and also **some other input *x*** 
  *  Machine Translation (x=source sentence, y=target sentence) 
  *  Summarization (x=input text, y=summarized text)

  *  Dialogue (x=dialogue history, y=next utterance)
    

* ![image-20190412135830229](/Users/K/Library/Application Support/typora-user-images/image-20190412135830229.png)

 先用一个encoder编码输入的source sentence,把编码信息输给decoder，然后decoder根据这个编码信息，以及是否有target input(有的话就是teacher forcing). 

- [ ] teacher forcing train完model后，在应用时怎么用？ 应用的时候应该是没有target sentence的



#### decoding 策略

A *decoding algorithm* is an algorithm you use to generate text from your language model 

- Greedy decoding
  - 每次选概率最大的那个词作为生成词
  - Use that as the next word, and **feed it as input** on the next step 
  - Keep going until you produce \<end>  (or reach some max length) 
  - 结果可能 语法错误，不自然 等等
- Beam search 
  - 不是贪心，每一步走最佳，而是每一步的时候去维护一个K大的结果，前K种概率最大的partial sequence.
  - 结束的时候，取概率最大的那个squence

![image-20190412141119717](/Users/K/Library/Application Support/typora-user-images/image-20190412141119717.png)

图中每一步，只计算前K个序列下一步的概率,如第二步只计算hit 和was的下一步

##### beam search 的K值怎么选

* K太小，就会变成是类似于greedy decoding(k=1)

* K 比较大

  * 可以缓解 greedy decooding 的问题
  * 更耗计算资源， 因为要计算K个序列的probability
  * NMT中, K太大会降低BLEU的值 - 解释说large-K beam search 会生成一些较短的翻译结果(可能某些较短的翻译结果的probabiltiy更高)
  * 在一些开放的环境中，像 chit-chat dialogue 较大的K会使得生成的结果更加一般化。

  ![image-20190412142115217](/Users/K/Library/Application Support/typora-user-images/image-20190412142115217.png)



adaptive K depend on the position in the sequence ?



##### Sampling_based decoding - not a decoding algorithm

* pure sampling
  * 每一步 t, 随机从 一个概率分布 $p_t$ 中采样得到 下一个词
  * 像greedy decoding一样，但是是采样而不是取argmax
* top-n sampling
  * 每一步， 随机从 一个概率分布 $p_t$ 中采样得到 top-n 最可能的词
  * n = 1就是greedy search , V就是 pure sampling
    * n越大 - 结果越多样/风险也越大
    * n越小 - 结果越generic,风险也小

##### Softmax temperature

* 在timestamp t的时候, LM会计算当前状态输出$p_t$  的一个概率分布$P_{t}(w)=\frac{\exp \left(s_{w}\right)}{\sum_{w^{\prime} \in V} \exp \left(s_{w \prime}\right)}$
* $P_{t}(w)=\frac{\exp \left(s_{w} / \tau\right)}{\sum_{w^{\prime} \in V} \exp \left(s_{w^{\prime}} / \tau\right)}$ 加入一个temperature $\tau$ 
* $\tau$ 越大，可以让整个分布$p_t$ 分布越uniform，因为$\tau$ 越大，使得原始分布中大的值变小了，结果就更加多样 (probability spread around vocab)
* 反之, $p_t$的分布会更加spiky, 因为会使得大的值更大，小的值更小，结果就会less diverse. (probabiltiy concentrated on top words)

![image-20190412143834894](/Users/K/Library/Application Support/typora-user-images/image-20190412143834894.png)



#### Summarization

 可以分为单文本， 和多文本(multi-document)

* 单文本- 指的是给一篇文档生成文本
* 多文本- 根据多篇文档($x_1, x_2 ,.. x_n$) 生成一个summary
  * 通常, $x_1, x_2,... x_n$内容有重叠的部分，如关于某一个主题的多篇新闻报道

##### 单文本-> summary数据集介绍

![image-20190412151726286](/Users/K/Library/Application Support/typora-user-images/image-20190412151726286.png)



* 抽取式 extractive summarization

![image-20190412151949051](/Users/K/Library/Application Support/typora-user-images/image-20190412151949051.png)

![image-20190412152039051](/Users/K/Library/Application Support/typora-user-images/image-20190412152039051.png)

##### ROUGE

based on n-gram overlap

* ROUGE has no brevity(简洁) penalty
* ROUGE 基于 recall， 而BLEU基于 precision
  * precision 对于 翻译任务来说更关键 (add brevity penalty to fix under-translation) , 而对于 summarization来说 recall更为重要(假设有一个最大长度限制)
  * 通常，论文里也会有基于F1(结合precision和recall)的ROUGE
* 通常对每一种n-gram都有一个值
  * ROUGE-1 - unigram 的重合
  * ROUGE-2 - bigram 的重合

有一个python的implementation of ROUGE

BLEU

*  通常是一个数, 是n=1,2,3,4 对于每一个n-grams precision的结合



#### Neural Summarization

* 抽象式 abstractive summarization

![image-20190412153349992](/Users/K/Library/Application Support/typora-user-images/image-20190412153349992.png)

![image-20190412153508923](/Users/K/Library/Application Support/typora-user-images/image-20190412153508923.png)

##### copy mechanism

![image-20190412154212495](/Users/K/Library/Application Support/typora-user-images/image-20190412154212495.png)

![image-20190412154547349](/Users/K/Library/Application Support/typora-user-images/image-20190412154547349.png)

生成摘要的时候 还需要有"global vision"，全局看了一遍后，然后生成摘要



![image-20190412155004986](/Users/K/Library/Application Support/typora-user-images/image-20190412155004986.png)



![image-20190412155114340](/Users/K/Library/Application Support/typora-user-images/image-20190412155114340.png)



Bottom up 做法

* 内容选择阶段,用一个sequnence-tagging 来tag每个词 是否include
* 用seq2seq+attention



用RL来做

![image-20190412155458077](/Users/K/Library/Application Support/typora-user-images/image-20190412155458077.png)

ROUGE 指标本身是non-differentiable意味着反向传播 传不回去



#### 对话生成

![image-20190412160054146](/Users/K/Library/Application Support/typora-user-images/image-20190412160054146.png)



##### 基于seq2seq的

* serious pervasive deficiencies

  * genericness/boring response
    * directly **upweight rare words** during beam search
    * use a sampling decoding rather than beam search 增加多样性
  * ![image-20190412162009139](/Users/K/Library/Application Support/typora-user-images/image-20190412162009139.png)
  * irrelevant response 

  ![image-20190412161944709](/Users/K/Library/Application Support/typora-user-images/image-20190412161944709.png)

  * repetition problem
    * 在beam-search的时候直接block repeating n-gram, 就是重复出现的话就直接drop
    * train 一个coverage 机制， 在seq2seq中，通常用这种方式防止attention 机制 attending to the same words multiple times
    * 定义一个目标函数来 discourage repetition
      * 如果是non-differentiable的话，就需要RL来train



#### Stroy telling

* 看图说话

  ![image-20190412162220985](/Users/K/Library/Application Support/typora-user-images/image-20190412162220985.png)



* 给定主题词生成 story

![image-20190412162412251](/Users/K/Library/Application Support/typora-user-images/image-20190412162412251.png)



####NLG 衡量指标

Word overlap metric not good for dialogue

##### Perplexity

![image-20190412162922338](/Users/K/Library/Application Support/typora-user-images/image-20190412162922338.png)





![image-20190412163259960](/Users/K/Library/Application Support/typora-user-images/image-20190412163259960.png)



![image-20190412163550472](/Users/K/Library/Application Support/typora-user-images/image-20190412163550472.png)





