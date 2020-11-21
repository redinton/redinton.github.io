[TOC]

### 数组

#### 数据流中的中位数

---

* 大根堆，小根堆
  * 数据流中数目是奇数时，将数据插入大根堆，反之 — 大根堆的最大值小于 小根堆的最小值
  * 当数要插入大根堆时，先和小根堆的最小值比较，如果大于小根堆的最小值，两者换一下，再插入大根堆
  * 反之，要插入小根堆时，先和大根堆的最大值比较，若小于大根堆最大值，互换，再插入小根堆

  

#### 数组中的重复数字

---

* 0-n-1范围中中n个数字，存在多个重复，找出一个
* 排序/哈希表 - 空间复杂度O(n)
* **0-n-1 对应位置对应的值保持一致**
  * 1,3,5,0 - idx=0对应的值为1，找到idx=1的位置，看值是否等于1，若等于说明重复，
  * 若不等于，交换变为 3,1,5,0，继续看3



####旋转数组的最小数字

----

3，4，5，1，2 是 1，2，3，4，5的一种旋转方式

* 二分法



#### 调整数组顺序使奇数都在偶数前面

---

* 前后两个指针，往中间走
  * first指向偶数，last指向奇数，互换

##### 变种一 保持奇数 偶数相对位置不变

前面是偶数 后面是奇数

```python
    # 方法1
  	# i is the index of the even sequence next item
    i,j = 0,0
    while j < len(A):
        if A[j] % 2 == 0 and j > i:
            A = A[:i] + [A[j]] + A[i:j] + A[j+1:]
            i += 1
        else:
            j += 1
    return A
    
    # 方法2
        # i is the index of the even sequence next item
        i,j = 0,0
        while j < len(A):
            if A[j] % 2 == 0:
                tmp = j
                while tmp > i:
                    A[tmp],A[tmp-1] = A[tmp-1],A[tmp]
                    tmp -= 1
                i += 1
            j += 1
        return A
```
##### 变种二  保持奇数 偶数 相对有序

思路变种1一样，排序用的是插入排序

```python
    # i is the index of the even sequence next item
    i,j = 0,0
    while j < len(A):
        if A[j] % 2 == 0:
            tmp = j
            while tmp > i:
                A[tmp],A[tmp-1] = A[tmp-1],A[tmp]
                tmp -= 1                
            while tmp > 0 and A[tmp] < A[tmp-1]:
                A[tmp],A[tmp-1] = A[tmp-1],A[tmp]
                tmp -= 1
            i += 1
        else:
            tmp = j
            while tmp > i and A[tmp] < A[tmp-1]:
                A[tmp],A[tmp-1] = A[tmp-1],A[tmp]
                tmp -= 1
        j += 1
    return A
```


#### [有序矩阵查找](<https://leetcode.com/problems/search-a-2d-matrix-ii/description/>)

---

```python
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
每行每列都是递增的，在这个数组中找target数，存在return True 否则False
```

* 思路:每一行的最右边的这个数 matrix\[i]\[-1]都是本行最大的数，如果target小于这个数，那么左移，如果大于那么下移。

```python
        if len(matrix) == 0 or len(matrix[0]) == 0:
            return False
        
        i,j = 0,len(matrix[0])-1
        
        while i < len(matrix) and j > -1: 
            if matrix[i][j] == target:
                return True
            elif matrix[i][j] > target:
                j -= 1
            else:
                i += 1
        
        return False
        
```



#### [有序矩阵第K小的元素](<https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/description/>)

---

```python
    def kthSmallest(self, matrix: List[List[int]], k: int) -> int:
        import heapq
        heap = [(matrix[0][0],0,0)]
        cnt = 0
        heapq.heapify(heap)
        while heap:
            print (heap)
            num,i,j = heapq.heappop(heap)
            cnt += 1
            if cnt == k:
                return num
            else:
                if i+1 < len(matrix):
                    heapq.heappush(heap,(matrix[i+1][j],i+1,j))
                #### 注意只在第一行时，才可以右移, 避免重复
                if i == 0 and j+1 < len(matrix[0]):
                    heapq.heappush(heap,(matrix[i][j+1],i,j+1))
```



#### [Car Pooling](<https://leetcode.com/problems/car-pooling/>)

---

>```
>Input: trips = [[2,1,5],[3,3,7]], capacity = 4
>Output: false
>Input: trips = [[2,1,5],[3,3,7]], capacity = 5
>Output: true
>0 <= trips[i][1] < trips[i][2] <= 1000
>```

```python
    def carPooling(self, trips, capacity):
        """
        :type trips: List[List[int]]
        :type capacity: int
        :rtype: bool
        """
        tmp = [x for n, i, j in trips for x in [[i, n], [j, - n]]]
        for i, v in sorted(tmp,key=lambda x:(x[0],x[1])):
            capacity -= v
            if capacity < 0:
                return False
        return True
```

该时间复杂度为O(nlogn)涉及到排序， 可以用一个1001的数组存 就不用排序了



####一个长度为n的数组，求其中出现次数大于n/2的元素，要求线性时间复杂度，恒定空间复杂度

由于是恒定空间复杂度。

考虑遍历数组时，一旦当前数与之前的数不同就相互抵消，最终剩下的数一定是数目大于n/2的数。



#### N sum

