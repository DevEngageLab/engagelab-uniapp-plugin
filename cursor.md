
使用方法：修改需求里的内容，将需求和步骤内容作为指令让cursor进行执行。cursor只能完整部分操作，请关注下手动操作部分。和自测环节。


需求：
1. 更新iOS MTPush SDK 到 x.x.x 版本,  MTPush SDK 包的路径是：(xcframework包路径) 。
2. 更新Android MTPush SDK 到 x.x.x 版本, MTPush SDK 包的路径是： （jenkins包路径）。
3. 将原生iOS、Android SDK 新增的方法，封装在插件中。
   原生SDK新增方法一：
   iOS ：
   
   ```


   ```
   
   Android:
   
   ```


   ```
   
    统一封装为 方法名为 "" 的对外方法。
    

请按照以下步骤完成：

1. 找到需要升级的iOS MTPush SDK，替换/UniPlugin-MTPush-iOS/HBuilder-uniPluginDemo/UniPluginMTPush/UniPluginMTPush/mtpush-ios-x.x.x.xcframework 为需要更新的版本。
2. 找到需要升级的Android MTPush SDK， 将libs文件夹中的arr包(除了mt-sdk-ma-x.x.x.aar 和 ) 更新到 UniPlugin-MTPush-Android/uniplugin_mtpush/libs 中。
3. 找到需要升级的Android MTPush SDK， 将libs文件夹中的arr包(除了mt-sdk-ma-x.x.x.aar) 更新到 UniPlugin-MTPush-Android/app/libs 中。
4. 找到需要升级的Android MTPush SDK， 将libs文件夹中的arr包(除了mt-sdk-ma-x.x.x.aar) 更新到 MTPush_Hbuilder_Demo/nativeplugins/EL-MTPush/android 中。
5. 在插件中封装需求中需要封装的SDK方法，并在插件示例demo中提供示例调用代码，在doc 文件夹中找到相应的md文档 补充新增的插件方法。（如果需求中没有需要新增的方法，则跳过该步骤）
6. 在/MTPush_Hbuilder_Demo/nativeplugins/EL-MTPush/package.json中更新插件版本号，在现有版本号上 + 0.0.1
7. 在CHANGELOG.md 中 更新 该插件本次的变更内容。




---- 
上诉cursor只步骤只能完成部分操作，还需要以下手动操作部分。
手动步骤：
1、 iOS 编译出 UniPluginJPush.framework 包, 放到 MTPush_Hbuilder_Demo/nativeplugins/EL-MTPush/ios 中。
3、 android 也需打出 uniplugin_mtpush-release.aar 包，放到 MTPush_Hbuilder_Demo/nativeplugins/EL-MTPush/android 中。


