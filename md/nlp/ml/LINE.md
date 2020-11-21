

[TOC]



LINE：Large-scale Information Network Embedding (2015 WWW)

NRL(Network representation learning)

#### Contribution

适用于任意类型的网络：无向、有向和有权、无权, 适用于大型(百万节点)的网络

#### Limitation

只保留了一阶相似度(节点之间直接存在关系)和二阶相似度(临近网络结构的相似性)。

在数学上，设$\mathrm{p}_{\mathrm{u}}=\left(\mathrm{w}_{\mathrm{u}, 1}, \ldots, \mathrm{w}_{\mathrm{u},}|\mathrm{v}|\right)$表示u与所有其他顶点的一阶相似度，则u和v之间的二阶相似度 由 pu和pu决定。 如果没有顶点与u和v都连接，则u和v之间的二阶相似度为0。



