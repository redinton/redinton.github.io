

[TOC]

### node embedding

each node is assigned a unique embedding vector. Eg: **node2vec,DeepWalk,LINE**.

####Node2vec

#####define node similarity

* two nodes are connected
* share neighbors
* have similar "structural roles" ?

##### Adjacency-based similarity

loss function is as follow $\mathcal{L}=\sum_{(u, v) \in V \times V}\left\|\mathbf{z}_{u}^{\top} \mathbf{z}_{v}-\mathbf{A}_{u, v}\right\|^{2}​$

![image-20190424104407424](/Users/K/Library/Application Support/typora-user-images/image-20190424104407424.png)

To find the embedding matrix Z that minimized the loss L.

Option1 : SGD optimization

Option2: Solve matrix decompostion solvers (SVD or QR decomposision routines)

![image-20190424104633676](/Users/K/Library/Application Support/typora-user-images/image-20190424104633676.png)

##### Multi-hop similarity

* Consider **k-hop node** neighbors.

![image-20190424104800230](/Users/K/Library/Application Support/typora-user-images/image-20190424104800230.png)

![image-20190424104853864](/Users/K/Library/Application Support/typora-user-images/image-20190424104853864.png)

* measure **overlap between node neighborhood**s
  * Jaccard similarity / Adamic-Adar score

![image-20190424105025042](/Users/K/Library/Application Support/typora-user-images/image-20190424105025042.png)



* Both ideas
  * define pairwise node similarities
  * optimize **low-dimensional embeddin**g to approximate pairwise similarities
* Drawback
  * expensive , generally $O(|V|^2)$ , iterate over all pair of nodes
  * brittle, most hand-design deterministic node similarity measures
  * massive parameter space $O(|V|)$ paramters

##### Random Walk

considering $\mathbf{z}_{u}^{\top} \mathbf{z}_{v}$ as **probability that u and v co-occur** on a random walk over the network 

Intuition: Optimize embedding to maximize the likelihood of random walk co-occurrences.


​	![image-20190424110327952](/Users/K/Library/Application Support/typora-user-images/image-20190424110327952.png)

​	![image-20190424110439962](/Users/K/Library/Application Support/typora-user-images/image-20190424110439962.png)

![image-20190424110625175](/Users/K/Library/Application Support/typora-user-images/image-20190424110625175.png)

![image-20190424110643745](/Users/K/Library/Application Support/typora-user-images/image-20190424110643745.png)

![image-20190424110906794](/Users/K/Library/Application Support/typora-user-images/image-20190424110906794.png)

* random walk strategy
  * Just run fixed-length, unbiased random walks starting from each node
  * use flexible, **biased random walks** that can trade off between **local** and **global** views of the network 

![image-20190424111142884](/Users/K/Library/Application Support/typora-user-images/image-20190424111142884.png)

![image-20190424111410396](/Users/K/Library/Application Support/typora-user-images/image-20190424111410396.png)

![image-20190424111434039](/Users/K/Library/Application Support/typora-user-images/image-20190424111434039.png)

![image-20190424111501707](/Users/K/Library/Application Support/typora-user-images/image-20190424111501707.png)

* Other random walk idea

![image-20190424111608399](/Users/K/Library/Application Support/typora-user-images/image-20190424111608399.png)

**node2vec** performs better on **node classification** while **multi-hop** methods performs better on **link predictio**n (Goyal and Ferrara, 2017 survey).



#### node2vec with random walk

* for each node in the graph, generate the corresponding random walk path
* take each path as a word sequence and take all pathes as the training corpus to train "word2vec"
* The strategy for generating the walk path
  * for each node , there is a probability to choose the next node.
  * Using Alias method to sample a node according to the discrete distribution