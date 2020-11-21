

[TOC]





### TOP K 类问题

* 给定数组, 求第K大 或者第K小的数
* 给定数组, 求前K大 或者前K小的数

#### 思路

* 直接排序  O(Nlog(N))
* 只排序前K个 - 用冒泡排序  O(N*K)
* 堆排序 O(N*logK)
  * 维护一个长度是K的 小根堆(前K大), 大根堆(前K小)
  * O(N*log(K))  数组中每个元素遍历过去(O(N)),最坏情况，每次都要调整堆结构 O(logK), 调整时间复杂度就是堆的高度。
* 快排的partition思想 O(n)
  * partition(nums,i,j)返回一个index, 其思想是根据数组第一个数a，把数组分成两个部分, index的左边是比a小(或者大),右边是比a大(或者小)
  * 比较index大小和K的大小
  * 得到第K大的数以后,对应的partition结果就是前K大或者前K小的数



### 出现频率前K次数或字母

#### 思路

* 转换成Top K 大的问题
  * 先遍历得到每个数字或字母出现的频次
  * 取前K大的频次对应的数字或字母
    * 堆排序 / 快排的partition
* 桶排序
  * 每个桶存 出现频次相同的 字母或数字
    * 直接用个list来存，list的index就是出现的频次

#### 相关题目

[top-k-frequent-elements](<https://leetcode.com/problems/top-k-frequent-elements/>)

[sort-characters-by-frequency](<https://leetcode.com/problems/sort-characters-by-frequency/description/>)

