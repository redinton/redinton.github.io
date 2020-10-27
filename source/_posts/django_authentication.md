---
title: django authentication
date: 2020-10-27 11:08:08
tags:
- django
toc: true
---

鉴权部分 (authentication) 

参考 [1](https://medium.com/@allwindicaprio/session-vs-token-based-authentication-b1f862dd7ed8)

在配置中 base.py / development.py

<!--more-->

```python
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.BasicAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    ]
}
```

默认状态下是 BasicAuthentication和SessionAuthentication只要满足一个就可以

##### BasicAuthentication

当未认证时，会返回

HTTP/1.1 401 Authorization Required **www-Authenticate**: Basic realm= "family"

Basic说明要Basic方式认证，realm = “family" 说明family中的内容是要权限的

用户输入 账号密码，Base64( 账号:密码) 加密后放到下面Basic后的字段

Authorization: Basic U2h1c2hlbmcwMDcldUZGMUFzczAwNw==

缺点

**不安全，http是裸奔状态** ， 一般结合https用BasicAuthen

 
##### TokenAuthentication

也叫Bearer authentication

```python
INSTALLED_APPS = [
    ...
    'rest_framework.authtoken'
]
```

token key should be included in the `Authorization` HTTP header.

```python
Authorization: Bearer <token>
Authorization: Token 9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b
```

用户首先输入账号密码到server端，server端验证后，返回一个token给用户，

用户把这个token存在本地的local storage，之后发请求的时候就从本地取出token，加到Authorization http header中



##### SessionAuthentication

![image-20200916233140486](django_authentication.assets/image-20200916233140486.png)

用户提交账号密码后，在服务端会有一个session，返回一个session_id,下次请求的时候直接在request中 cookie加入 session_id 。

可能存在一个**CORS** 问题。



##### JWT json web token

base64(Header)  + "." + base64(Payload) +"." + Signature

* header
  * alg:加密用的算法 HS256
  * typ: JWT
* Payload
  * 想要传递的信息 如 用户名
* Signature
  * HS256 (Base64(Header) + "." + Base64(Payload),   secretKey)
  * secretkey是密钥，由server保存

###### 服务器验证

收到token后，先decode出JWT三个部分，得到sign的算法和payload，然后结合**secretkey再次生成Signat**ure，与原来的Signature对比验证token是否有效，验证通过才会用payload数据