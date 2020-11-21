

[TOC]

### 图的基本概念

* 图的表示
  * 1.邻接矩阵
    * n*n的邻接矩阵
  * 2.邻接表
    * 为每个点建立一个链表(数组)存放与之相连的点
* 图的搜索
  * BFS
    * 双向BFS
      * graph中，从起点和终点分别开始走，直到相遇 - 树形搜索结构变成纺锤形
      * 这样更"快"，因为经典BFS中，树形结构高度较高时，叶子非常多，将一颗高度为h的树用两个近似为 h/2的树代替，宽度相对小。
  * DFS



### 最短路径

---

针对n节点的有向图

####迪杰斯特拉(Dijkstra)

伪代码如下

```python
 bool S(1:n) # 记录n个节点是否被访问过
 cost(n*n) # 邻接矩阵
 dist(1:n) # dist(j) 记录从起始节点v到节点j的最短路径长度
 
 # step1:
 # 根据cost(n*n) 初始化 dist(1:n), 
		# 若j与起始节点v存在link, dist(j)=cost[v][j] 否则dist(j)=正无穷。 
  	# 同时 s[v] = 1, dist[v] = 0
 # step2:
 # 1.选出 dist(u) = min(dist(w)) which s[w] = 0 就是在没有访问过的点中找出最小的距离
 # 2.s[u] = 1
 # 3.针对剩余的s[w] = 0(即没有访问过的点)
 #		dist(w) = mmin(dist(w) , dist(u)+cost(u,w))
 

```

* 不能有负权值边

  * 算法中，已经访问过的点是不会被更新的，若存在负权边，则可能出现后面遇到的点的带上负权边后权重小于原来的，但是因为已经被访问过了，无法被更新。

  

####弗洛伊德算法 (FLOYD)

* 寻找给定的加权图中多源点之间最短路径的算法

* 如果图中存在负的权值，算法也是适用的。

* map[i,j] = min{ map[i,k] + map[k,j], map[i,j]} k是所有结点  — 复杂度 O($n^3$) 

```
D[u,v] = A[u,v]
for k:= 1 to n
	for i:= 1 to n
		for j:= 1 to n
			if D[i,j] > D[i,k] + D[k,j]
				D[i,j] = D[i,k] + D[k,j]
```



#### Bellman-ford算法

* 适用: 单源结点到其他所有节点的最短路径
* 若 u->v 是有向边, 则 d[v] <= d[u] + dis[u,v]
* 对边的权重没有要求，可以发现负环
* 图的最短路径 既不能包含负权值回路，也不能包含正权值回路，因此至多|V|-1条边

```python
for each vertex v in G do
	d[v] = 正无穷
d[s] = 0 

for i = 1 to n-1 do
	### 以下的循环一共作 n-1次，第一次找从s出发走一步能到的那些结点的最短路径，第二次找从s出发
  ### 走两步能到的那些结点的最短路径 ，因此至多 |V|-1 次循环 生成以源点S为根的最短路径树
	for each edge(u,v) in G do
		if d[v] > d[u] + w(u,v) 
			d[v] = d[u] + w(u,v)

for each edge(u,v) in G do
	if d[v] > d[u] + w(u,v)
		return false   ## 检查是否存在回路
 	return true

```

改进: 如果第k次循环后，最短路径没有得到更新，显然之后也任然无法更新，因此可以提前退出，并且如果k<n-1，一定不存在负环。



### 最小生成树(MST minimum spanning tree) 

---

从一个带权值无向图中选择n-1条边，并使这个图仍然连通(即得到了一颗生成树)，同时考虑树的权重最小。

连通加权无向图中一棵权值最小的生成树。

应用：比如说有N个城市需要建立互联的通信网路，如何使得需要铺设的通信电缆的总长度最小呢？这就需要用到最小生成树的思想了。

####普里姆算法(Prim)

O($n^2$) 



#### 库鲁斯卡尔(Kruskal)

O(nlogn)



####[判断是否是二部图](https://leetcode.com/problems/is-graph-bipartite/submissions/)

> ```
> Input: [[1,3], [0,2], [1,3], [0,2]]
> 下标i表示节点到对应的graph[i中存在着边
> 用涂色的方法，相邻节点涂不一样的颜色，如果同一个点可以被涂不一样的颜色，证明不是二部图
> ```

```python
def isBipartite(self, graph):
    """
    :type graph: List[List[int]]
    :rtype: bool
    """
    color = {}
    for i in range(len(graph)):
        #print (i)
        if i not in color:
            color[i] = 1
        if not self.dfs(graph,i,color):
            return False
    return True
    
def dfs(self,graph,i,color):
    col = color[i]
    for num in graph[i]:
        if num in color:
            if color[num] != -col:
                return False
        else:
            color[num] = -col
            if not self.dfs(graph,num,color):
                return False
    return True
```




#### [拷贝图](https://leetcode.com/problems/clone-graph/submissions/)

* 用一个dict来存节点

```python
"""
class Node(object):
    def __init__(self, val, neighbors):
        self.val = val
        self.neighbors = neighbors
"""
class Solution(object):
    def cloneGraph(self, node):
        """
        :type node: Node
        :rtype: Node
        """
        re = dummy = Node(node.val,[])
        from collections import deque
        queue = deque([node])
        store = dict()
        store[node] = re
        while queue:
            node = queue.popleft()
            for neighbor in node.neighbors:
                if neighbor not in store:
                    nodecopy = Node(neighbor.val,[])
                    store[neighbor] = nodecopy
                    store[node].neighbors.append(nodecopy)
                    queue.append(neighbor)
                else:
                    store[node].neighbors.append(store[neighbor])
        return re
```

