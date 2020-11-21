[TOC]





#### Java概念及语法



* Java入口程序规定的方法必须是静态方法，方法名必须为`main`，括号内的参数必须是String数组。
* 方法名也有命名规则，命名和`class`一样，但是首字母小写
* 类名要求：
  - 类名必须以英文字母开头，后接字母，数字和下划线的组合
  - 习惯以大写字母开头



#### 基本数据类型

- 整数类型：byte，short，int，long
- 浮点数类型：float，double
  - 浮点数存在运算误差，所以比较两个浮点数是否相等常常会出现错误的结果。正确的比较方法是判断两个浮点数之差的绝对值是否小于一个很小的数
- 字符类型：char
- 布尔类型：boolean

基本数据类型是CPU可以直接进行运算的类型

#### 字符类型

* 字符类型`char`是基本类型，字符串类型`String`是引用类型
* 基本类型的变量是“持有”某个数值，引用类型的变量是“指向”某个对象
* 引用类型的变量可以是空值`null`；
* 要区分空值`null`和空字符串`""`

字符串的不可变是指字符串内容不可变。



* 定义变量的时候，如果加上`final`修饰符，这个变量就变成了**常量**
  * 常量在定义时进行初始化后就不可再次赋值，再次赋值会导致编译错误

#### var关键字

* 有些时候，类型的名字太长，写起来比较麻烦, 如果想省略变量类型，可以使用`var`关键字

  * ```java
    StringBuilder sb = new StringBuilder();
    var sb = new StringBuilder();
    ```



#### 数组类型

Java的数组有几个特点：

- 数组所有元素初始化为默认值，整型都是`0`，浮点型是`0.0`，布尔型是`false`；
- 数组一旦创建后，大小就不可改变。
- 可以修改数组中的某一个元素，使用赋值语句
- 可以用`数组变量.length`获取数组大小
- 数组元素可以是值类型（如int）或引用类型（如String），但数组本身是引用类型；



#### 输入和输出

* System.out.println() -> print line 输出并换行

* System.out.print() -> 输出后不换行

* 格式化输出
  * printf( ) 通过使用占位符`%?`
  * System.out.printf("%.2f\n", d);



#### 方法

##### 可变参数

```java
class Group {
    private String[] names;

    public void setNames(String... names) {
        this.names = names;
    }
}
```

可变参数相当于数组类型

```
Group g = new Group();
g.setNames("Xiao Ming", "Xiao Hong", "Xiao Jun"); // 传入3个String
g.setNames("Xiao Ming", "Xiao Hong"); // 传入2个String
```

完全可以把可变参数改写为`String[]`类型：

```java
class Group {
    private String[] names;

    public void setNames(String[] names) {
        this.names = names;
    }
}
```



* 引用类型参数的传递，调用方的变量，和接收方的参数变量，指向的是同一个对象。双方任意一方对这个对象的修改，都会影响对方（因为指向同一个对象嘛）。