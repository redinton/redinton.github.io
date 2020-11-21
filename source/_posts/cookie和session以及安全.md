



[TOC]



#### cookie

一个 cookie 形似 name = value,  存储在浏览器, 但也可以设置多个，因此cookie 是 一组 键值对儿

一个session 理解为一个数据结构，多数情况是映射， 存储在**服务器**上

cookie字段存在HTTP header中，量一大就占带宽。

cookie可以存储一个sessionID=xxx， 仅传这个cookie给server，server用这个找到对应的session， 有效解决用户追踪问题。



#### session

实现 -- 抽离成 Manager , Provider,  Session 三个类

* Manager 
  * session管理，存储配置信息，session存活时间，cookie名字等等
  * 所有session存在Manager内部的一个provider中
  * Manager 把sid(sessionID) 传给 Provider

* Provider
  * 最常见就是一个散列表， sid 对应 session
* Session
  * 存储用户的具体信息

之所以抽象出Manager,Provider,Session  三个类，涉及到设计层面

* Session
  * 虽然session就是键值对，但不直接用hash，因为Session结构不止存储一个hash，还可以存辅助数据，如sid，访问次数，过期时间， 方便实现 LRU， LFU
  * session 也可以有不同的存储方式，若用language内置的hash，则session数据存在内存里，数据量大，容易程序crash。 所以可以存入 redis， mysql
  * Session 提供一些抽象接口
    * set ( key val)
    * get ( key )
    * delete ( key )

* Provider
  * 由于时不时要删session, 除了设置存活时间，还有些LRU缓存淘汰
  * 因此provider 内部要使用 哈希链表



### CSRF

简述: 所谓跨域请求仿造就是，比如当用户登录网上银行后，cookie里会存放用于这个网站的credentials，此时如果用户点击了某个第三方恶意网站，里面的脚本就也是往这个网上银行网站发请求，而这个请求会带上用户的cookie，因此就可以模拟用户了。 注意：**攻击者并不能拿到cookie里的内容，只是可以把cookie发送出去**。**攻击者也不可以修改header的内容**。

预防措施

* 用户在登录某网站期间，用完后及时登出

另一个场景：

比如博客删除的接口用的是GET请求，那么攻击者只要在其恶意网站的脚本中模拟GET请求即可。

原网站 `<a href='/delete?id=3'>刪除</a>`

攻击者只要在钓鱼网站上写入 `<a href='https://small-min.blog.com/delete?id=3'>開始測驗</a>`, **由于浏览器的运行机制，会一并把samll-min.blog.com的cookie也带**上。

因为浏览器的机制，只要发送request给某个网域，就会把关联的cookie一起带上去，倘若使用者处于登入状态，那么request中就会包含他的session id。

如果把删除功能改成post请求，就不能通过`<a>` 或者 `<img>` 来攻击(因为这些发GET请求)，但其实可以通过`<form>`...

因此建议还是遵守RESTful的规范，删除就用delete

#### Server的防御

* 检查refer
  * request的header有个refer，代表这个request从哪里来，可用于判断是否是合法的domain
    * 但有些浏览器可能不会带refer
    * 有些使用者可能关闭自动带refer
    * 判断是否是合法domain的程序必须没bug
* 加上验证码 image 或者 sms
  * 由于攻击者无法知道image 或者 sms，所以可以预防csrf

* 加csrf token

  * 放着csrf攻击，核心在于确保有些信息**只有使用者**知道。

    ```html
    <form action="https://small-min.blog.com/delete" method="POST">
      <input type="hidden" name="id" value="3"/>
      <input type="hidden" name="csrftoken" value="fj1iro2jro12ijoi1"/>
      <input type="submit" value="刪除文章"/>
    </form>
    ```

    csrftoken由server随机产生，并存在server的session中，点击submit后，server对比表单中的csrftoken和session里的是否一致。 因为攻击者不知道csrftoken的值

    但是！

    * 如果server支持cross origin的request，那么攻击者就可以在页面发起一个request顺利拿到csrf token，前提是server接受这个domain的request
    * 一旦是分布式以后，对应的session只存储在某一台server中，不利于扩展。 其他server是不知道session中的这个csrftoken的

* double submit cookie

  * 此法不需要server端存储状态
  * server产生一组随机的token加在form中，但不用写到session里，而是同时也让client side设定一个csrftoken的cookie，值也是同一组token
  * csrf的攻击发出的request与本人发出的request区别在于前者来自不同domain。此时，攻击者想要攻击，他可以在form里写一个csrf token，但由于浏览器限制，他**不能在他的domain设定small-min-blog.com的cookie** (攻击者取不到cookie的内容)，因此他的request的cookie中没有csrftoken
  * 缺点：倘若攻击者掌握任何一个subdomain，就可以更改cookie了
  * 此外，也可以在client端生成这个token， 因此该理念核心在于 攻击者无法读写目标网站的cookie



[讓我們來談談 CSRF](https://blog.techbridge.cc/2017/02/25/csrf-introduction/)

[前端安全系列（二）：如何防止CSRF攻击？](https://tech.meituan.com/2018/10/11/fe-security-csrf.html)



#### Django CSRF

django.middleware.csrf.CsrfViewMiddleware

* CSRF_USE_SESSIONS

  * True的情况 , csrf token存在server端的session里，与每次提交的表单里的csrf_token对比

  * False的情况，放在cookie里，每次只要验证提交上来的cookie里的token和表单里的csrf_token是否一致

* 局部
  * @csrf_protect，为当前函数强制设置防跨站请求伪造功能，即便settings中没有设置全局中间件。
  * @csrf_exempt，取消当前函数防跨站请求伪造功能，即便settings中设置了全局中间件



### XSS

xss (cross site script)

xss 攻击是页面被注入恶意代码，利用恶意脚本，攻击者可以获取用户的敏感信息如cookie，SessionID



[[前端安全系列（一）：如何防止XSS攻击？](https://tech.meituan.com/2018/09/27/fe-security.html)](https://tech.meituan.com/2018/09/27/fe-security.html)