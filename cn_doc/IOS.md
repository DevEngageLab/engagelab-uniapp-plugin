# MTPush Hbuilder API Only for iOS

## 获取通知的授权状态 
### API - requestNotificationAuthorization(CALLBACK)
获取通知的授权状态

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|status|number|0 - NotDetermined 1 - Denied 2 - Authorized 3 - Provisional (ios 12 及以上才有)|


#### 示例
```javascript
mtpushModule.requestNotificationAuthorization((result)=>{
		let status = result.status
})
```

## 本地通知事件回调

### API - addLocalNotificationListener(CALLBACK)

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的ID|
|title|string|对应“通知标题”字段|
|content|string|对应“通知内容”字段|
|extras|dictionary|对应“附加内容”字段|

#### 示例
```javascript
mtpushModule.addLocalNotificationListener(result=>{
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
				
			})
```

## 添加一个本地通知

### API - addLocalNotification(Object)
添加一个本地通知

### 参数说明

- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的ID|
|title|string|对应“通知标题”字段|
|content|string|对应“通知内容”字段|
|extras|dictionary|对应“附加内容”字段|

#### 示例
```javascript
mtpushModule.addLocalNotification({
					messageID:'123',
					title:'title',
					content:'content',
					extras:{
						name: 'Cindy',
						age: '16'
					}
				})
```

## 移除指定的本地通知

### API - removeLocalNotification(Object)
移除指定的本地通知

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的ID|

#### 示例
```javascript
mtpushModule.removeLocalNotification({
					messageID:'123'
				})
```

## 移除所有的本地通知

### API - clearLocalNotifications()
移除所有的本地通知

#### 示例
```javascript
mtpushModule.clearLocalNotifications()
```


### API - pageEnterTo(String)
应用内消息功能需要配置 pageEnterTo 和 pageLeave 接口
应用内消息 - 进入页面 ， 和 pageLeave接口配套使用

#### 参数说明

页面名称,可以自定义

#### 示例
```javascript
mtpushModule.pageEnterTo("MainPage")
```

### API - pageLeave(String)
应用内消息功能需要配置 pageEnterTo 和 pageLeave 接口
应用内消息 - 离开页面 ， 和 pageEnterTo接口配套使用

#### 参数说明

页面名称,可以自定义

#### 示例
```javascript
mtpushModule.pageLeave("MainPage")
```

## 增强提醒消息事件回调

###  API - addNotiInMessageListener(CALLBACK)
通过CALLBACK 的 notiInAppEventType 字段 区分 是 消息展示 还是 消息点击

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
|notiInAppEventType|string|分为 notInappShow 和 notInappClick 两种|

#### 示例
```javascript
mtpushModule.addNotificationListener(result=>{
				let notiInAppEventType = result.notiInAppEventType
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
			})
```







