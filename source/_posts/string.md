---
title: string
date: 2020/11/26 14:19:07
toc: true
tags:
- algorithm
---




### 字符串

#### 两个字符串之间的最大相同子串

* 子串连续
* 子串可以不连续
<!--more-->
动态规划构建数组 考虑一个子串m1,另一个m2, 空间复杂度O($m1*m2$),时间O($m1*m2$)

#### 字符串循环移位

---

```
s = "abcd123" k = 3 字符串循环向右移k位
Return "123abcd"
```

 abcd123 中的 abcd 和 123 单独翻转，得到 dcba321，然后对整个字符串进行翻转，得到 123abcd。

同理: 字符串中单词的翻转 - "I am a student" ->  "student a am I"

将每个单词翻转，最后把整个句子翻转。



#### 回文串系列

#####判断一个整数是否是回文数

---

不能将整数转换为字符串进行判断

思路: 得到该数的右边部分，和左边比较是否一致

```python
        if x == 0:
            return True
        if x < 0 or x % 10 == 0:
            return False
        
        right = 0
        
        while x > right:
            right = right * 10 + x % 10
            x = x // 10

        if x == right or x == right // 10:
            return True
        return False
```



#####判断回文子字符串的个数

---

```
Input: "aaa"
Output: 6
Explanation: Six palindromic strings: "a", "a", "a", "aa", "aa", "aaa".
```

* 思路一：利用求最大子串的思路,分奇偶中心分别往外展开

从字符串的某一位开始，尝试着去扩展子字符串。

```python
    def __init__(self):
        self.cnt = 0
    
    def countSubstrings(self, s):
        for i in range(len(s)):            
            self.extend_s(s,i,i)
            self.extend_s(s,i,i+1)
        return self.cnt
    
    def extend_s(self,s,start,end):
        while start > -1 and end < len(s) and s[start] == s[end]:
            start -= 1
            end +=1
            self.cnt +=1
```

* 思路二: Dp

  * dp$[i][j]$ 定义成子字符串[i, j]是否是回文串

    * ```python
              dp = [[False]*len(s) for _ in range(len(s))]
              res = 0
          		# 关键还是从后往前遍历
              for i in range(len(s)-1,-1,-1):
                  for j in range(i,len(s)):
                      dp[i][j] = (s[i]==s[j]) and (j-i<=2 or dp[i+1][j-1])
                      if dp[i][j]:
                          res += 1
              return re
      ```



##### 最长回文子串

---

>最长回文子串 给定一个字符串 s，找到 s 中最长的回文子串。

* 定义一个help(s,l,r)  l 和r就是左起始点和右起始点

  * ```
    global_len, index 这两个全局变量 记录最长子串
    for i in range(len(s)):
    	helper(s,i,i) # 奇数情况
    	helper(s,i,i+1) # 偶数情况
    ```

* 上述方法的简化版本- **针对  abbbbbbc 这种连续重复多次的情**况,

* ```python
              self.maxlen = 0
              self.start = 0
              i = 0
              while i < len(s):
                  if len(s) - i < self.maxlen / 2:
                      break
                  l,r = i,i
                  while r < len(s)-1 and s[r] == s[r+1]:
                      r += 1
                  i = r + 1
                  while l > -1 and r < len(s) and s[l] ==s[r]:
                      l -= 1
                      r += 1
                  if self.maxlen < r-l-1:
                      self.maxlen = r-l-1
                      self.start = l + 1
            
              return s[self.start:self.start+self.maxlen]
  ```

* manacher

##### 最长回文子序列

---

> 最长回文子序列 给定一个字符串s，找到其中最长的回文子序列

子串：字符串中连续的序列; 子序列: 字符串中保持相对位置的字符序列

* 动态规划
  
* ![image-20190613134741489](/Users/K/Library/Application Support/typora-user-images/image-20190613134741489.png)
  
* ```python
      dp = [[0]*len(s) for _ in range(len(s))]
      ### 核心在于 i 是从后往前遍历，原因是在状态转移方程中 dp[i,j] = dp[i+1,j-1]由i+1de状					### 态来更新i的状态
      for i in range(len(s)-1,-1,-1):
          dp[i][i] = 1
          for j in range(i+1,len(s)):
              if s[i] == s[j]:
                  dp[i][j] = dp[i+1][j-1] +2
              else:
                  dp[i][j] = max(dp[i+1][j],dp[i][j-1])
                  
      return dp[0][len(s)-1]
  ```



##### 最长回文串

---

给定一个包含大写字母和小写字母的字符串，找到通过这些字母构造成的最长的回文串。在构造过程中，请注意区分大小写。比如`"Aa"`不能当做一个回文字符串。注 意:假设字符串的长度不会超过 1010。

* 从字符串中找出能构成回文串的字符

```
输入:
"abccccdd"
输出:
7
解释:
我们可以构造的最长的回文串是"dccaccd", 它的长度是 7。
```

* 思路：
  * 遍历字符串, 判断对应的字符是否在list中
    * 不在就加进去
    * 在的话，就把list中的对应的字符删除，同时count += 1 (count记录的就是字符对出现的次数)
  * 最终如果list为空,那么返回 2\*count, 如果不为空 就是 2*count + 1



