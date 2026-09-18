# MTPush Hbuilder API

## 引用方式
```javascript
var mtpushModule = uni.requireNativePlugin("EL-MTPush");
```

## 初始化推送

插件提供两种初始化方式，请根据 AppKey 的配置方式选择其中一种，不要同时调用。

### API - initPushService()

AppKey 等参数已经在插件配置中填写时使用。该接口按插件配置初始化推送。

```javascript
mtpushModule.initPushService();
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

## 使用初始化参数启动推送

### API - initPushServiceWithOptions(Object)

需要在运行时动态传入 AppKey 或其他初始化参数时使用。

- `appKey`：Android、iOS 必填。
- `channel`：仅 iOS 可选，未传时读取插件配置。
- `isProduction`：仅 iOS 可选，未传时读取插件配置。
- `advertisingId`：仅 iOS 可选，未传时读取插件配置。

Android 首次调用时配置 AppKey 并初始化推送，后续调用只更新 AppKey，不重复初始化。iOS 每次调用都会执行 SDK 的 `setupWithOption:appKey:...`。

#### 示例

```javascript
// Android
mtpushModule.initPushServiceWithOptions({
    appKey: "Android AppKey"
});

// iOS
mtpushModule.initPushServiceWithOptions({
    appKey: "iOS AppKey",
    channel: "developer-default",
    isProduction: false,
    advertisingId: ""
});
```

## 设置 SiteName 

### API - setSiteName(String)
设置数据中心, 在初始化函数（initPushService）之前设置。

#### 参数说明
-  数据中心的名称, 可不设置，不设置默认为新加坡数据中心
-  android 如果调用该接口设置，那就不会使用package.json中的（MTPUSH_SITENAME_ANDROID）配置。

#### 示例

```javascript
mtpushModule.setSiteName("Singapore");
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

## 通用命令结果回调（仅 Android）

### API - addCommandResultListener(CALLBACK)

监听通用命令执行结果。小米消息频道订阅结果通过该回调返回。

#### 参数说明

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|cmd|number|小米频道订阅回调固定为 `2012`|
|errorCode|number|小米整体结果码；`0` 表示弹窗正常展示并返回用户操作结果，不代表每个频道都订阅成功|
|msg|string|结果描述；当前订阅命令通常为空字符串|
|extra|dictionary|小米扩展字段，并包含 `subscribe_code`（与 `errorCode` 一致）和 `platform`（小米为 `1`）|

`errorCode`：`-100` 不支持、`-200` 鉴权失败、`-300` 应用不在前台或未亮屏、`-400` 正在处理其他订阅请求、`-500` 频控、`-600` 参数无效、`-700` 用户取消、`-800` 无通知权限、`-900` 未知异常、`-10000` 小米推送尚未完成注册、`-2147483648` 调用小米 SDK 异常。

当 `errorCode` 为 `0` 时，`extra.open_channel_result`（如果小米系统服务返回）为各频道结果的 JSON 字符串。单频道 `code`：`100` 创建成功、`-100` 创建失败、`-200` 用户拒绝、`-300` 已创建且开启、`-400` 已创建但关闭、`-500` 频道无效。

#### 示例

```javascript
mtpushModule.addCommandResultListener(result => {
  if (result.cmd === 2012) {
    console.log('订阅结果', result.errorCode, result.extra)
    if (result.errorCode === 0 && result.extra.open_channel_result) {
      console.log('各频道结果', JSON.parse(result.extra.open_channel_result))
    }
  }
})
```

## 标签别名事件回调

### API - addTagAliasListener(CALLBACK)

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|code|number|请求状态码 0 - 成功|
|sequence|number|请求时传入的序列号,会在回调时原样返回|
|tags|StringArray|执行tag数组操作时返回|
|tag|string|执行查询指定tag(queryTag)操作时会返回|
|tagEnable|boolean|执行查询指定tag(queryTag)操作时会返回是否可用|
|alias|string|对alias进行操作时返回|

#### 示例

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

## 应用内消息回调

### API - addInMessageListener(CALLBACK)

#### 参数说明

- CALLBACK

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|messageID|string|唯一标识通知消息的 ID|
|title|string|对应 Portal 应用内消息界面上的“标题”字段|
|content|string|对应 Portal 应用内消息界面上的“内容”字段|
|target|string|应用内消息的目标页面|
|click|string|应用内消息的点击链接|
|extras|dictionary|对应 Portal 应用内消息界面上的“可选设置”里的附加字段|
|eventType|string|分为show和click两种|

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


## 订阅小米消息频道（仅 Android）

### API - requestSubscribeChannel(Array)

