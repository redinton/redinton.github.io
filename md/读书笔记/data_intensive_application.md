[TOC]

### CH1
data system
* reliability
  * hardware error
  * software error
  * human error
* scability
  * load
  * performance
* maintainbility
  * operability
  * simplicity
  * evolvability


#### load
* requests per second 
* ratio of reads to writes in a db
* number of simultaneously active users
* hit rate on a cache

### CH2
data model and query language


### CH3
storage and retrieval

storage engine

* log-structured 
  * 这里的log不是指用来记录application活动信息的log，而是一种数据格式，仅支持append 数据的
  * 问题
    * concurrency control
    * reclaiming disk space so that log won't grow forever
    * crash recovery
    * partially written records
      * checksum to detect corrupted parts of the log
  * storage segment is a sequence of key-value pairs

log-segments with index

* SSTable -- sorted string  table (the key is sorted)
  * 写入的数据是无序的，读取时要保证有序
    * maintaining a sorted structure on disk (B-Tree)
    * maintaining  in memory -- red-black tree or AVL tree 保证插入时无序，读取时有序
  * 1.在内存里维护一个memtable- in memory balanced tree 
  * 2.当memtable大于某个阈值，就把他写到disk作为一个SSTable file，最新的SSTable file就是recent segment of the db
  * 3.当执行查找的时候，先在memtable中找，然后在most recent on-disk segment中找，然后在next-order segment 以此类推
  * 4.from time to time, 针对 segment files 做一些 merge 加compaction 

有个问题，还在memtable中的数据，有丢失的风险

* 解决: keep a separate log on disk , every write is  append， 不用排序，只是为了丢失memtable中的数据后recover.



LSM-tree (Log-Structured merge tree)

性能优化

* 当key不在db中时，按照LSM-tree的逻辑，先在memtable中找，然后是recent segment等等，要找遍所有的segments才知道key不存在
  * 解法: 增加一个额外的 bloom filter

* page-oriented like B-tree
  * SSTable 是把db切成 variable-size segments, always write  a segment sequentially
  * B-tree 是切成 fix-sized blocks 或者pages，read or write one page at a time, page 和page之间通过ref 指针连接起来



index 

* hash index
  * 

### CH4
encoding and evolution

### CH5
replication

### CH6
patitioning

### CH7
transactions

#### transaction
 > a way for an application to group several reads and writes together into a logical unit.

 > all reads and writes in a transaction are executed ad one operation. commit or rollback/abort

* pros and cons

* ACID
  * safety guarantee
  * atomicity
    * describe what happens if a client want to make several writes, but a fault occur after some  writes have been processed.
    * 描述的是一个transaction就是一个最小单元，里面的操作要么不做，要么都做。
  * consistency
    * 一致性, 确保数据在"意义"上不出错，比如一个支出和余额的数据，当支出的数据更新时，对应的余额的数据也要跟着更新。
    * 一致性，这个特点并不能完全由db确保，也和application有关系。
  * isolation
    * concurency problem. 
      * db accessed by several client at the same time if they access the same db records
    * isolation 意味着transaction之间相互隔离, 可能两个transaction都在对同一个db record做读取写入操作，但两个之间的操作不会有干扰。
  * durability
    * 数据持久化，一旦transaction commit成功以后，任何被修改的数据都不会丢失 即便有硬件问题或者数据库崩了(hardware fault or db crash)
    * 一般为了实现这个特性，db也会在写入/复制这些操作没有问题后才报 commit success


### CH8
trouble with distributed system

### CH9
consistency and consensus

### CH10
batch processing

### CH11
stream processing

### CH12
future of data system