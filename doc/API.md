# MTPush Hbuilder API

## Reference method
```javascript
var mtpushModule = uni.requireNativePlugin("EL-MTPush");
```

## Set debug mode

### API - setLoggerEnable(Boolean)
Set debug mode, the default is off

#### Parameter Description
- true - on，false - off

#### Example

```javascript
mtpushModule.setLoggerEnable(true);
```

## Set SiteName

### API - setSiteName(String)
Set the data center before the initialization function (initPushService).

#### Parameter Description
-  The name of the data center can be left unset. If not set, the default is the Singapore data center.
-  android -  If this interface setting is called, the (MTPUSH_SITENAME_ANDROID) configuration in package.json will not be used.

#### Example

```javascript
mtpushModule.setSiteName("Singapore");
```

##Get RegistrationID

### API - getRegistrationID(CALLBACK)
Call this API to get the RegistrationID.
Only when the registration is successful, the Engagelab server returns the corresponding value, otherwise it returns an empty string.

#### Parameter Description
- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|code|number|code 0 - success， 1011 - when use iOS simulator will report this error|
|registerID|string|registrationID|


#### Example

```javascript
mtpushModule.getRegistrationID(result=>{
					let registerID = result.registerID
				})	
```

## Open the notification settings page

### API - openSettingsForNotification(CALLBACK) 
Open the notification settings page

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|code|number|0 - success 1 - failure|


#### Example
```javascript
mtpushModule.openSettingsForNotification((result)=>{
		let code = result.code
})
```

## initialization method

### API - initPushService()

initialization SDK
iOS Note: If the MTPUSH_DEFAULTINITJPUSH_IOS value is configured as "true" in mainfest.json, MTPush will be initialized by default inside the plugin, and users do not need to call this initialization method.

#### Example
```javascript
mtpushModule.initPushService()
```


## Listen for connection status callbacks

### API - addConnectEventListener(CALLBACK)

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|connectEnable|boolean|true - connected, false - not connected|

#### Example
```javascript
mtpushModule.addConnectEventListener(result=>{
				let connectEnable = result.connectEnable
			})
```



## Listen for notification event callbacks

###  API - addNotificationListener(CALLBACK)
Distinguish whether the notification is received or clicked through the notificationEventType field of CALLBACK

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the notification message|
|title|string|Corresponds to the "Notification Title" field on the Portal push notification interface|
|content|string|Corresponds to the "Notification Content" field on the Portal push notification interface|
|badge|string|Corresponds to the "badge" field in the optional settings on the Portal push notification interface (ios only)|
|ring|string|The "sound" field in the optional settings on the push notification interface (ios only)|
|extras|dictionary|Corresponds to the additional fields in the "Optional Settings" on the Portal push message interface.|
|iOS|dictionary|Corresponds to the notification content returned by the native. If you need more fields, please check the content of this field.|
|android|dictionary|Corresponds to the notification content returned by the native. If you need more fields, please check the content of this field.|
|notificationEventType|string| `notificationArrived` or `notificationOpened`|

#### Example
```javascript
mtpushModule.addNotificationListener(result=>{
				let notificationEventType = result.notificationEventType
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
			})
```

## Listen to custom message event callbacks

###  API - addCustomMessageListener(CALLBACK)
Listen to custom message event callbacks

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the notification message|
|content|string|Corresponds to the "Notification Content" field on the Portal push notification interface|
|extras|dictionary|Corresponds to the additional fields in the "Optional Settings" on the Portal push message interface.|

#### Example
```javascript
mtpushModule.addCustomMessageListener(result=>{
				let messageID = result.messageID
				let content = result.content
				let extras = result.extras
			})
```

## Tag alias event callback

### API - addTagAliasListener(CALLBACK)

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|code|number|status code 0 - Success|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|tags|StringArray|The result returned by tagOperation|
|tag|string|Will be returned when performing queryTag operation|
|tagEnable|boolean|Will be returned when performing queryTag operation|
|alias|string|The result returned by aliasOperation|

#### Example

```javascript
mtpushModule.addTagAliasListener(result=>{
					let code = result.code
					let sequence = result.sequence
					let tags = result.tags
					let tag = result.tag
					let tagEnable = result.tagEnable
					let alias = result.alias
				})
```

