

[TOC]



### 基本语法

#### 几个命令

*  v-bind
  * v-bind:title="messsage"  有时候可以省略为 :title="message"
  * 作用是可以把 前端网页上这个**元素节点的title特性和vue实例的message属性**保持一致
    * 为了动态绑定数据，等号后面可以写变量
    * 不使用冒号，等号后面就可以写字符串等原始类型数据。这时就无法进行动态绑定数据了。
* v-if 
  * //  <p v-if="seen">现在你看到我了</p>
* v-for
  * // <li v-for="todo in todos">    
  * //   {{ todo.text }}  
  *  // </li>

* v-on
  * **添加一个事件监听器**，通过它调用在 Vue 实例中定义的方法
  * // </button v-on:click="reverseMessage">button</button>

* v-model
  * 实现表单输入和应用状态之间的双向绑定
    * 所谓的应用状态就是在Vue实例中定义的属性
    * // <input v-model="message"> 
      * message 就是Vue实例中定义的属性



#### 生命周期

* 每个 Vue 实例在被创建时都要经过一系列的初始化过程——例如，需要**设置数据监听、编译模板、将实例挂载到 DOM 并在数据变化时更新 DOM** 等, 同时在这个过程中也会运行一些叫做**生命周期钩子**的函数，这给了用户在不同阶段添加自己的代码的机会。
  * [`created`](https://cn.vuejs.org/v2/api/#created) 钩子可以用来在一个实例**被创建之后执行代**码
  * 在实例生命周期的不同阶段被调用，如 [`mounted`](https://cn.vuejs.org/v2/api/#mounted)、[`updated`](https://cn.vuejs.org/v2/api/#updated) 和 [`destroyed`](https://cn.vuejs.org/v2/api/#destroyed)。生命周期钩子的 `this` 上下文指向调用它的 Vue 实例。





#### 模板语法

* 数据的绑定通常通过 {{  }}
* Mustache 语法不能作用在 HTML attribute 上，遇到这种情况应该使用 [`v-bind` 指令](https://cn.vuejs.org/v2/api/#v-bind)：
  * // <div v-bind:id="dynamicId"></div>
  * 对于布尔 attribute (它们只要存在就意味着值为 `true`)，`v-bind` 工作起来略有不同，在这个例子中：
    * // <button v-bind:disabled="isButtonDisabled">Button</button>



#### 指令

* 指令 (Directives) 是带有 `v-` 前缀的特殊 attribute。



#### 参数

* 一些指令能够接收一个“参数”，在指令名称之后以冒号表示。例如，`v-bind` 指令可以用于响应式地更新 HTML attribute：



#### 特殊缩写

* v-bind

  ```html
  <!-- 完整语法 -->
  <a v-bind:href="url">...</a>
  
  <!-- 缩写 -->
  <a :href="url">...</a>
  ```

* v-on

  ```html
  <!-- 完整语法 -->
  <a v-on:click="doSomething">...</a>
  
  <!-- 缩写 -->
  <a @click="doSomething">...</a>
  ```

  