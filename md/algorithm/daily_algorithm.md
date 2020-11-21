[TOC]







#### 5. 最长回文子串

子串是连续的

* 方法一: 暴力匹配

* 方法二: 输入s，与倒转过后的s1之间求最长公共子串

* 方法三: 动态规划 

  * ```
    dp[i][j] = dp[i+1][j-1] && s[i] == s[j]  dp[i][j] 位置i到位置j之间是否是回文字符串
    ```

* 方法四: 中间往外扩散的思路，以每个position为回文字符串的中点 往两边扩散

  * time: O(n*n)  space: O(1)

* 方法五: Manacher  

  * time: O(n)

#### 10.正则表达式匹配

```
'.' 匹配任意单个字符
'*' 0个或多个前面的元素
```

写出递归结构，考虑只有一个"."存在的情况

```python
def isMatch(text,pattern):
    if pattern is empty: return text is empty
    # 考虑第一个字符是否匹配
    first_match = (text not empty) and (pattern[0] in (text[0],'.'))
    return first_match and isMatch(text[1:],pattern[1:])
```

考虑'*' 和 '.'都存在的情况

```python
# 暴力递归
def isMatch(text,pattern):
    if pattern is empty: return text is empty
    first_match = (text not empty) and (pattern[0] in (text[0],'.'))
    # 考虑*的情况
    if len(pattern) >= 2 and pattern[1] == "*":
        # "*" 匹配0次
        match_0 = isMatch(text,pattern[2:])
        # "*" 匹配1次
        match_1 = first_match and isMatch(text[1:],pattern)
        return match_0 or match_1
    else:
        return first_match and isMatch(text[1:],pattern[1:])
```

上述问题存在重复子问题

```python
def dp(i,j):
	# i是text中index, j是pattern中的index
    dp(i,j+2) # "*" 匹配0次
    dp(i+1,j) # "*" 匹配1次
    dp(i+1,j+1) # 没有 "*"
```



* 带memo的递归

  ```python
  def isMatch(text,pattern):
      memo = dict()	
      def dp(i,j):
          if (i,j) in memo: return memo[(i,j)]
      	if j == len(pattern): return i == len(text)
          first_match = ( i < len(text)) and (pattern[j] in (text[i],'.'))
          
          if len(patten) - j > 2 and pattern[j+1] == "*":
              match_0 = fisrt_match and dp(i,j+2)
             	match_1 = dp(i+1,j)
              ans = match_0 or match_1
          else:
              ans = first_match and dp(i+1,j+1)
         	memo[(i,j)] = ans
          return ans
      
      return dp(0,0)
  ```

  