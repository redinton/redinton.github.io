[TOC]



### 链表整个反转

---

* 借助stack
* 直接在原位置断开
  * ![image-20190328155925035](/Users/K/Library/Application Support/typora-user-images/image-20190328155925035.png)



### 链表指定反转

### 链表带随机指针的复制

---

* 哈希表: key 原node  value 复制的node

  第二次遍历原链表 利用哈希表得到对应node，该node的next和random直接用key的next random去找

* 第二种方法  剑指offer A-a-B-b-C-c

![](./img/node_copy.png)



 ### O(1) 时间删除指定 链表节点

---

* 一般是通过遍历得到该节点上一个节点 然后连接

​        把要删除的节点的下一个节点的值和指针都复制到要删除的节点，然后删除下一个节点

###  旋转单链表

---

1-2-3-4-5 K=2 变成 4-5-1-2-3

* 用快慢指针，快指针先走K步，然后慢指针的下一个node就是新链表的head，快指针指向原head.

​        边界条件，先获得整个链表长度n，然后快指针走的应该是K%n



### 删除单链表倒数第K个节点

---

* 双指针，快指针先走K步

 ### 单链表的中间节点

---

* 双指针 快指针走两步

### 链表划分

给定单链表和值x，小于x的节点在大于x的前面

---

* 新建两个node，第一个接遍历时比x小的node，第二个接遍历时大于等于x的node，然后把第二个接到第一个后面

### 合并两个排序的链表

---

* 考虑临界情况-其中一个链表为空
* 若两者都非空，那么按照合并两个有序list的方式来合并

### 拓展K个排序的链表合并

---

* K个链表中两两合并，然后不停迭代，类似merge
* 遍历所有的点，放到list用list sort 

### 删除链表中重复的结点

---

* 三指针法 - 一个pre,一个curr，一个next,当cur==next.val时，让next不断右移直到不同

###  判断单链表是否存在环

---

* 快慢指针相遇

###  链表环入口

---

* 当快慢指针相遇后,其中一个指针重新指回head,两者同时出发,相遇点即是环的入口

  ```python
  def detectCycle(self, head):
          """
          :type head: ListNode
          :rtype: ListNode
          """
          fast,slow = head,head
          while fast and fast.next:
              fast = fast.next.next
              slow = slow.next
              if fast == slow:
                  meet = head
                  while meet != fast:
                      meet = meet.next
                      fast = fast.next
                  return fast
          return None
  ```

  

### 两个无环单链表是否相交

---

相交则返回第一个相交节点

* 方法一：遍历得到两个链表长度l1,l2, 得到差值abs(l1-l2),让长的链表的节点先出发abs(l1-l2),然后同时出发

* 方法二：用stack分别存每个node的value，然后同top开始pop比较

* 方法三：用“环”-，先遍历得到链表A的尾结点，然后接到B的首节点上，接着遍历B，用快慢指针遍历B看是否有环？或者是否会回到B的起点(可以用一个tmp copy B_head后进行next迭代)

* 方法四: 从l1,l2同时开始遍历，l1遍历到None时从l2接入，l2遍历到None时，从l1接入，最终相遇位置就是相交点。 相当于l1,l2分别都走了l1+l2长度的距离

  * ```python
        def getIntersectionNode(self, headA, headB):
            """
            :type head1, head1: ListNode
            :rtype: ListNode
            """
            l1,l2 = headA,headB
            while l1 != l2:
                l1 = l1.next if l1 else headB
                l2 = l2.next if l2 else headA
            return l1
    ```

* 把B链表接到A链表，相当于求环的入口

### 两个有环链表是否相交 

---

分三种情况，

* 先分别找到两个有环链表的环入口

* 如果两个链表的入环节点相同, 则两个链表**相交**
* 两个链表的入环节点不同
  * 固定一个入环节点, 从另一个入环节点出发, 遍历环一周, 如果遇到第一个入环节点, 则两个链表相交, 返回任意一个入环节点即可.
* 如果遍历环一周, 没有遇到第一个入环节点, 则两个链表不相交.

### 单链表的排序

---