## In App Meassage Listener

### API - addInMessageListener(CALLBACK)

#### Parameter Description

- CALLBACK

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|messageID|string|An ID that uniquely identifies the inapp message|
|title|string|Corresponds to the "Title" field on the Portal inapp message interface|
|content|string|Corresponds to the "Content" field on the Portal inapp message interface|
|target|string|target show page|
|click|string|the link to jump when click the inapp message|
|extras|dictionary|Corresponds to the additional fields in the "Optional Settings" on the inapp message message interface.|
|eventType|string|"show" or "click"|

#### 示例

```javascript
mtpushModule.addInMessageListener(result=>{
					let messageID = result.messageID
					let title = result.title
					let content = result.content
					let target = result.target
					let click = result.click
					let extras = result.extras
					let eventType = result.eventType
				})
```


## AddTag

### API - addTags(Object)
This interface is for adding operations, not overwriting operations

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|tags|StringArray|array of string type|

#### Example
```javascript
mtpushModule.addTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```

## updateTags

### API - updateTags(Object)
What needs to be understood is that this interface is overwriting operation, not incremental operation. That is, new calls will overwrite previous settings.

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|tags|StringArray|array of string type|

#### Example
```javascript
mtpushModule.updateTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```


## deleteTags

### API - deleteTags(Object)
Delete specified label

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|tags|StringArray|array of string type|

#### Example
```javascript
mtpushModule.deleteTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```


## cleanTags

### API - cleanTags(Object)
clean all tags

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|

#### Example
```javascript
mtpushModule.cleanTags({
					'sequence': 1
				})
```


## Query the status of binding the specified tag to the current user

### API - queryTag(Object)
Query the status of binding the specified tag to the current user

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|tag|string|Tags to be queried|


#### Example
```javascript
mtpushModule.queryTag({
					'tag':'beauty',
					'sequence': 1
				})
```


## getAllTags

### API - getAllTags(Object)
Query all tags

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|


#### Example
```javascript
mtpushModule.getAllTags({
					'sequence': 1
				})
```


## setAlias

### API - setAlias(Object)
Sets a valid alias for each call, overwriting previous settings.

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|
|alias|string|Valid aliases consist of: letters (case sensitive), numbers, underscores, Chinese characters, special characters @!#$&\*+=.\||

#### Example
```javascript
mtpushModule.setAlias({
                'alias' : 'coder',
					'sequence': 1
				})
```

## deleteAlias

### API - deleteAlias(Object)

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|


#### Example
```javascript
mtpushModule.deleteAlias({
					'sequence': 1
				})
```


## queryAlias

### API - queryAlias(Object)

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|sequence|number|The sequence number passed in during the request will be returned unchanged during the callback.|


#### Example
```javascript
mtpushModule.queryAlias({
					'sequence': 1
				})
```


## Set Badge

### API - setBadge(number)

This interface is used to cooperate with the server-side badge function provided by Engagaelab.
iOS:The problem this function solves is that when the server pushes APNs, it does not know what the client's original index is, and it is not reasonable to specify a fixed number.

 - Use this API to set the actual badge of the current client (the current user) to the server and save it;
 - When calling the server-side API to send APNs (usually this call is for a large number of users in batches),
   Use the semantics of "+1" to express the need to bring a new badge value when sending notifications based on the target user's actual badge value (saved) +1;

Android:Only supports Huawei
#### Example
```javascript
mtpushModule.setBadge(10)
```

## Set Enable Reset On Device Change

### API - setEnableResetOnDeviceChange(Boolean)

Enable or disable the function of resetting RegistrationID when device changes. If enabled, when a device change is detected (only when the device model changes), the registration information will be automatically cleared and re-registered.

#### Parameter Description
- Boolean: true - enable, false - disable, default is false

#### Call Instructions
Please call before the initialization interface. Default is disabled.

#### Example
```javascript
// Enable device migration function
mtpushModule.setEnableResetOnDeviceChange(true);

// Disable device migration function (default state)
mtpushModule.setEnableResetOnDeviceChange(false);
```


## error code

refer to [EngageLab](https://www.engagelab.com/)

