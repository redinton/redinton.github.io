



[TOC]



####二分类中的focal loss

$$
-\alpha(1-p_t)^{\gamma}y_tlog(p_t) - p_t^{\gamma}(1-y_t)log(1-p_t)
$$

针对标准的交叉熵改进得来的，当$\alpha$取1时，结果如下。

![image-20190715091447627](/Users/K/Library/Application Support/typora-user-images/image-20190715091447627.png)



#### 参数含义

$\alpha$ 用来调节正样本的权重，越大意味着正样本越重要

$\gamma$ 用来调节容易分的样本的权重，越大，则越不在意“容易分的样本。针对小于1的数，指数越大应该越小



#### 多分类

将二分类拓展到多分类时，其实就是把$p_t$先softmax。

```python

import torch
import torch.nn as nn
import torch.nn.functional as F

class FocalLoss(nn.Module):
    def __init__(self, alpha=1.0, gamma=2, size_average=True):
        super().__init__()
        self.alpha = alpha
        self.gamma = gamma
        self.size_average = size_average
		### targets 应该是没有one-hot处理过，直接是1，2，3这种形式
    def forward(self, inputs, targets):
        targets = targets.view(-1, 1)
        
        prob_dist = F.softmax(inputs, dim=1)
        pt = prob_dist.gather(1, targets)
        
        batch_loss = -self.alpha * (torch.pow((1 - pt), self.gamma)) * torch.log(pt)
        
        if self.size_average:
            loss = batch_loss.mean()
        else:
            loss = batch_loss.sum()
        return loss
```



```python
class FocalLoss(nn.Module):
    def __init__(self,pos_weight,alpha=1, gamma=2,logits=True, reduce=True):
        super(FocalLoss, self).__init__()
        self.alpha = alpha
        self.gamma = gamma
        self.logits = logits
        self.reduce = reduce
        
        self.loss = torch.nn.CrossEntropyLoss(weight=pos_weight,reduction='none')
        
    def forward(self, inputs, targets):
        
        CE_loss = self.loss(inputs, targets)
        
        pt = torch.exp(-CE_loss)
        F_loss = (1-pt)**self.gamma * CE_loss

        if self.reduce:
            return torch.mean(F_loss)
        else:
            return F_loss
```



#### 多标签



```python
class FocalLoss(nn.Module):
    def __init__(self,pos_weight,alpha=1, gamma=2,logits=True, reduce=True):
        super(FocalLoss, self).__init__()
        self.alpha = alpha
        self.gamma = gamma
        self.logits = logits
        self.reduce = reduce
        
        self.BCELossLogits = torch.nn.BCEWithLogitsLoss(reduction='none',pos_weight=pos_weight)
        self.BCELoss = torch.nn.BCELoss(reduction='none' )

    def forward(self, inputs, targets):
        if self.logits:
            BCE_loss = self.BCELossLogits(inputs, targets)
        else:
            BCE_loss = self.BCELoss(inputs, targets)
    
        pt = torch.exp(-BCE_loss)
        F_loss = (1-pt)**self.gamma * BCE_loss

        if self.reduce:
            return torch.mean(F_loss)
        else:
            return F_loss
```

