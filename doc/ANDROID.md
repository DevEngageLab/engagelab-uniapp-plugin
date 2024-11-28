# MTPush Hbuilder API ONLY For Android

## Reference method
```javascript
var mtpushModule = uni.requireNativePlugin("EL-MTPush");
```

## Stop push service

### API - stopPush()
After calling this API, the MTPush push service is completely stopped. The specific performance is:
Can't receive push message.
Other API calls are invalid and cannot be restored through MTPushInterface.init. You need to call resumePush to restore.

#### Example
```javascript
mtpushModule.stopPush();
```

## Resume push service

### API - resumePush()
After calling this API, all functionality is fully functional again.

#### Example
```javascript
mtpushModule.resumePush();
```

## Set allowed push time API

### API - setPushTime(Object)
By default users are allowed to push at any time. That is, whenever something is pushed, the client will receive it and display it.

Developers can call this API to set the time when push is allowed.

If the message is not received within this time period, the SDK's processing is: the notification will be thrown away.

This is a purely client-side implementation, so it has something to do with whether the client time is accurate, time zone, etc.
And this interface is only valid for notifications, custom messages are not affected.

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|pushTimeDays|NumberArray|0 means Sunday, 1 means Monday, and so on. (7-day system, the allowed value range in the Set collection is 0 to 6)|
|pushTimeStartHour|number|The start time when push is allowed (24-hour clock: value range is 0 to 23)|
|pushTimeEndHour|number|End time for allowed pushes (24-hour clock: endHour ranges from 0 to 23)|

#### Example
```javascript
mtpushModule.setPushTime({
					'pushTimeDays':[0,1,2],
                    'pushTimeStartHour':0,
                    'pushTimeEndHour':23
				});    
```

## Set notification silent time API

### API - setSilenceTime(Object)
By default, when a user receives a push notification, the client may vibrate, ring, etc. However, users hope to be in "do not disturb" mode when sleeping, having meetings, etc., which is also the concept of silent period.

Developers can call this API to set the silent period. If a message is received within this time period: there will be no ringtone or vibration.

#### Parameter Description
- Object

|Parameter Name|Parameter Type|Parameter Description|
|:-----:|:----:|:-----:|
|silenceTimeStartHour|number|Start time of silent period - hour (24-hour clock, range: 0~23)|
|silenceTimeStartMinute|number|Start time of silent period - minutes (range: 0~59)|
|silenceTimeEndHour|number|End time of silent period - hour (24-hour clock, range: 0~23)|
|silenceTimeEndMinute|number|End time of silent period - minutes (range: 0~59)|

#### example
```javascript
mtpushModule.setSilenceTime({
					'silenceTimeStartHour':22,
                    'silenceTimeStartMinute':30,
                    'silenceTimeEndHour':8
                    'silenceTimeEndMinute':30
				});    
```

## Local notification API
### API - addLocalNotification()
This API can send a local notification.
#### example
```javascript
mtpushModule.addLocalNotification({
					"messageID": 123,
					"title": "hello title",
					"content": "hello content",
					"extras": {
						"extras1": "extras1",
						"extras2": "extras2"
					},
					"category": "androidcategory", //only android
					"priority": 1, //only android
				})  
```

## Clear notification API

### API - clearNotificationById()
This API can clear a specified notification.

#### example
```javascript
mtpushModule.clearNotificationById();
```

### API - clearAllNotifications()
This API can clear all notifications displayed by MTPush (excluding those displayed by non-MTPush SDK);

#### example
```javascript
mtpushModule.clearAllNotifications();
```


## Set country code

### API - setCountryCode()
This interface is used to debug the fcm channel. If you need to debug the fcm channel in China, you need to set setCountryCode and the parameter is "US".
This interface is only used for debugging in debug mode. Please do not use it in the production environment.

#### example
```javascript
mtpushModule.setCountryCode("US");
```

