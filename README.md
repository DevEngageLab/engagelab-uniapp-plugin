# mtpush-hbuilder-plugin

[EngageLab AppPush](https://www.engagelab.com/) 官方支持的 Hbuilder 插件（Android & iOS）。是基于 HBuilder 提供的 [uni-app 原生插件扩展](https://nativesupport.dcloud.net.cn/NativePlugin/README) 进而开发出的推送插件。

支持 iOS 和 Android 推送，同时适配各大厂商推送。

## uniapp插件市场地址
[EngageLab推送官方SDK](https://ext.dcloud.net.cn/plugin?id=10093)

## 接入
- 1.将 nativeplugins/EL-MTPush 导入项目对应位置。
- 2.项目 manifest.json 中接入 EL-MTPush 插件，并配置插件配置。
- 3.在项目中引用插件
```
const jv = uni.requireNativePlugin('EL-MTPush');
```


## DEMO 体验
按照以下步骤快速体验 MTPush_Hbuilder_demo：
- 1.在[EngageLab portal](https://www.engagelab.com/console/app-push)注册应用并开通推送功能。
- 2.在项目 manifest.json 中配置您的推送信息
- 3.HbuilderX 中制作打包自定义基座，包名，签名，bundleID 需要与对应 appkey 配置的应用信息保持一致
- 4.HbuilderX 使用自定义基座运行即可

### 1.2 配置插件

**HBuilderX 3.6.2 及之后版本，请打开mainfest配置文件，选择 App模块配置，勾选 Push 模块。**

**注意：不要勾选uniPush！**

打开 manifest.xml，选中App原生插件配置，选择本地插件，导入 EL-MTPush

然后配置各个属性，注意在HBuilderX中可能会出现乱序现象，请仔细认真填写

| 属性               | 描述                                            | 示例                               |
| :----------------- | ----------------------------------------------- | ---------------------------------- |
| MTPUSH_APPKEY_ANDROID | engagelab appkey (必填) | EngageLab portal配置应用信息时分配的AppKey  |
| MTPUSH_CHANNEL_ANDROID | engagelab channel (选填) | 用于统计分发渠道，不需要可填默认值developer-default |
| MTPUSH_PROCESS_ANDROID | Engagelabsdk work thread (必填) | Engagelab process，Engagelabsdk工作所在的进程，请填写 :remote  |
|MTPUSH_SITENAME_ANDROID | android 数据中心的名称（选填）| 您在ipotal设置的数据中心的名称，不填默认新加坡数据中心 |
| MTPUSH_OPPO_APPKEY   | android oppo appkey（选填）                                  | OP-12345678 |
| MTPUSH_OPPO_APPID   | android oppo appid（选填）                                    | OP-12345678 |
| MTPUSH_OPPO_APPSECRET   | android oppo appSecret（选填）                            | OP-12345678 |
| MTPUSH_VIVO_APPKEY   | android vivo appkey（选填）                                  | 12345678 |
| MTPUSH_VIVO_APPID   | android vivo appId（选填）                                    | 12345678 |
| MTPUSH_HONOR_APPID   | android honor appId（选填）                                    | 12345678 |
| MTPUSH_MEIZU_APPKEY   | android meizu appkey（选填）                                | MZ-12345678 |
| MTPUSH_MEIZU_APPID   | android meizu appId（选填）                                  | MZ-12345678 |
| MTPUSH_XIAOMI_GLOBAL_APPKEY   | android xiaomi global appKey（选填）                | MI-12345678 |
| MTPUSH_XIAOMI_GLOBAL_APPID   | android xiaomi global appId（选填）                  | MI-12345678 |
| MTPUSH_HUAWEI_APPID   | android huawei appId（选填）                                | appid=12345678 |
| MTPUSH_GOOGLE_API_KEY  | G-拼接google-services.json下的current_key（选填）          | G-12345678 |
| MTPUSH_GOOGLE_APP_ID  | G-拼接google-services.json下的mobilesdk_app_id（选填）      | G-12345678 |
| MTPUSH_GOOGLE_PROJECT_ID  | G-拼接google-services.json下的project_id（选填）        | G-12345678 |
| MTPUSH_GOOGLE_PROJECT_NUMBER  | G-拼接google-services.json下的project_number（选填）| G-12345678 |
| MTPUSH_GOOGLE_STORAGE_BUCKET  | G-拼接google-services.json下的storage_bucket（选填）| G-12345678 |
|MTPUSH_APPKEY_IOS| engagelab appkey (必填)| EngageLab portal配置应用信息时分配的AppKey |
|MTPUSH_CHANNEL_IOS| engagelab channel (选填) |用于统计分发渠道，不需要可填默认值developer-default|
|MTPush_ISPRODUCTION_IOS|iOS 是否是生产环境（选填）|是填true,不是填false或者不填|
|MTPush_ADVERTISINGID_IOS|iOS 广告标识符（IDFA）（选填）| 如果不需要使用IDFA，可不填|
|MTPUSH_SITENAME_IOS| iOS 数据中心的名称（选填）| 您在ipotal设置的数据中心的名称，不填默认新加坡数据中心 |
|MTPush_DEFAULTINITPUSH_IOS| iOS 是否默认初始化（选填）|是填true，不是填false或者不填|


#### Android 厂商配置说明
插件支持 OPPO VIVO 魅族 小米 华为 FCM 荣耀七大厂商推送接入，如需接入请对应配置上述厂商信息。

- [厂商通道参数申请指南](https://jiguang-docs.yuque.com/staff-mg3p4r/vc4ysl/ca9ssa1c4izt4b5u?singleDoc#)

## API
- [公用 API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/API.md)
- [Android 独有API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/ANDROID.md)
- [iOS 独有API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/IOS.md)

## 参考资料

[官方文档](https://www.engagelab.com/push)

## Support
- 集成前请先尝试 [demo 工程](https://github.com/DevEngageLab/engagelab-uniapp-plugin/tree/main/MTPush_Hbuilder_Demo)跑通
- 出现问题请先打开 debug 模式，拿到前端和原生日志

## Licensemtpush

MIT © [EngageLab](/license)
