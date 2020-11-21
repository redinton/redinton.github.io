---
title: tree_1
date: 2020/10/31 13:39:56
toc: true
tags:
- algorithms
---



### BST 二叉搜索树

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
