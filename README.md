ASIHTTPRequest-Demo
===================

ASIHTTPRequest的一个完整实现demo


view 项目中的各种viewcontroller

common 共通类,各种基类 (APIClient网络请求单例) (BaseModel 实体的父类 继承Jastor 可以直接把字典映射成对象) (BaseViewController 本项目所有ViewController的父类) 

Util 项目工具类 用于写一些常用的类方法

model 实体

vendor 各种第三方组件  (ASIHTTPRequest 网络请求框架)(Jastor 字典映射成对象组件)(category 各种实用扩展)

Constant.h 项目中用到的各种宏定义 已经包含到了**Prefix.pch文件中

server.php 服务器端与afnetworking交互的demo
