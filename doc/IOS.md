# MTPush Hbuilder API Only for iOS

## request Notification Authorization status
### API - requestNotificationAuthorization(CALLBACK)

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|status|number|0 - NotDetermined 1 - Denied 2 - Authorized 3 - Provisional (Only available for ios 12 and above)|


#### Example
```javascript
mtpushModule.requestNotificationAuthorization((result)=>{
		let status = result.status
})
```

## addLocalNotificationListener

### API - addLocalNotificationListener(CALLBACK)

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the notification message|
|title|string|Corresponds to the "Notification Title" field|
|content|string|Corresponding to the "Notification Content" field|
|extras|dictionary|Corresponds to the "extras" field|

#### Example
```javascript
mtpushModule.addLocalNotificationListener(result=>{
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
				
			})
```

## addLocalNotification

### API - addLocalNotification(Object)
add a local notification

### Parameter Description

- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the notification message|
|title|string|Corresponds to the "Notification Title" field|
|content|string|Corresponding to the "Notification Content" field|
|extras|dictionary|Corresponds to the "extras" field|

#### Example
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

## Remove specified local notification

### API - removeLocalNotification(Object)
Remove specified local notification

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the notification message|

#### Example
```javascript
mtpushModule.removeLocalNotification({
					messageID:'123'
				})
```

## clearLocalNotifications

### API - clearLocalNotifications()
clear all local notifications

#### Example
```javascript
mtpushModule.clearLocalNotifications()
```








