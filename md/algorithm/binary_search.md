---
title: binary_search
date: 2020/10/29 09:33:38
toc: true
tags:
- algorithm
---

二分查找模板

<!--more-->

#### 数组单调有序
* 数组无重复,找target
* 数组有重复,找target

区分点
* 初始化时
  * right = len(nums) - 1 意味着搜索区间是闭区间[0,len(nums)-1]
  * right = len(nums) 意味着搜索区间是闭区间[0,len(nums))
* break while循环时
  * left < right 意味着退出时 left = right
  * left <= right 意味着退出时 left = right + 1
* while 循环内部 当nums[mid] == target时
  * 搜索左边界 right = mid 当right初始化时 = len(nums), 否则 mid - 1 当right = len(nums)-1
  * 搜索右边界 left = mid + 1
* 跳出while 循环后
  * 需要判断此时的left / right 是否过界
  * 针对left的操作始终是 + 1，因此将left和len(nums)比较, 针对right的操作始终是 - 1 或者不减, 因此将right和0比较。

```python
def searchLeft(A,target):
    l,r = 0,len(A)-1
    while l <= r:
        mid = l + (r-l) // 2
        if A[mid] > target:
            r = mid - 1 
        elif A[mid] < target:
            l = mid + 1
        else:
            r = mid - 1 
    if l >= len(A) or A[l] != target:
        return -1
    return l

def searchRight(A,target):
    l,r = 0,len(A)-1
    while l <= r:
        mid = l + (r-l) // 2
        if A[mid] > target:
            r = mid - 1 
        elif A[mid] < target:
            l = mid + 1
        else:
            l = mid + 1
    if r < 0 or A[r] != target:
        return -1
    return r
```

#### 数组单调有序,但经过旋转
##### [求旋转(无重复)数组的最小值](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/)
关键点在于将nums[mid]和nums[right]比较,判断mid是在最小值的左边还是右边

```python
if nums[mid] > nums[right]:
    left = mid + 1
else:
    right = mid
```

##### [求旋转(有重复)数组的最小值](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array-ii/)
和上述情况相同,唯一不同就是在 nums[mid] == nums[right] 情况上的处理, 此时不能确定最小值是在mid的左边还是右边
```python
if nums[mid] > nums[right]:
    left = mid + 1
elif nums[mid] < nums[right]:
    right = mid
else:
    right -= 1  # 或者直接 return min(nums[left:right+1])

i, j = 0, len(numbers) - 1
while i < j:
    mid = i + (j - i) // 2
    if numbers[mid] > numbers[j]:
        i = mid + 1
    elif numbers[mid] < numbers[j]:
        j = mid
    else:
        return min(numbers[i:j+1])
return numbers[i]
```

* 在旋转(无重复)数组中搜索target
思路就是先找到旋转数组的最小值,再用二分查找

```python
def findMin(nums):
    l,r = 0,len(nums)-1
    while l < r:
        mid = l + (r-l)//2
        if nums[mid] > nums[r]:
            l = mid + 1
        else:
            r = mid
    return l

def binarySearch(nums,i,j,target):
    l,r = i,j
    while l <= r:
        mid = l + (r-l) // 2
        if nums[mid] > target:
            r = mid - 1
        elif nums[mid] < target:
            l = mid + 1
        else:
            return mid
    return -1


minInd = findMin(nums)

if target <= nums[-1]:
    return binarySearch(nums,minInd,len(nums)-1,target)
else:
    return binarySearch(nums,0,minInd-1,target)
```

##### [在旋转(有重复)数组中搜索target](https://leetcode-cn.com/problems/search-in-rotated-sorted-array-ii/)

```java
public boolean search(int[] nums, int target) {
    if (nums == null || nums.length == 0) {
        return false;
    }
    int start = 0;
    int end = nums.length - 1;
    int mid;
    while (start <= end) {
        mid = start + (end - start) / 2;
        if (nums[mid] == target) {
            return true;
        }
        if (nums[start] == nums[mid]) {
            start++;
            continue;
        }
        //前半部分有序
        if (nums[start] < nums[mid]) {
            //target在前半部分
            if (nums[mid] > target && nums[start] <= target) {
                end = mid - 1;
            } else {  //否则，去后半部分找
                start = mid + 1;
            }
        } else {
            //后半部分有序
            //target在后半部分
            if (nums[mid] < target && nums[end] >= target) {
                start = mid + 1;
            } else {  //否则，去前半部分找
                end = mid - 1;

            }
        }
    }
    //一直没找到，返回false
    return false;

    }
```
