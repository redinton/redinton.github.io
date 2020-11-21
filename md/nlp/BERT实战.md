



[TOC]

###前言

本文主要以huggingface开源的[pytorch-pretrained-bert](https://github.com/huggingface/pytorch-pretrained-BERT#loading-google-ai-or-openai-pre-trained-weights-or-pytorch-dump) 框架为主，以使用和对框架内容的解读为目标。



#### 分词

中文的分词

```python
from pytorch_pretrained_bert import BertModel, BertTokenizer
import numpy as np

# 加载bert的分词器
tokenizer = BertTokenizer.from_pretrained('./drive/pytorch-NER/bert-base-chinese/bert-base-chinese-vocab.txt')
```



```python
class BertTokenizer(object):
    """Runs end-to-end tokenization: punctuation splitting + wordpiece"""

    def __init__(self, vocab_file, do_lower_case=True, max_len=None, do_basic_tokenize=True,
                 never_split=("[UNK]", "[SEP]", "[PAD]", "[CLS]", "[MASK]")):
        """Constructs a BertTokenizer.
        Args:
          vocab_file: Path to a one-wordpiece-per-line vocabulary file
          do_lower_case: Whether to lower case the input
                         Only has an effect when do_wordpiece_only=False
          do_basic_tokenize: Whether to do basic tokenization before wordpiece.
          max_len: An artificial maximum length to truncate tokenized sequences to;
                         Effective maximum length is always the minimum of this
                         value (if specified) and the underlying BERT model's
                         sequence length.
          never_split: List of tokens which will never be split during tokenization.
                         Only has an effect when do_wordpiece_only=False
        """
```





BertModel 的输出

```python
        if self.output_attentions:
            all_attentions, encoded_layers = encoded_layers
        sequence_output = encoded_layers[-1]
        pooled_output = self.pooler(sequence_output) ## pool ope
        if not output_all_encoded_layers:
            encoded_layers = encoded_layers[-1]
        if self.output_attentions:
            return all_attentions, encoded_layers, pooled_output
        return encoded_layers, pooled_output
```



Bert 中的pool 就是把第一个时刻的output(即[CLS]对应的output)接一个fc

```python
class BertPooler(nn.Module):
    def __init__(self, config):
        super(BertPooler, self).__init__()
        self.dense = nn.Linear(config.hidden_size, config.hidden_size)
        self.activation = nn.Tanh()

    def forward(self, hidden_states):
        # We "pool" the model by simply taking the hidden state corresponding
        # to the first token.
        first_token_tensor = hidden_states[:, 0]
        pooled_output = self.dense(first_token_tensor)
        pooled_output = self.activation(pooled_output)
        return pooled_output
```



#### BertForTokenClassification

序列标注可以直接调用

就是在  BertModel 最后一层输出(encoder output)上 接了 dropout 再接上一层FC layer来预测每个时刻输出的结果

```python
    def forward(self, input_ids, token_type_ids=None, attention_mask=None, labels=None, head_mask=None):
        outputs = self.bert(input_ids, token_type_ids, attention_mask, output_all_encoded_layers=False, head_mask=head_mask)
        if self.output_attentions:
            all_attentions, sequence_output, _ = outputs
        else:
            sequence_output, _ = outputs
        sequence_output = self.dropout(sequence_output)
        logits = self.classifier(sequence_output)
```





####BertForMultipleChoice

取的是pool的结果，接一个dropout再接一个fc。

做的是个选择题任务(SWAG)，如给定context 和选项1，context和选项2 ,….

所以上述的fc的输出维度是1，然后logiy.view(-1, self.num_choices)

```python
    # inference. For a given Swag example, we will create the 4
    # following inputs:
    # - [CLS] context [SEP] choice_1 [SEP]
    # - [CLS] context [SEP] choice_2 [SEP]
    # - [CLS] context [SEP] choice_3 [SEP]
    # - [CLS] context [SEP] choice_4 [SEP]

def __init__(self, config, num_choices=2, output_attentions=False, keep_multihead_output=False):

def forward(input_ids, token_type_ids=None, attention_mask=None, labels=None, head_mask=None):
 				 outputs = self.bert(flat_input_ids, flat_token_type_ids, flat_attention_mask, 	output_all_encoded_layers=False, head_mask=head_mask)
 				if self.output_attentions:
      			all_attentions, _, pooled_output = outputs
        else:
            _, pooled_output = outputs
        pooled_output = self.dropout(pooled_output)
        logits = self.classifier(pooled_output)
        reshaped_logits = logits.view(-1, self.num_choices)

        if labels is not None:
            loss_fct = CrossEntropyLoss()
            loss = loss_fct(reshaped_logits, labels)
            return loss
        elif self.output_attentions:
            return all_attentions, reshaped_logits
        return reshaped_logits
```



#### BertForSequenceClassification(BertPreTrainedModel):

用来做分类问题，可以二分也可以多分

```python
"""BERT model for classification.
    This module is composed of the BERT model with a linear layer on top of
    the pooled output.
"""
```







BERT 怎么冻结参数不参加训练