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








