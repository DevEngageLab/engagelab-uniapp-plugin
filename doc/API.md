# MTPush Hbuilder API

## 引用方式
```javascript
var mtpushModule = uni.requireNativePlugin("EL-MTPush");
```

## 设置 debug 模式

### API - setLoggerEnable(Boolean)
开启 debug 模式，默认是关闭

#### 参数说明
- true - 开启，false - 关闭

#### 示例

```javascript
mtpushModule.setLoggerEnable(true);
```


## 获取 RegistrationID

### API - getRegistrationID(CALLBACK)
调用此 API 来取得应用程序对应的 RegistrationID。
只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串

#### 参数说明
- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|code|number|状态码 0 - 成功， 1011 - iOS模拟器调用会报此错误|
|registerID|string|返回的 registrationID|


#### 示例

```javascript
mtpushModule.getRegistrationID(result=>{
					let registerID = result.registerID
				})	
```

## 打开通知设置页面 

### API - openSettingsForNotification(CALLBACK) 
跳转至系统设置页面

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|code|number|0 - 成功 1 - 失败|


#### 示例
```javascript
mtpushModule.openSettingsForNotification((result)=>{
		let code = result.code
})
```

## 初始化函数

### API - initPushService()

初始化SDK
iOS 说明:如果在mainfest.json里 将MTPUSH_DEFAULTINITJPUSH_IOS值配置为"true"，插件内部将默认初始化MTPush，用户则不需要调用该初始化方法。

#### 示例
```javascript
mtpushModule.initPushService()
```


## 连接状态回调

### API - addConnectEventListener(CALLBACK)

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|connectEnable|boolean|true - 已连接, false - 未连接|

#### 示例
```javascript
mtpushModule.addConnectEventListener(result=>{
				let connectEnable = result.connectEnable
			})
```



## 通知事件回调

###  API - addNotificationListener(CALLBACK)
通过CALLBACK 的 notificationEventType字段 区分 是 通知收到 还是 点击通知

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的 ID|
|title|string|对应 Portal 推送通知界面上的“通知标题”字段|
|content|string|对应 Portal 推送通知界面上的“通知内容”字段|
|badge|string|对应 Portal 推送通知界面上的可选设置里面的“badge”字段 (ios only)|
|ring|string|推送通知界面上的可选设置里面的“sound”字段 (ios only)|
|extras|dictionary|对应 Portal 推送消息界面上的“可选设置”里的附加字段|
|iOS|dictionary|对应原生返回的通知内容，如需要更多字段请查看该字段内容|
|android|dictionary|对应原生返回的通知内容，如需要更多字段请查看该字段内容|
|notificationEventType|string|分为notificationArrived和notificationOpened两种|

#### 示例
```javascript
mtpushModule.addNotificationListener(result=>{
				let notificationEventType = result.notificationEventType
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
			})
```

## 自定义消息事件回调

###  API - addCustomMessageListener(CALLBACK)
监听 Portal 发送的自定义消息

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的 ID|
|content|string|对应 Portal 推送通知界面上的“通知内容”字段|
|extras|dictionary|对应 Portal 推送消息界面上的“可选设置”里的附加字段|

#### 示例
```javascript
mtpushModule.addCustomMessageListener(result=>{
				let messageID = result.messageID
				let content = result.content
				let extras = result.extras
			})
```


## 设置 Badge

### API - setBadge(number)

本接口用于配合 JPush 提供的服务器端角标功能.
iOS:该功能解决的问题是, 服务器端推送 APNs 时, 并不知道客户端原来已经存在的角标是多少, 指定一个固定的数字不太合理.

 - 通过本 API 把当前客户端(当前这个用户的) 的实际 badge 设置到服务器端保存起来;
 - 调用服务器端 API 发 APNs 时(通常这个调用是批量针对大量用户),
   使用 "+1" 的语义, 来表达需要基于目标用户实际的 badge 值(保存的) +1 来下发通知时带上新的 badge 值;

Android:仅支持华为

#### 示例
```javascript
mtpushModule.setBadge(10)
```

## 设置手机号码

### API - setMobileNumber(Object)
设置手机号码后，可实现“推送不到短信到”的通知方式，提高推送达到率。

#### 参数说明

- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|mobileNumber|string|手机号码 会与用户信息一一对应。可为空，为空则清除号码。|
|sequence|number|请求时传入的序列号,会在回调时原样返回|


#### 示例
```javascript
mtpushModule.setMobileNumber({
					mobileNumber: '15889230000'
				})
```

## 设置手机号码回调

### API - addMobileNumberListener(CALLBACK)

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|code|number|状态码 0 - 成功|
|sequence|number|请求时传入的序列号,会在回调时原样返回|

#### 示例
```javascript
mtpushModule.addMobileNumberListener(result=>{
		let code = result.code
	})
```


## 错误码

请参考[EngageLab官网](https://www.engagelab.com/)

