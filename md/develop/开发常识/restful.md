[TOC]



RESTFUL 是一种架构方式的约束。 针对

* api接口规范
* 命名规则
* 返回值，授权验证

REST: Representational State Transfer 

* 每个URI( uniform resource identifier)代表一种资源
* 客户端通过 http (get,post,put,delete)

#### 六大原则

##### C-S架构

数据存储在Server，Client端只管使用

##### Stateless

http请求本身无状态，client每一次请求带有充分的信息能让server识别

##### 统一的接口

##### 一致的数据格式

要么XML，要么JSON，或直接返回状态码



##### RESTful

1. 加入版本

   ```bash
   https://example.com/api/v1/
   ```

2. 参数命名规范

   query param 用驼峰或者下划线

   ```
   https://example.com/api/users/today_login 获取今天登陆的用户 
   https://example.com/api/users/today_login&sort=login_desc 获取今天登陆的用户、登陆时间降序排列
   ```

3. URL命名规范

   在RESTful架构中，每个url代表一种资源，所以url不能有动词，只能名词，名词使用复数实现者应使用相应的Http动词GET、POST、PUT、PATCH、DELETE、HEAD来操作这些资源即可

   not good

   ```
   https://example.com/api/getallUsers GET 获取所有用户 
   https://example.com/api/getuser/1 GET 获取标识为1用户信息 
   https://example.com/api/user/delete/1 GET/POST 删除标识为1用户信息 
   https://example.com/api/updateUser/1 POST 更新标识为1用户信息 
   https://example.com/api/User/add POST 添加新的用户
   ```

   good

   ```
   https://example.com/api/users GET 获取所有用户信息 
   https://example.com/api/users/1 GET 获取标识为1用户信息 
   https://example.com/api/users/1 DELETE 删除标识为1用户信息 
   https://example.com/api/users/1 Patch 更新标识为1用户部分信息,包含在body中 
   https://example.com/api/users POST 添加新的用户
   ```

   