#####判断子串是否是回文串

---

给定一个字符串，验证它是否是回文串，只考虑字母和数字字符，可以忽略字母的大小写。

* 两个指针从字符串的首尾开始往中间移动
* 一个help函数,判断当前字符是否只是数字或字母



##### 分割子串

---

给定一个字符串 *s*，将 *s* 分割成一些子串，使每个子串都是回文串，返回 *s* 所有可能的分割方案。

```
输入: "aab"
输出:
[
  ["aa","b"],
  ["a","a","b"]
]
```

```python
        flag = [[0]*len(s) for _ in range(len(s))]
        store = {}
        
      	### Flag 存储 子串i到j是否为回文
        for i in range(len(s)-1,-1,-1):
            for j in range(i,len(s)):
                flag[i][j] = s[i] == s[j] and (j-i < 2 or flag[i+1][j-1] )
        
        ### 从后往前遍历，包含改点的有多少构成回文的方案
        for i in range(len(s)-1,-1,-1):
            for j in range(i,len(s)):
                if flag[i][j]:
                    to_str = s[i:j+1]
                    if i not in store:
                        store[i] = []
        
                    if  j + 1 < len(s):
                        for tmp in store[j+1]:
                            up = tmp[:]
                            up.insert(0,to_str)
                            store[i].append(up)
                    else:
                        store[i].append([to_str])
        return store[0]
                    
```





#### 字符串查找

[参考链接](<http://www.ruanyifeng.com/blog/2013/05/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm.html>)

在一个字符串S中查找子串W出现的位置。

* 暴力搜索: 先找到S中与W第一个字符匹配的位置，然后接着比对，一旦不一致，将S中的位置往后移一位。
* KMP(K,M,P 分别是三个人的名字)
  * 字符匹配的时间复杂度为O(m+n),空间复杂度O(m)
  * 1. 先按照W第一个字符匹配
    2. 一旦匹配到一个后，开始维护一个表来记录，这个表记录的是部分匹配的字符串的前缀与后缀的交集的字符串长度
    3. 一旦W中的某个字符与S匹配不上时，移动距离 = 目前匹配的长度 - 最后一个匹配的字符对应的表中的匹配值。  6 - 2 = 4


* KMP算法的想法是，设法利用这个已知信息，不要把"搜索位置"移回已经比较过的位置，继续把它向后移，这样就提高了效率。


next 数组就是最大长度值右移一位。

```python
# step1: 先对模式字符串W计算匹配表
# step2: 利用匹配表来匹配
```

* Boyer-Moore 算法
  * 坏字符规则
    * 后移位数 = 坏字符的位置 - 搜索词中的上一次出现位置
      * 如果"坏字符"不包含在搜索词之中，则上一次出现位置为 -1。
  * 好后缀规则
  * 更有效，这两个规则的移动位数，**只与搜索词有关，与原字符串无关**。因此，可以预先计算生成《坏字符规则表》和《好后缀规则表》。使用时，只要查表比较一下就可以了。
    * 坏字符移动表 就是一个字典，key是26个字母(如果字符串中只有字母)，value就是对应移动的距离大小，对于那些不在pattern string中的字母，对应的value就是整个pattern string的长度

#### 最长公共前缀

编写一个函数来查找字符串数组中的最长公共前缀。如果不存在公共前缀，返回空字符串 ""。

```
输入: ["flower","flow","flight"]
输出: "fl"

输入: ["dog","racecar","car"]
输出: ""
解释: 输入不存在公共前缀。
```

思路: 先将list排序(按照字母顺序排的顺序)，再对比list第一个元素和最后一个元素的公共字符。





#### [Word Ladder](https://leetcode.com/problems/word-ladder/)

* 用一个visited 记录已经访问过的节点， visited 需要是set
* 用一个deque(from collections import deque) 记录词 (word,dist) 
* 用一个字典来存可能的映射

```python
    d = {}
    for word in wordList+[beginWord]:
        for i in range(len(word)):
            s = word[:i] + "_" + word[i+1:]
            d[s] = d.get(s, []) + [word]
 
    if endWord not in wordList:
        return 0
    visited = set()
    layer = [(beginWord,1)]
    while layer:
        word,dist = layer.pop(0)
        if word not in visited:
            visited.add(word)
            if word == endWord:
                return dist
            for i in range(len(word)):
                s = word[:i] + "_" + word[i+1:]
                nxtWords = d.get(s, [])
                for w in nxtWords:
                    if w not in visited:
                        layer.append((w,dist+1))

    return 0
```
### 序列类问题

#### 最长连续子序列

---

[128. Longest Consecutive Sequence (Hard)](https://leetcode.com/problems/longest-consecutive-sequence/description/)

```
Given [100, 4, 200, 1, 3, 2],
The longest consecutive elements sequence is [1, 2, 3, 4]. Return its length: 4.
```



```python
def longestConsecutive(self, nums):
    nums = set(nums)
    best = 0
    for x in nums:
        if x - 1 not in nums:
            y = x + 1
            while y in nums:
                y += 1
            best = max(best, y - x)
    return best
```

