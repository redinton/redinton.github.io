[TOC]





### 集合

#### Collection 

* Java标准库自带的`java.util`包提供了集合类：`Collection`
  * `List`：一种有序列表的集合，例如，按索引排列的`Student`的`List`；
  * `Set`：一种保证没有重复元素的集合，例如，所有无重复名称的`Student`的`Set`；
  * `Map`：一种通过键值（key-value）查找的映射表集合，例如，根据`Student`的`name`查找对应`Student`的`Map`。

* Java访问集合总是通过统一的方式——迭代器（Iterator）来实现，它最明显的好处在于无需知道集合内部元素是按什么方式存储的。



有一小部分集合类是遗留类，不应该继续使用：

- `Hashtable`：一种线程安全的`Map`实现；
- `Vector`：一种线程安全的`List`实现；
- `Stack`：基于`Vector`实现的`LIFO`的栈。

还有一小部分接口是遗留接口，也不应该继续使用：

- `Enumeration`：已被`Iterator`取代。	



Java 集合设计的特点:

* 接口和实现类相分离

  * 有序表接口是List,实现类有ArrayList,LinkedList

* 支持泛型,可以限制在一个集合只能放入同种数据类型的元素

  ```Java
  List<String> list = new ArrayList<>();
  ```

  
  
  对于引用字段的比较, 用equals, 对于基本类型字段的比较,用 ==





#### List 

List是接口，初始化的方式

１. 

```java
List<String> name = ArrayList();
name.add("xxx")
name.add("yyy")
```

2.

```java
List<String> name = Arrays.asList("xxx","yyy") // list的size固定
```

3.

```java
List<String> name = new ArrayList<>(Arrays.asList("xxx","yyy"))
```

4.java 9以后的特性

```java
List<String> name = new ArrayList<>(List.of("xxx","yyy"))
```









### 泛型

* 泛型就是定义一种模板，例如`ArrayList`，然后在代码中为用到的类创建对应的`ArrayList<类型>`：

> ```java
> ArrayList<String> strList = new ArrayList<String>();
> ```

#### 向上转型

* 在Java标准库中的`ArrayList`实现了`List`接口，它可以向上转型为`List`：

> ```java
> public class ArrayList<T> implements List<T> {
>     ...
> }
> 
> List<String> list = new ArrayList<String>();
> ```

即类型`ArrayList`可以向上转型为`List`。

* 泛型的好处是使用时不必对类型进行强制转换，它通过编译器对类型进行检查；



* 编译器如果能自动推断出泛型类型，就可以省略后面的泛型类型

  > ```java
  > List<Number> list = new ArrayList<Number>();
  > // 可以省略后面的Number，编译器可以自动推断泛型类型：
  > List<Number> list = new ArrayList<>();
  > ```

#### 泛型接口

`Arrays.sort(Object[])`可以对任意数组进行排序，但待排序的元素必须实现`Comparable`这个泛型接口：

> ```java
> public interface Comparable<T> {
>     /**
>      * 返回-1: 当前实例比参数o小
>      * 返回0: 当前实例与参数o相等
>      * 返回1: 当前实例比参数o大
>      */
>     int compareTo(T o);
> }
> ```

> ```java
>     String[] ss = new String[] { "Orange", "Apple", "Pear" };
>     Arrays.sort(ss);
> 	// 上述没问题 因为String 类已经实现 comparable
>     Person[] ps = new Person[] {
>                 new Person("Bob", 61),
>                 new Person("Alice", 88),
>                 new Person("Lily", 75),
>     };
>     Arrays.sort(ps);
> 
> class Person implements Comparable<Person> {
>     String name;
>     int score;
>     Person(String name, int score) {
>         this.name = name;
>         this.score = score;
>     }
>     public int compareTo(Person other) {
>         return this.name.compareTo(other.name);
>     }
>     public String toString() {
>         return this.name + "," + this.score;
>     }
> }
> ```