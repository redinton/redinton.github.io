[TOC]











### 4 more-sensitive query suggestions

#### 4.1 generate query suggestions

##### 4.1.1 dictionary based suggesters

* 给定字典，构建Trie树
  * 主要用于autocompletion 速度快
* suggest characteristic eg: books about search engine
  * words removed from the query (query 中的词并不都要体现到suggestions中) books search engines
  * infix suggestions ( books about google search )
  * prefix removed (books about  被删掉了)





#### 8. content-based image search

* image 可以用CNN之类的NN extract 成向量
  * 问题等价成搜索 图库中的image vector 与query vector 最close的前几张图片
  * 1. 精确比较图库中所有的image vector 与 query vector 的similarity
       1. 复杂度过高
    2. K近邻算法 加 K-D tree 优化
    3. approximately 比较 LSH，locality sensitive hashing 



* should training happen before indexing
* or should indexing happen first
* how to combine those data-feeding tasks
* how to handle updates to the data



* NN must provide accurate results
* NN must provide results quickly
* software and hardware must be adequate for the computational load in terms of time and space 



* neural network prediction time
  * how long does NN take to extract vector from documents at indexing time ?
  * how long does it take to extract vector from query at search time
* SE index size
  * how much space do generated embedding take 



* Problem
  * re-indexing 
    * 因为要加些新的特性，所以要重新 index
  * high-volum concurrent indexing 并发
    * multiple parallel indexing processes
    * multiple user searching at the same time