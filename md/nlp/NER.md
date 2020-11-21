[TOC]







#### 评测指标

[参考链接](<http://www.davidsbatista.net/blog/2018/05/09/Named_Entity_Evaluation/>)

* CoNLL: Computational Natural Language Learning

> * precision is the percentage of named entities found by the learning system that are correct. 
> * Recall is the percentage of named entities present in the corpus that are found by the system.
> * A named entity is correct only if it is an **exact match** of the corresponding entity in the data file.*



* 实际任务中，参考以下指标

  * performance per label type per token

    输出每种label对应的metric

    ![image-20190612100158759](/Users/K/Library/Application Support/typora-user-images/image-20190612100158759.png)

  * performance over full name-entity

    整个entity的边界要匹配上才算成功预测





* 标注的策略
  * BIO - begin; inside; Outside
  * BIOES - begin；inside；outside；end；single
  * BMES - begin; middle; end ; single



#### 医疗相关NER

An attention-based BiLSTM-CRF approach to  document-level chemical named entity  recognition





#### features

* 一些额外的feature

  traditional features (such as POS, chunking and dictionary features)

   25-dimensional POS embedding and 10-dimensional  chunking embedding

  chemical dictionaries as  a form of domain knowledge are often added to the set of features.

* Word embedding

  可以到网上搜索医疗相关的语料来，然后用word2vec/glove/fasttext 重新训练一个embedding

  MEDLINE abstracts from the PubMed website with the query string ‘chemical’

* Character embedding

  character n-grams, prefixed and suffixes



#### models

lstm-atten-CRF

![image-20190707143428101](/Users/K/Library/Application Support/typora-user-images/image-20190707143428101.png)



char_embedding

![image-20190709222111792](/Users/K/Library/Application Support/typora-user-images/image-20190709222111792.png)

CNN_based char embedding

```python
        def forward(self, x):
        		# [batch_size (B) * word_seq_len (Lw), char_seq_len (Lc)]
            x = x.view(-1, x.size(2)) 
            x = self.embed(x) # [B * Lw, Lc, dim (H)]
            x = x.unsqueeze(1) # [B * Lw, Ci, Lc, W]
            h = [conv(x) for conv in self.conv] # [B * Lw, Co, Lc, 1] * K
            h = [F.relu(k).squeeze(3) for k in h] # [B * Lw, Co, Lc] * K
            h = [F.max_pool1d(k, k.size(2)).squeeze(2) for k in h] # [B * Lw, Co] * K
            h = torch.cat(h, 1) # [B * Lw, Co * K]
            h = self.dropout(h)
            h = self.fc(h) # fully connected layer [B * Lw, embed_size]
            h = h.view(BATCH_SIZE, -1, h.size(1)) # [B, Lw, embed_size]
            return h
```

LSTM_based

BiLSTM的final hidden_state的输出中的cell_state concatenate(因为涉及一个正向一个反向的cell state)起来

```python
        def forward(self, x):
            s = self.init_state(x.size(0) * x.size(1))
            x = x.view(-1, x.size(2)) 
            # [batch_size (B) * word_seq_len (Lw), char_seq_len (Lc)]
            x = self.embed(x) # [B * Lw, Lc, embed_size (H)]
            h, s = self.rnn(x, s)
            h = s if self.rnn_type == "GRU" else s[-1]
            h = torch.cat([x for x in h[-self.num_dirs:]], 1) 
            # final cell state [B * Lw, H]
            h = h.view(BATCH_SIZE, -1, h.size(1)) # [B, Lw, H]
            return h
```

Self attentive encoder 

用transformer中的encoder的思想multi-head attention 来计算word的embedding





#### 构建一个NER系统前期

中文实体识别 中文识别包含英文识别；英文直译实体；

特定领域的数据 爱尔眼科集团股份有限公司B-agency，I-agency，……

数据清洗

知识图谱中的节点，利用NER大量的数据中抽取图中的每个实体节点





#### 标注数据的构建

前期处理：

1.数据中句子的切割：要做成训练数据那样的标注并不容易，有些句子长度得有1000+个字了，我们尽量把句子的长度控制在100左右，同时要保证词语的完整性。

2.符号清理：这里尽量保证句子中乱七八糟的符号不要太多。

3.然后舍去全是‘O’的标注句子。其实有标注的句子占的比重不大，这里要注意清洗干净。

4.如果对数字识别不做要求，干脆转换成0进行识别



数据源:  有的只有未标注的**数据**和一些数据库中的**词典**，那么我们要做的就是从数据库中抽取原始数据和每个类别的词典进行标注还原。那么标注还原怎么做呢？

- 可以直接将词典导进分词器的，将类别作为词性标注的标签进行标注，这样既做了分词也做了标注。
- 基于词典，通过**最大匹配**获得实体位置，然后标注实体类型。
- 实体识别完成后就是数据入库审核工作了，然后就是做词典更新，添加识别出的新词，继续做模型训练。