请求订阅一个或多个小米消息频道。该能力目前仅支持小米通道，请先通过
`addCommandResultListener` 注册结果回调。
原生行为及限制参考 [EngageLab Android SDK requestSubscribeChannel](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/android-sdk/sdk-api-guide#requestsubscribechannel)。

#### 参数说明

- `channelIds`: 字符串数组，小米推送后台申请的订阅类频道 ID 列表。单次最多传入 3 个，超出部分由小米 SDK 丢弃

订阅弹窗 30 秒内最多请求一次；同一频道一个月内最多请求两次，达到上限时返回 `-500`。

#### 示例

```javascript
mtpushModule.requestSubscribeChannel([
  'channel_id_1',
  'channel_id_2'
])
```


## 新增标签

### API - addTags(Object)
这个接口是增加逻辑，而不是覆盖逻辑

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|
|tags|StringArray|string类型的数组|

#### 示例
```javascript
mtpushModule.addTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```

## 覆盖标签

### API - updateTags(Object)
需要理解的是，这个接口是覆盖逻辑，而不是增量逻辑。即新的调用会覆盖之前的设置

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|
|tags|StringArray|string类型的数组|

#### 示例
```javascript
mtpushModule.updateTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```


## 删除指定标签

### API - deleteTags(Object)
删除指定标签

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|
|tags|StringArray|string类型的数组|

#### 示例
```javascript
mtpushModule.deleteTags({
					'tags':['beauty','rich'],
					'sequence': 1
				})
```


## 清除所有标签

### API - cleanTags(Object)
清除所有标签

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|

#### 示例
```javascript
mtpushModule.cleanTags({
					'sequence': 1
				})
```


## 查询指定 tag 与当前用户绑定的状态

### API - queryTag(Object)
查询指定 tag 与当前用户绑定的状态

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|
|tag|string|需要查询的标签|


#### 示例
```javascript
mtpushModule.queryTag({
					'tag':'beauty',
					'sequence': 1
				})
```


## 查询所有标签

### API - getAllTags(Object)
查询所有标签

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|


#### 示例
```javascript
mtpushModule.getAllTags({
					'sequence': 1
				})
```


## 设置别名

### API - setAlias(Object)
每次调用设置有效的别名，覆盖之前的设置

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|
|alias|string|有效的别名组成：字母（区分大小写）、数字、下划线、汉字、特殊字符@!#$&\*+=.\||

#### 示例
```javascript
mtpushModule.setAlias({
                'alias' : 'coder',
					'sequence': 1
				})
```

## 删除别名

### API - deleteAlias(Object)
删除别名

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|


#### 示例
```javascript
mtpushModule.deleteAlias({
					'sequence': 1
				})
```


## 查询别名

### API - queryAlias(Object)
删除别名

#### 参数说明
- Object

|参数名称|参数类型|参数说明|
|:-----:|:----:|:-----:|
|sequence|number|请求时传入的序列号，会在回调时原样返回|


#### 示例
```javascript
mtpushModule.queryAlias({
					'sequence': 1
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

## 设置设备更换时是否重置RegistrationID

### API - setEnableResetOnDeviceChange(Boolean)

开启或者关闭设备更换时重置RegistrationID的功能。若开启时，当检测到设备发生变化时（只有当设备型号发生变化时），会自动清除注册信息，重新注册。

#### 参数说明
- Boolean: true - 启用，false - 禁用，默认为 false

#### 调用说明
请在初始化接口前调用。默认为关闭。

#### 示例
```javascript
// 启用设备迁移功能
mtpushModule.setEnableResetOnDeviceChange(true);

// 禁用设备迁移功能（默认状态）
mtpushModule.setEnableResetOnDeviceChange(false);
```

## 设置是否允许使用 UDP

### API - setEnableUdp(Boolean)

设置推送连接是否允许使用 UDP。传 `true` 允许使用 UDP，传 `false` 不允许使用 UDP。

#### 参数说明
- Boolean: true - 允许使用 UDP，false - 不允许使用 UDP

#### 调用说明
如需修改默认行为，请在初始化接口前调用。

#### 示例
```javascript
// 允许使用 UDP
mtpushModule.setEnableUdp(true);

// 不允许使用 UDP
mtpushModule.setEnableUdp(false);
```

## 设置数据采集控制（仅 Android）

### API - setCollectControl(Object)

在 SDK 初始化前设置数据采集控制（如是否采集 GAID）。**仅 Android。** 必须在 `initPushService()` 之前调用。

#### 参数说明
- Object（可选）：
  - `gaid` (Boolean)：是否采集 Google 广告 ID，设为 `false` 可不采集。
  - `aid` (Boolean)：是否采集 AndroidId，设为 `false` 可不采集。

#### 调用说明
请在 `initPushService()` 之前调用。不传参数或传空对象时，使用默认采集行为。

#### 示例
```javascript
// 不采集 GAID 和 AndroidId（如隐私合规场景）
mtpushModule.setCollectControl({ gaid: false, aid: false });

// 仅不采集 GAID
mtpushModule.setCollectControl({ gaid: false });

// 仅不采集 AndroidId
mtpushModule.setCollectControl({ aid: false });
```

## 错误码

请参考[EngageLab官网](https://www.engagelab.com/)
