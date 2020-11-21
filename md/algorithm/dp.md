---
title: dp
date: 2020/11/01 12:26:21
toc: true
tags:
- algorithm
---


* 求最值类型的问题一般就往dp方向试
* dp问题 重叠子问题且符合最优子结构
  * 子问题间相互独立即dp(n)和dp(n-1)的结果互不影响
  * 最优子结构，从子问题的最优结果推出更大规模的最优结果
* 找到状态和选择, 遍历状态, 作出选择

### 字符串相关/字符串编辑

#### [字符串的编辑距离](https://leetcode.com/problems/edit-distance/description/)

 参照leetcode 72题，给定word1,word2，通过插入，删除，替换操作把word1变成word2. 求最少操作数目

构建一个二维数组，行列分别是word1,2的长度，每个点(i,j)存的值就是从word1[:i]变到word2[:j]所需要的操作

若word1 i 处的值和 word2 j处的值相等，$dp[j][i] = dp[j-1][i-1]$

若不相等，则

``` 
dp[j][i] = min([dp[j-1][i-1],dp[j-1][i],dp[j][i-1]]) + 1 找到操作中最小的+1.
```

  ```python
  n1,n2 = len(word1)+1,len(word2)+1
  dp = [[0]*n1 for _ in range(n2)]
  for i in range(n1):
      dp[0][i] = i
  for j in range(n2):
      dp[j][0] = j
  for j in range(1,n2):
      for i in range(1,n1):
          if word1[i-1] == word2[j-1]:
              dp[j][i] = dp[j-1][i-1]
          else:
              dp[j][i] = min([dp[j-1][i-1],dp[j-1][i],dp[j][i-1]]) + 1
  return dp[-1][-1]

  ```



#### [删除两个字符串的字符使它们相等](<https://leetcode.com/problems/delete-operation-for-two-strings/description/>)

---

这道题本质上还是求解两个字符串的最大公共子序列(**不一定需要连续**)

* 思路一 : 构建一个二维数组，每个点(i,j)存的值就是A[:i]和B[:j]的最大公共子序列长度,  O($n^2$) 时间,O($(n+1)^2$)

```python
 dp =  [[0]*(len(A)+1) for _ in range(1+len(B))]
        
 for i in range(1,len(B)+1):
      for j in range(1,len(A)+1):
            if A[j-1] == B[i-1]:
                 dp[i][j] = dp[i-1][j-1] + 1
            else:
                 dp[i][j] = max(dp[i-1][j],dp[i][j-1])
 return len(A) + len(B) - 2 * dp[-1][-1]
```



### 背包问题
#### 0-1背包问题
0-1背包问题，用该背包装下的物品**价值最大**，每个物品两个属性-体积w和价值v。

0-1背包意思就是，是否装了该物品。

用二维数组dp存最大价值,dp\[i]\[j]表示前i件物品体积不超过j时的所能达到的最大价值

dp\[i]\[j] = max(dp\[i-1][j],dp\[i-1]\[j-w]+v)

空间优化后变成

dp[j] = max(dp[j],dp[j-w]+v) 但是需要每次从后往前迭代，因为 = 右边的 dp[j] 应该是上一次迭代中体积为j时所能存的最大价值。

0-1背包问题无法用贪心来解，因为可能会造成空间的浪费。