* 2 sum 用hash

* 3 sum 数组中三个数的和等于某个数(一般是0)

  * 可以先排序 O(nlogn)

  * 第一个数是在nums[:-2]中找，确定了第一个数，再用2sum的方式找剩下的两个数

    * 优化，在确定第一个数的时候，如果这个数和前一个数相同可以跳过

      ```python
          if len(nums) < 3:
              return []
          nums.sort()
          res = set()
          for i, v in enumerate(nums[:-2]):
              if i >= 1 and v == nums[i-1]:
                  continue
              d = {}
              for x in nums[i+1:]:
                  if x not in d:
                      d[-v-x] = 1
                  else:
                      res.add((v, -v-x, x))
          return map(list, res)
      ```

* 3 sum closest
  
  * 找三个数，他们之和**最接近于**给定数
  * 方法同3 sum，但是
    * 在遍历第一个数后，后面两个数的确定可以用双指针
  
  ```python
      def threeSumClosest(self, nums: List[int], target: int) -> int:
          nums.sort()
          minus = float('inf')
          ans = 0
          for i in range(len(nums)-2):
              left = i+1
              right = len(nums)-1
              while left < right:
                  sum2 = nums[left] + nums[right]
                  if abs(sum2+nums[i]-target) < minus:
                      ans = sum2+nums[i]
                      minus = abs(sum2+nums[i]-target)
                  if sum2 < target-nums[i]:
                      left +=1
                  elif sum2 > target-nums[i]:
                      right -=1
                  else:
                      return target
          return ans
  ```
  
  
  
* 4 Sum
  * 通过递归先变成3Sum，再变成2Sum.
  * <https://leetcode.com/problems/4sum/discuss/8545/Python-140ms-beats-100-and-works-for-N-sum-(Ngreater2)>

```python
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        
        re,path = [],[]
        nums.sort()
        self.NSum(4,path,re,nums,target)
        return re
    
    
    def NSum(self,N,path,re,nums,target):
        if N > 2:
            for i in range(len(nums)-N+1):
                if i > 0 and nums[i] == nums[i-1]:
                    continue
                self.NSum(N-1,path+[nums[i]],re,nums[i+1:],target-nums[i])
        else:
            left = 0
            right = len(nums)-1
            while left < right:
                sum2 = nums[left]+nums[right]
                if sum2 < target:
                    left += 1
                elif sum2 > target:
                    right -=1
                else:
                    if left==0 or nums[left]!=nums[left-1]:
                        re.append(path+[nums[left],nums[right]])
                    left += 1
            return
        return
        
```



#### [435. Non-overlapping Intervals](<https://leetcode.com/problems/non-overlapping-intervals/>)

最少移除几个intervals让剩下的没有重叠

```python
def eraseOverlapIntervals(self, intervals):
    """
    :type intervals: List[Interval]
    :rtype: int
    """
    end = float('-inf')
    erased = 0
    for i in sorted(intervals, key=lambda i: i.end):
        if i.start >= end:
            end = i.end
        else:
            erased += 1
    return erased
```


#### [452. Minimum Number of Arrows to Burst Balloons](<https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/>)

不重叠的区间数目

```python
def findMinArrowShots(self, points):
    """
    :type points: List[List[int]]
    :rtype: int
    """
    points = sorted(points,key=lambda x:(x[1]))
    num,end = 0, -float('inf')

    for point in sorted(points,key=lambda x:(x[1])):
        if point[0] > end:
            num += 1
            end = point[1]
    return num
```


### 递归

#### 青蛙跳 / 小矩阵覆盖大矩形问题

---

用2\*1的小矩形，覆盖2 \* 8 的大矩形有几种方法

* 覆盖2*8 的方式记为f(8)

  ![image-20190326160440626](/Users/K/Library/Application Support/typora-user-images/image-20190326160440626.png)



#### 数值的整数次方

---

* check 底数是否为0 ； 幂是整数还是负数还是0
* 递归求解





### 回溯

#### 79. Word search (Leetcode) / 机器人的运动范围

---

记录 i, j, index(到目前为止走过的路), pre(之前经历过的节点)





### 动态规划

#### 剪绳子

---

![image-20190326183324885](/Users/K/Library/Application Support/typora-user-images/image-20190326183324885.png)



* 动态规划 - O($n^{2}$) 时间, O(n) 空间
  * 从f(1),f(2),f(3)算起到f(n)
* 贪心 每次剪 3 - O(n)



#### 最长公共子序列/公共子串

---

* 子序列: 子串要求在原字符串中是**连续的**，而**子序列则只需保持相对顺序一致**，并不要求连续。例如X = {a, Q, 1, 1}; Y = {a, 1, 1, d, f}那么，{a, 1, 1}是X和Y的最长公共子序列，但不是它们的最长公共字串。
* 子序列
  * 建立状态转移矩阵，行坐标为序列1，纵坐标为序列2





### 位运算

#### 二进制中1的个数

---

* 思路1:输入Num， 对Num不断右移一位，再与1 相与，看最低位是否为1,针对负数情况不好解决
* 思路2:左移flag, flag 一开始为1，输入Num有几个bit移几次，



#### 输入整数m,n，问改变m的二进制表示几位，可以得到n

---

* m的二进制表示和n的二进制表示 异或
* 统计1的数目







