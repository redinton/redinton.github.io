---
title: Tree相关算法题
date: 2020/10/31 13:39:56
toc: true
tags:
- algorithm
---



### BST 二叉搜索树
<!--more-->
#### [二叉搜索树的判定](https://leetcode-cn.com/problems/validate-binary-search-tree/)


#### [二叉搜索树的删除指定节点](https://leetcode-cn.com/problems/delete-node-in-a-bst/)

```python

TreeNode deleteNode(TreeNode root, int key) {
    if (root == null) return null;
    if (root.val == key) {
        // 这两个 if 把情况 1 和 2 都正确处理了
        if (root.left == null) return root.right;
        if (root.right == null) return root.left;
        // 处理情况 3
        TreeNode minNode = getMin(root.right);
        root.val = minNode.val;
        root.right = deleteNode(root.right, minNode.val);
    } else if (root.val > key) {
        root.left = deleteNode(root.left, key);
    } else if (root.val < key) {
        root.right = deleteNode(root.right, key);
    }
        return root;
    }

TreeNode getMin(TreeNode node) {
    // BST 最左边的就是最⼩的
    while (node.left != null) node = node.left;
    return node;
}
```

#### [二叉搜索树第k小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-bst/)
中序遍历第k个点。 最坏情况为O(N)  
改进: 因为红黑树这种改良的自平衡BST,CRUD都是O(logN)的复杂度。因此, 我们可以通过在每个节点额外记录以当前节点作为根的二叉树有多少节点。这样每次搜索的时候,就可以知道当前节点是排第几了。

#### [完全二叉树计算节点数目](https://leetcode-cn.com/problems/count-complete-tree-nodes/)

O(logN * logN) 的复杂度

#### 重建二叉树

---

给定二叉树的前序，中序遍历结果，重建二叉树

* 前序结果，第一个节点总是根节点的值, 根据该值在中序遍历结果找到对应的位置，进而找到左右子树的节点数目。
  * 前序: **1** 2 4 7 3 5 6 8，中序 4 7 2 **1** 5 3 8 6 -> 左子树三个节点，右子树四个节点
  * 2 4 7  4 7 2   |   3 5 6 8  5 3 8 6



#### 二叉树的下一个节点

---

给定一个二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针。

* 若该节点有右子树，找到该右子树的最左端

* 若该节点没有右子树，找到该节点的父节点

  * 若该节点是父节点的左节点,打印父节点

  * 若该节点是父节点的右节点, 借助父节点指针往上，一直到找个节点是其父节点的左节点为止




#### 树的子结构

---

输入两棵二叉树A,B，判断B是不是A的子结构

* 递归



#### 二叉树的镜像

---

输入一颗二叉树，输出其镜像

* 前序遍历树的每个节点，如果遍历到的节点有子节点，交换其两个子节点



#### 对称的二叉树

---

先前序遍历得到一个结果。

然后自定义一种遍历算法，先看父节点，再看父节点的右节点，再看父节点的左节点

##### recurisve way

```java
public boolean isSymmetric(TreeNode root) {
    if (root == null) return true;
    return isSymmetricHelper(root.left,root.right);

}

private boolean isSymmetricHelper(TreeNode left, TreeNode right) {
    if (left == null && right == null) return true;
    if (left == null || right == null) return false;
    if (left.val != right.val) return false;
    return isSymmetricHelper(left.left,right.right) && isSymmetricHelper(left.right,right.left);
}
```

##### iterative way

```java
public boolean isSymmetric(TreeNode root) {
    if (root == null) return true;
    Stack<TreeNode> stack =  new Stack<TreeNode>();
    stack.push(root.left);
    stack.push(root.right);

    while (!stack.isEmpty()) {
        TreeNode n1 = stack.pop();
        TreeNode n2 = stack.pop();
        if (n1 == null && n2 == null) continue;
        if (n1 == null || n2 == null || n1.val != n2.val) return false;
        stack.push(n1.left);
        stack.push(n2.right);
        stack.push(n1.right);
        stack.push(n2.left);
    }
    return true;
}
```



#### 树的高度

##### bottom up

---

```python
def maxDepth(self, root):
    if root is None:
        return 0
    left = self.maxDepth(root.left)
    right = self.maxDepth(root.right)
    return max(left , right) + 1
```

##### top down

```python
answer = 0
def maxDepth(self, root):
    """
    :type root: TreeNode
    :rtype: int
    """
    def find_depth(root,depth):
        if root is None:
            return
        if root.left is None and root.right is None:
            self.answer = max(self.answer,depth)
            find_depth(root.left,depth+1)
            find_depth(root.right,depth+1)
            find_depth(root,1)
            return self.answer

```

#### 树的path sum (root到leave)

```java
// recursive
public boolean hasPathSum(TreeNode root, int sum) {
    if (root == null) return false;
    if (root.left == null && root.right == null)
        return sum == root.val;
    return hasPathSum(root.left,sum-root.val) || hasPathSum(root.right,sum-root.val); 
}
```

