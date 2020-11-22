---
title: bash技巧
date: 2020/11/12 10:04:55
toc: true
tags:
- linux
---


Bash终端命令
<!--more-->
* ctrl-r 搜索命令行历史记录
  * 重复按ctrl-r 会向后查找匹配项
  * Enter 会执行当前匹配命令
  * 右方向键 会把匹配项放入当前行，不会直接执行
* ctrl - u  删除光标所在位置之前的内容
* ctrl - k 删除光标到行尾的内容
* ctrl - a 光标移至行首
* ctrl - e 光标移至行尾
* history 查看命令行历史记录
  * !n(n是命令编号) 可以再次执行
  * !! 指代上次键入的命令
* cd - 回到前一个工作路径
* pstree -p 展示进程树
* 