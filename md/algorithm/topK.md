---
title: TopK
date: 2020/11/26 14:18:32
toc: true
tags:
- algorithm
---

TopK类问题
* 可以放入内存
* 无法放入内存
<!--more-->

解法
* 分治(二分)
  * 快排的思想，先找到第k大的数，然后就可以找前k大的数
  * 随机取一个数，将数据分成两组，大于这个数的数目若小于K，则在小于这个数的序列中再次二分，找前K-N个大的数
* Hash法
  * 如果有**很多重复的数**，先用个字典记录每个数出现的次数，减少内存用量，再通过分治或者最小堆 查找
  * 桶排序 直接用个list来存，list的index就是出现的频次
* 最小堆
  * 先取前K个数放入堆，然后取堆顶与剩余的数比较
  * 维护一个长度是K的小根堆(前K大), 大根堆(前K小)
  * O(N*log(K))  数组中每个元素遍历过去(O(N)),最坏情况，每次都要调整堆结构 O(logK), 调整时间复杂度就是堆的高度。
* 排序
  * 冒泡排序 O(N*K)

[top-k-frequent-elements](<https://leetcode.com/problems/top-k-frequent-elements/>)
[sort-characters-by-frequency](<https://leetcode.com/problems/sort-characters-by-frequency/description/>)

#### 数据量很大,无法放入内存
例如10亿条数据找top 10000.
* 首先可以将10亿分组存放，例如分成1000组，然后针对每组求top10000， 最后针对 1000组的 top10000再求一次 top10000

#### Map reduce 思路

* map函数

根据数据值或者把数据**hash**(MD5)后的值按**照范围划分到不同**的机器上

* reduce

各个机器只需拿出各自出现次数最多的前N个数据，然后汇总，选出所有的数据中出现次数最多的前N个数据

两个reduce 函数

第一个: 用hashmap统计每个词的频率

第二个: 统计所有reduce task，输出数据中的topk



### 类似的面试题

* 海量数据中找出出现频率最大的前k个数

  * 遍历一遍统计每个数出现次数 得到 [(num_count,num)] 然后放入堆

* 海量数据中找出最大的前k个数

  * 是否去重

* 在搜索引擎中，统计搜索最热门的10个查询词

  * 先将数据集按照Hash方法分解成多个小数据集
    * **用hash的方法是为了保证同一个词 全都集中在同一个小数据集中**
  * 用Trie树或者Hash统计每个小数据集中的query词频
  * 用小根堆求出每个数据集中出现频率最高的前K个数
  * 最后在所有top K中求出最终的top K

* 歌曲库中统计下载最高的前10首歌

* 有10000000个记录，这些查询串的重复度比较高，如果除去重复后，不超过3000000个。一个查询串的重复度越高，说明查询它的用户越多，也就是越热门。请统计最热门的10个查询串，要求使用的内存不能超过1GB。

* 有10个文件，每个文件1GB，每个文件的每一行存放的都是用户的query，每个文件的query都可能重复。按照query的频度排序。

* 有一个1GB大小的文件，里面的每一行是一个词，词的大小不超过16个字节，内存限制大小是1MB。返回频数最高的100个词。

* 提取某日访问网站次数最多的那个IP。

* 10亿个整数找出重复次数最多的100个整数。

* 搜索的输入信息是一个字符串，统计300万条输入信息中最热门的前10条，每次输入的一个字符串为不超过255B，内存使用只有1GB。

* 有1000万个身份证号以及他们对应的数据，身份证号可能重复，找出出现次数最多的身份证号。

  

#### 重复问题
在海量数据中查找出重复出现的元素或者去除重复出现的元素
* 已知某个文件内包含一些电话号码，每个号码为8位数字，统计不同号码的个数。



使用位图法来实现

例如int型 32位，这32位只表示一个数太浪费，因此用这32位表示32个数，每一位表示该数是否存在。

下面就是16位表示， 表示存在（16，12，6，4，1）这五个数。


8位整数可以表示的最大十进制数值为99999999,

因此一共是9999999bit(序列长度是9999999，每一位是一个bit) ，大小是9999999/1024/8 = 12.375MB内存


* 如何从100w个城市中查找到“上海”这座城市。
  * B+树


#### 参考

[1.link](<https://blog.csdn.net/zyq522376829/article/details/47686867>)