```java
// iterative
public boolean hasPathSum(TreeNode root, int sum) {
    Stack <TreeNode> stack = new Stack<> ();	    
    stack.push(root) ;	    
    while (!stack.isEmpty() && root != null){
        TreeNode cur = stack.pop() ;	
        if (cur.left == null && cur.right == null){	    		
            if (cur.val == sum ) return true ;
        }
        if (cur.right != null) {
            cur.right.val = cur.val + cur.right.val ;
            stack.push(cur.right) ;
        }
        if (cur.left != null) {
            cur.left.val = cur.val + cur.left.val;
            stack.push(cur.left);
        }
    }	    
    return false ;
}
```



#### 平衡二叉树

---

思路 

* 对每个node的左右子树分别调用上述求高度的公式，然后判断左右子树的高度之差是否大于1
  * 复杂度 O(Nlog(N))
* 修改计算高度的函数
  * 计算高度本身也是递归，因此在该函数里就可以判断 左右子树高度之差是否大于1
  * O(N) 复杂度

```python
    def TreeDepth(self, pRoot):
        # write code here
        if not pRoot:
            return 0
        left = self.TreeDepth(pRoot.left)
        right = self.TreeDepth(pRoot.right)
        if abs(left-right) > 1:
            self.flag = False
            #return 0
        return max(left,right) + 1
```



#### [间隔遍历](<https://leetcode.com/problems/house-robber-iii/>)

---

```python
    def rob(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        return max(self.helper(root))
    
    def helper(self,root):
        if not root:
            return (0,0)
        
        left = self.helper(root.left)
        right = self.helper(root.right)
        
        # rob the current root now
        now = root.val + left[1] + right[1]
        # don't rob the current root
        later = max(left) + max(right)
        return (now,later)
```



#### [二叉树：输出根节点到叶子的路径](https://leetcode.com/problems/binary-tree-paths/)

```python
result = []
def binaryTreePaths(self, root):
    """
    :type root: TreeNode
    :rtype: List[str]
    """
    self.result = []
    if not root:
        return []

    self.helper(root,str(root.val))
    return self.result
    
def helper(self,node,tmp_path):
    if node.left:
        self.helper(node.left,tmp_path + "->" + str(node.left.val))
    if node.right:
        self.helper(node.right,tmp_path + "->" + str(node.right.val))
    
    if not node.left and not node.right:
        self.result.append(tmp_path)
        return
```
* 非递归的解法就是同时维护“一个node的stack”，和一个对应路径的“stack”



#### Trie树的构建

---



#### 前序中序后序遍历的非递归形式

---

* 前序 root -left -right，后序是 left- right -root, 通过修改前序遍历的顺序为 root-right-left, 然后对结果reverse，就可以得到left-right-root即后序遍历的结果。

* 前序遍历利用stack 的特性，先压右子树再压左子树

* 中序遍历 
  * 每次先找到节点的最左端，往上走一格，然后跳转到right child



#### [完全二叉树的总节点数](<https://leetcode.com/problems/count-complete-tree-nodes/>)

完全二叉树：除了最后一层可能不满，其余都是满的。 要是所有层都是满的，就是满二叉树。

```python
def countNodes(self, root):
    """
    :type root: TreeNode
    :rtype: int
    """
    if not root:
        return 0
    left_len = self.height(root.left)
    right_len = self.height(root.right)
    
    ## last in the right
    if left_len == right_len:
        return 2**left_len -1 + self.countNodes(root.right) + 1
    ## lase in the left
    elif left_len == right_len + 1:
        return 2**right_len -1 + self.countNodes(root.left) + 1
    
def height(self,node):
    cnt = 0
    while node:
        cnt += 1
        node = node.left
    return cnt
```
思路就是找出叶子节点最后一个不满足的位置，对于子树是满二叉树，则直接用公式求节点数目

复杂度就是logN* logN





#### [N个结点的二叉搜索树有多少种组成方式](<https://leetcode.com/problems/unique-binary-search-trees/submissions/>)

递推， 3个节点可以有 左边0个，右边2个，左边一个，右边一个，左2个，右边0个

```python
def numTrees(self, n):
    """
    :type n: int
    :rtype: int
    """
    g = [1,1]
    i = 2
    while len(g) < n+1:
        tmp = 0
        for j in range(1,i+1):
            tmp += g[j-1]*g[i-j]
        g.append(tmp)
        i += 1
    return g[n]
```



#### 树的层级遍历

* 通常需要两个stack来记录前后两层的节点
* 但是可以通过 一个变量记录进入该层之前stack中的节点数，变成只需要一个stack

```java
public List<List<Integer>> levelOrder(TreeNode root) {
    Queue<TreeNode> layer1 = new LinkedList<TreeNode>();
    if (root != null)  layer1.offer(root);
    List<List<Integer>> result = new LinkedList<List<Integer>>();

    while (! layer1.isEmpty()) {
        List<Integer> curr = new ArrayList<Integer>();
        // 记录数目
        int num = layer1.size();
        for (int i = 0; i < num; i++){
            TreeNode node = layer1.poll();
            curr.add(node.val);
            if (node.left != null) layer1.offer(node.left);
            if (node.right != null) layer1.offer(node.right);
        }
        result.add(curr);
    }
    return result;
}
```