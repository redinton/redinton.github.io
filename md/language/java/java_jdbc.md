[TOC]



* java.sql中 三个接口
  * Statement: 执行静态SQL语句并返回它所生成结果的对象
  * PreparedStatement:  SQL语句被**预编译并存储在此对象**中,可以使用该对象多次高效地执行该语句
    * 可以操作图片视频 通过占位符，操作Blob类型的数据，Statement 做不到
    * 可以实现更高效的操作
  * CallableStatement:用于执行 SQL存储过程