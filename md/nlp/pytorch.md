





[TOC]





记录一些pytorch中的坑



#### [nn.ModuleList 和 nn.Sequential的区别](https://discuss.pytorch.org/t/when-should-i-use-nn-modulelist-and-when-should-i-use-nn-sequential/5463/2)

nn.ModuleList 类似于List的作用, 用来存nn.Module模块，nn.ModuleList之间是没有连接关系的。通常使用情景是一个NN网络有很多一样的block

```python
class LinearNet(nn.Module):
  def __init__(self, input_size, num_layers, layers_size, output_size):
     super(LinearNet, self).__init__()

     self.linears = nn.ModuleList([nn.Linear(input_size, layers_size)])
     self.linears.extend([nn.Linear(layers_size, layers_size) for i in range(1, self.num_layers-1)])
     self.linears.append(nn.Linear(layers_size, output_size)
```

nn.sequential 允许用户自定义一整个nn网络的运算流程，nn.Sequential中元素之间的关系是cascaded的,之间是有连接关系的。

```python
simple_cnn = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=7, stride=2),
            nn.ReLU(inplace=True),
            Flatten(), 
            nn.Linear(5408, 10),
          )
```





##### nn.Conv2d

> torch.nn.Conv2d(*in_channels*, *out_channels*, *kernel_size*, *stride=1*, *padding=0*, *dilation=1*, *groups=1*, *bias=True*, *padding_mode='zeros'*)

input:$\left(N, C_{\mathrm{in}}, H, W\right)$ , output: $\left(N, C_{\mathrm{out}}, H_{\mathrm{out}}, W_{\mathrm{out}}\right)$

* **kernel_size** ([*int*](https://docs.python.org/3/library/functions.html#int) *or* [*tuple*](https://docs.python.org/3/library/stdtypes.html#tuple)) 
* **stride** ([*int*](https://docs.python.org/3/library/functions.html#int) *or* [*tuple*](https://docs.python.org/3/library/stdtypes.html#tuple)*,* *optional*)
* **padding** ([*int*](https://docs.python.org/3/library/functions.html#int) *or* [*tuple*](https://docs.python.org/3/library/stdtypes.html#tuple)*,* *optional*)   Default: 0 即不加padding
* **padding_mode** -(*string**,* *optional*) – zeros
* **dilation** ([*int*](https://docs.python.org/3/library/functions.html#int) *or* [*tuple*](https://docs.python.org/3/library/stdtypes.html#tuple)*,* *optional*) – Spacing between kernel elements. Default: 1
* **groups** ([*int*](https://docs.python.org/3/library/functions.html#int)*,* *optional*) – Number of blocked connections from input channels to output channels. Default: 1
* **bias** ([*bool*](https://docs.python.org/3/library/functions.html#bool)*,* *optional*) – If `True`, adds a learnable bias to the output. Default: `True`

padding: 通过定义一个tuple可以使得H和W维度分别padding不同的大小

dilation: 空洞卷积

即卷积时，从输入中每隔 (dilation-1) 个元素取一个值而不是连续取值(因此当dilation=1时相当于不使用dilation)。 样例: 当卷积大小是3*3，dilation=2时，实际覆盖的输入范围是 5\*5

**groups(卷积核个数)**：这个比较好理解，通常来说，卷积个数唯一，但是对某些情况，可以设置范围在1 —— in_channels中数目的卷积核



##### nn.LSTMCell

Inputs: input, (h_0, c_0)

* **input** of shape (seq_len, batch, input_size)

* **h_0** of shape (num_layers * num_directions, batch, hidden_size)

* **c_0** of shape (num_layers * num_directions, batch, hidden_size)

Outputs: output, (h_n, c_n)

* **output** of shape (seq_len, batch, num_directions * hidden_size)
* **h_n** of shape (num_layers * num_directions, batch, hidden_size)
* **c_n** of shape (num_layers * num_directions, batch, hidden_size)



##### [RNN对变长序列处理](https://www.cnblogs.com/lindaxin/p/8052043.html)

torch.nn.utils.rnn.pack_padded_sequence()

`Variable`中保存的序列，**应该按序列长度的长短排序，长的在前，短的在后**。

- input (Variable) – 变长序列 被填充后的 batch
- lengths (list[int]) – `Variable` 中 每个序列的长度。
- batch_first (bool, optional) – 如果是`True`，input的形状应该是`B*T*size`。



torch.nn.utils.rnn.pad_packed_sequence()

```python
    # padding the sequence
    _, idx_sort = torch.sort(seq_lengths, dim=0, descending=True)
    _, idx_unsort = torch.sort(idx_sort, dim=0)

    emb = emb.index_select(0, Variable(idx_sort))
    seq_lengths = list(seq_lengths[idx_sort])
   
    pack_emb = torch.nn.utils.rnn.pack_padded_sequence(emb, seq_lengths,batch_first=True)
    raw_output, _ = self.rnn(pack_emb,init_hidden_state)

    unpacked, unpacked_len = torch.nn.utils.rnn.pad_packed_sequence(raw_output,batch_first=True)
    unpacked = unpacked.index_select(0, Variable(idx_unsort))
```



#### [tensor.gather](https://blog.csdn.net/edogawachia/article/details/80515038)

这个函数实现了在torch中给定index的情况下，按照index 取tensor中的值

```python
b = torch.Tensor([[1,2,3],[4,5,6]])
print b
index_1 = torch.LongTensor([[0,1],[2,0]])
index_2 = torch.LongTensor([[0,1,1],[0,0,0]])
print torch.gather(b, dim=1, index=index_1)
print torch.gather(b, dim=0, index=index_2)

 1  2  3
 4  5  6
[torch.FloatTensor of size 2x3]


 1  2
 6  4
[torch.FloatTensor of size 2x2]


 1  5  6
 1  2  3
[torch.FloatTensor of size 2x3]
```