[分割等和子集](https://leetcode-cn.com/problems/partition-equal-subset-sum/solution/fen-ge-deng-he-zi-ji-by-leetcode-solution/)

```py
def canPartition(self, nums: List[int]) -> bool:
    nums_sum = sum(nums)
    if nums_sum % 2 == 1:
        return False
    target = nums_sum // 2

    dp = [False] * (target + 1)
    dp[0] = True

    for num in nums:
        # 关键每次从后往前遍历
        for w in range(target,num-1,-1):
            dp[w] = dp[w-num] or dp[w]
    return dp[target]
```


[目标和](https://leetcode-cn.com/problems/target-sum/)
可以转化成0-1背包问题。 设所有符号为正的数和为x，所有符号取负的数和为y，那么x+y=sum, x - y = S 因此 x = (S+sum)// 2
```py
def findTargetSumWays(self, nums: List[int], S: int) -> int:
    weight = sum(nums) + S
    if weight % 2 == 1 or sum(nums) < S:
        return 0
        
    target = weight // 2
    dp = [0] * (target+1)
    dp[0] = 1

    for num in nums:
        for w in range(target,num-1,-1):
            dp[w] = dp[w-num] + dp[w]
    return dp[target]
```


**变种问题**

#### 完全背包：物品数量无限

---

[322. Coin Change (Medium)](https://leetcode.com/problems/coin-change/description/)

```
Example 1:
coins = [1, 2, 5], amount = 11
return 3 (11 = 5 + 5 + 1)

Example 2:
coins = [2], amount = 3
return -1.
```

给一些面额的硬币，要求用这些硬币来组成给定面额的钱数，并且使得**硬币数量最少**。**硬币可以重复使用**。

背包大小: 给定面额 , 物品大小:硬币的面额，物品价值:硬币的数量

**完全背包问题的解法只要把逆序遍历，变成顺序遍历**。

```python
dp = [0] * (amount+1)
for coin in coins:
  for i in range(coin,amount+1):
    if i == coin:
      dp[i] = 1
    elif dp[i] == 0 & dp[i-coin] != 0:
      dp[i] = dp[i-coin] + 1
    elif dp[i-coin] != 0:
      dp[i] = min(dp[i],dp[i-coin]+1)
 return -1 if dp[amount] == 0 else dp[amount]
```



[518. Coin Change 2 (Medium)](https://leetcode.com/problems/coin-change-2/description/)

找硬币的零钱组合数

```
Input: amount = 5, coins = [1, 2, 5]
Output: 4
Explanation: there are four ways to make up the amount:
5=5
5=2+2+1
5=2+1+1+1
5=1+1+1+1+1
```

首先用**顺序遍**历,然后dp记录**每次的组合数**加起来

```python
dp = [0] * (amount+1)
dp[0] = 1

for coin in coins:
  for i in range(coin,amount+1):
    dp[i] += dp[i-coin]

return dp[amount]
```



##### 带顺序的完全背包

---

[377. Combination Sum IV (Medium)](https://leetcode.com/problems/combination-sum-iv/description/)

```
nums = [1, 2, 3]
target = 4

The possible combination ways are:
(1, 1, 1, 1)
(1, 1, 2)
(1, 2, 1)
(1, 3)
(2, 1, 1)
(2, 2)
(3, 1)

Note that different sequences are counted as different combinations.

Therefore the output is 7.
```

(3,1)和(1,3)是两种不同的情况。求解顺序的完全背包问题时，**对物品的迭代应该放在最里层**。一般都是求解物品的迭代放在最外层如for num in nums: 

```python
dp = [0]*(target+1)
dp[0] = 1
        
for i in range(1,target+1):
    for num in nums:
        if num <= i:
           dp[i] += dp[i-num]
return dp[target]
```





#### 多重背包: 物品数量受限

---



#### 多维费用背包: 物品不仅有重量，还有体积，同时考虑两种限制

---

多维费用, 相当于有多个背包，一个背包存重量，一个背包存体积。

[01 字符构成最多的字符串](https://cyc2018.github.io/CS-Notes/#/notes/Leetcode%20%E9%A2%98%E8%A7%A3%20-%20%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92?id=_01-%e5%ad%97%e7%ac%a6%e6%9e%84%e6%88%90%e6%9c%80%e5%a4%9a%e7%9a%84%e5%ad%97%e7%ac%a6%e4%b8%b2)

```
Input: Array = {"10", "0001", "111001", "1", "0"}, m = 5, n = 3
Output: 4

Explanation: There are totally 4 strings can be formed by the using of 5 0s and 3 1s, which are "10","0001","1","0"
```

两个背包，一个背包存0的数量，一个背包存1的数量

```python
dp = [[0]*(m+1) for _ in (n+1)]

for num in array:
  # 统计num中0,1的数目返回 zeros, ones
  for i in range(n,ones-1,-1):
    for j in range(m,zeros-1,-1):
      dp[i][j] = max(dp[i][j],dp[i-ones][j-zeros]+1)
return dp[n][m]

```


