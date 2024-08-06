# mtpush-hbuilder-plugin

[EngageLab AppPush](https://www.engagelab.com/) is a officially supported Hbuilder plugin (Android & iOS). It is a push plugin developed based on the [uni-app native plugin extension](https://nativesupport.dcloud.net.cn/NativePlugin/README) provided by HBuilder.

It supports iOS and Android push,  and adapts to the push capabilities of various manufacturers.

## uniapp plugin market address
[EngageLab official SDK](https://ext.dcloud.net.cn/plugin?id=10093)

## Setup
- 1.Import nativeplugins/EL-MTPush into the corresponding location of the project.
- 2.Add the EL-MTPush plugin to the project manifest.json and configure the plugin configuration.
- 3.Reference the plugin in the project
```
const jv = uni.requireNativePlugin('EL-MTPush');
```


## DEMO experience
Follow these steps to quickly experience MTPush_Hbuilder_demo:
- 1.Register the application in [EngageLab portal](https://www.engagelab.com/console/app-push) and activate the push function.
- 2.Configure your push information in the project manifest.json
- 3.When making and packaging a custom debugging base in HbuilderX, the package name, signature, and bundleID need to be consistent with the application information configured in the corresponding appkey.
- 4.Just run it with a custom debugging base.

### 1.2 Configure plugin

**For BuilderX 3.6.2 and later versions, please open the mainfest configuration file, select App module configuration, and check the Push module.**

**Note: Do not check uniPush!**

Open manifest.xml, select App native plug-in configuration, select local plugin, and import EL-MTPush.

Then configure each attribute. Please note that there may be chaos in HBuilderX. Please fill it in carefully.

| Attributes               | Describtion                                       | Example示                              |
| :----------------- | ----------------------------------------------- | ---------------------------------- |
| MTPUSH_APPKEY_ANDROID | engagelab appkey (Required) | AppKey assigned when EngageLab portal configures application information  |
| MTPUSH_CHANNEL_ANDROID | engagelab channel (Optional) | Used for statistics distribution channels, no need to fill in the default value `developer-default` |
| MTPUSH_PROCESS_ANDROID | Engagelabsdk work thread (Required) | The process where Engagelabsdk works, please fill in `:remote` |
|~~MTPUSH_SITENAME_ANDROID~~ | ~~android Data center name（Optional）deleted in v1.1.1~~| ~~The name of the data center you set in ipotal. Leave the default `Singapore` data center blank.~~ |
| MTPUSH_OPPO_APPKEY   | android oppo appkey（Optional）                                  | OP-12345678 |
| MTPUSH_OPPO_APPID   | android oppo appid（Optional）                                    | OP-12345678 |
| MTPUSH_OPPO_APPSECRET   | android oppo appSecret（Optional）                            | OP-12345678 |
| MTPUSH_VIVO_APPKEY   | android vivo appkey（Optional）                                  | 12345678 |
| MTPUSH_VIVO_APPID   | android vivo appId（Optional）                                    | 12345678 |
| MTPUSH_HONOR_APPID   | android honor appId（Optional）                                    | 12345678 |
| MTPUSH_MEIZU_APPKEY   | android meizu appkey（Optional）                                | MZ-12345678 |
| MTPUSH_MEIZU_APPID   | android meizu appId（Optional）                                  | MZ-12345678 |
| ~~MTPUSH_XIAOMI_GLOBAL_APPKEY~~   | ~~android xiaomi global appKey（Optional）delleted in v1.1.1~~             | ~~MI-12345678~~ |
| ~~MTPUSH_XIAOMI_GLOBAL_APPID~~   | ~~android xiaomi global appId（Optional）delleted in v1.1.1~~                | ~~MI-12345678~~ |
| MTPUSH_XIAOMI_APPKEY  | android xiaomi appKey（Optional）              | MI-12345678 |
| MTPUSH_XIAOMI_APPID  | android xiaomi appId（Optional）                | MI-12345678 |
| MTPUSH_HUAWEI_APPID   | android huawei appId（Optional）                                | appid=12345678 |
| MTPUSH_GOOGLE_API_KEY  | G-splicing `current_key` under google-services.json（Optional）          | G-12345678 |
| MTPUSH_GOOGLE_APP_ID  | G-splicing `mobilesdk_app_id` under google-services.json（Optional）      | G-12345678 |
| MTPUSH_GOOGLE_PROJECT_ID  | G-splicing `project_id` under google-services.json（Optional）        | G-12345678 |
| MTPUSH_GOOGLE_PROJECT_NUMBER  | G-splicing `project_number` under google-services.json（Optional）| G-12345678 |
| MTPUSH_GOOGLE_STORAGE_BUCKET  | G-splicing `storage_bucket` under google-services.json（Optional）| G-12345678 |
|MTPUSH_APPKEY_IOS| engagelab appkey (Required)| AppKey assigned when EngageLab portal configures application information |
|MTPUSH_CHANNEL_IOS| engagelab channel (Optional) |Used for statistics distribution channels, no need to fill in the default value `developer-default`|
|MTPush_ISPRODUCTION_IOS|iOS - production environment or not（Optional）|For production environment, fill in true, otherwise fill in false|
|MTPush_ADVERTISINGID_IOS|iOS - advertising identifier（IDFA）（Optional）| If you do not need to use IDFA, you can leave it blank.|
|~~MTPUSH_SITENAME_IOS~~| ~~iOS Data center name（Optional）deleted in v1.1.1~~| ~~The name of the data center you set in ipotal. Leave the default `Singapore` data center blank.~~ |
|MTPush_DEFAULTINITPUSH_IOS| iOS - initialized by default（Optional）|If you want to initialize automatically, fill in True. If not, fill in false or leave it blank.|


#### Android Manufacturer configuration instructions
The plug-in supports push access from seven major manufacturers including OPPO VIVO, Meizu, Xiaomi, Huawei FCM and Honor. If you need access, please configure the above manufacturer information accordingly.


- [Manufacturer Channel Parameter Application Guide](https://jiguang-docs.yuque.com/staff-mg3p4r/vc4ysl/ca9ssa1c4izt4b5u?singleDoc#)

## API
- [Common API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/API.md)
- [Android unique API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/ANDROID.md)
- [iOS unique API](https://github.com/DevEngageLab/engagelab-uniapp-plugin/blob/main/doc/IOS.md)

## References

[Official documentation](https://www.engagelab.com/push)

## Support
- Please try [demo project](https://github.com/DevEngageLab/engagelab-uniapp-plugin/tree/main/MTPush_Hbuilder_Demo) before integrating
- If a problem occurs, please turn on the debug mode first and get the front-end and native logs.

## Licensemtpush

MIT © [EngageLab](/license)
