





[TOC]





#### 计算属性

个人理解是要对 输入的数据(即data中的定义的一些属性) 做一些操作的时候。

对于任何复杂逻辑，你都应当使用**计算属性**。

```javascript
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
  }
})
```



#### 计算属性 VS  缓存

可以通过将同一个函数定义成方法，然后调用 达到同样的效果

* **计算属性是基于它们的响应式依赖进行缓存的**。只在相关响应式依赖发生改变时它们才会重新求值
  * 只要用到的属性还没有发生改变，计算属性会立即返回之前的计算结果



#### 计算属性 VS 侦听属性

Vue 提供了一种更通用的方式来观察和响应 Vue **实例上的数据变动**：**侦听属性**

```javascript
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})
```

上面代码是命令式且重复的。将它与计算属性的版本进行比较

```javascript
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar'
  },
  computed: {
    fullName: function () {
      return this.firstName + ' ' + this.lastName
    }
  }
})
```



#### 计算属性的setter

计算属性默认只有 getter ，不过在需要时你也可以提供一个 setter 

```javascript
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
```

现在再运行 `vm.fullName = 'John Doe'` 时，setter 会被调用，`vm.firstName` 和 `vm.lastName` 也会相应地被更新



#### 侦听器

当需要在**数据变化时执行异步**或**开销较大的操作**时，这个方式是最有用的