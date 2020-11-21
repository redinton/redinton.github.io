[TOC]

#### Spring Framework

在其基础上，诞生Spring Boot, Spring Cloud, Spring Data, Spring Security

*  支持IoC和AOP的容器
* 支持JDBC和ORM的数据访问模块
* 支持声明式事务的模块
* 支持基于Servlet的MVC开发
* 支持基于Reactive的web开发



##### IoC 容器

* 容器是一种为某个特定组件的运行提供必要支持的一个软件环境
  * Tomcat是一个servlet容器，可以为Servlet的运行提供运行环境
  * Docker，提供了必要的linux环境，以便运行一个特定的linux进程
  * 容器提供了很多底层服务，例如servlet容器底层实现了TCP连接，解析http协议等服务
* IoC容器，可以管理所有轻量级的javaBean组件，提供的底层服务包括组件的生命周期管理、配置和组装服务、AOP支持，以及建立在AOP基础上的声明式事务服务

* IoC Inversion of Control 



* 创建组件
* 根据依赖关系组装组件
* 销毁时，按依赖顺序正确销毁



* IOC 又称为 依赖注入 (Dependency Injection)
  * 将组件的创建 + 配置与组件的使用相分离，并且由IoC容器负责管理组件的生命周期