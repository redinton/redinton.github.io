

[TOC]



### 基本概念

* 编译型语言： **代码直接编译成机器码**执行, 但是不同的平台（x86、ARM等）CPU的指令集不同，因此，需要编译出每一种平台的对应机器码。
  * 例子： C, C++
* 解释型语言： 可以由**解释器直接加载源码**然后运行，代价是运行效率太低。
  * 例子: python , ruby
* Java是将代码编译成一种“字节码”，它类似于抽象的CPU指令，然后，针对不同平台编写虚拟机，不同平台的虚拟机负责加载字节码并执行，这样就实现了“一次编写，到处运行”的效果。



#### Java 版本

- Java SE：Standard Edition

- Java EE：Enterprise Edition

- Java ME：Micro Edition

  

* Java SE就是标准版，包含标准的JVM和标准库，
* Java EE是企业版，它只是在Java SE的基础上加上了**大量的API和库**，以便方便开发Web应用、数据库、消息服务等，Java EE的应用使用的虚拟机和Java SE完全相同。
* Java ME就和Java SE不同，它是一个针对嵌入式设备的“瘦身版”，Java SE的标准库无法在Java ME上使用，Java ME的虚拟机也是“瘦身版”。



1. 首先要学习Java SE，掌握Java语言本身、Java核心开发技术以及Java标准库的使用；

2. 如果继续学习Java EE，那么Spring框架、数据库开发、分布式架构就是需要学习的；

   

- JDK：Java Development Kit

- JRE：Java Runtime Environment

  JRE就是运行**Java字节码的虚拟机**。但是，如果只有Java源码，要编译成Java字节码，就需要JDK，因为JDK除了包含JRE，还提供了**编译器、调试器**等开发工具。



#### JDK

- java：这个可执行程序其实就是JVM**，运行Java程序，就是启动JVM，然后让JVM执行指定的编译后的代码**；
- javac：这是Java的编译器，它用于把Java源码文件（以`.java`后缀结尾）编译为**Java字节码文件**（以`.class`后缀结尾）；
- jar：用于把一组`.class`文件打包成一个`.jar`文件，便于发布；
- javadoc：用于从Java源码中自动提取注释并生成文档；
- jdb：Java调试器，用于开发阶段的运行调试。



#### Java 代码

* 一个**Java源码只能定义一个`public`类型的class**，并且**class名称和文件名**要完全一致；

* 使用`javac`可以将`.java`源码编译成`.class`字节码
* 使用`java`可以运行一个已编译的Java程序，参数是类名