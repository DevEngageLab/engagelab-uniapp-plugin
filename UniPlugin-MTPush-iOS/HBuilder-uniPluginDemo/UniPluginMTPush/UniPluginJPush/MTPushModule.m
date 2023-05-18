//
//  MTPushModule.m
//  UniPluginMTPush
//
//  Created by huangshuni on 2021/1/12.
//

#import "MTPushModule.h"
#import "MTPushService.h"
#import "MTPushStore.h"
#import <UserNotifications/UserNotifications.h>


#define weakObj(obj) __weak typeof(obj) weak##obj = obj;


#define MOBILENUMBER      @"mobileNumber"
#define REGISTER_ID       @"registerID"
#define LATITUDE          @"latitude"
#define LONGITUDE         @"longitude"

#define TAGS             @"tags"
#define TAG              @"tag"
#define SEQUENCE         @"sequence"
#define ALIAS            @"alias"
#define TAG_ENABLE       @"tagEnable"
#define CODE             @"code"
#define MESSAGE_ID       @"messageID"
#define TITLE            @"title"
#define CONTENT          @"content"
#define EXTRAS           @"extras"



@interface MTPushModule () 

@end

@implementation MTPushModule

BOOL mtpush_debugMode = NO;

UNI_EXPORT_METHOD(@selector(setBadge:))
UNI_EXPORT_METHOD(@selector(addMobileNumberListener:))
UNI_EXPORT_METHOD(@selector(setMobileNumber:))
UNI_EXPORT_METHOD(@selector(setLoggerEnable:))
UNI_EXPORT_METHOD(@selector(getRegistrationID:))
UNI_EXPORT_METHOD(@selector(setTcpSSL:))

#pragma -

// 设置角标
- (void)setBadge:(NSInteger)badge {
    [self logger:@"setBadge with params" log:@(badge)];
    [MTPushService setBadge:badge];
}

- (void)addMobileNumberListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addMobileNumberListener" log:nil];
    [MTPushStore shared].addMobileNumberCallBack = callback;
}

// 设置手机号
- (void)setMobileNumber:(NSDictionary *)params {
    [self logger:@"setMobileNumber with params:" log:params];
    weakObj(self)
    NSString *mobileNumber = params[MOBILENUMBER];
    [MTPushService setMobileNumber:mobileNumber completion:^(NSError *error) {
        
        NSDictionary *result = [weakself convertResultWithCode:(error?error.code:0) content:nil];
        if ([MTPushStore shared].addMobileNumberCallBack) {
            [MTPushStore shared].addMobileNumberCallBack(result, YES);
        }
    }];
}


//设置调试模式，默认关闭状态
- (void)setLoggerEnable:(BOOL)enable {
    [self logger:@"setLoggerEnable:" log:(enable?@"true":@"false")];
    mtpush_debugMode = enable;
    if (enable) {
        [MTPushService setDebugMode];
    }else {
        [MTPushService setLogOFF];
    }
}

// 获取注册id
- (void)getRegistrationID:(UniModuleKeepAliveCallback)callback {
    [self logger:@"getRegistrationID" log:nil];
    [MTPushService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSDictionary *content = @{
            REGISTER_ID: registrationID ? registrationID : @"",
        };
        NSDictionary *result = [self convertResultWithCode:resCode content:content];
        callback(result, NO);
    }];
}

// 设置是否tcp加密
- (void)setTcpSSL:(BOOL)isSSL {
    [self logger:@"setTcpSSL" log:(isSSL?@"true":@"false")];
    [MTPushService setTcpSSL:isSSL];
}


UNI_EXPORT_METHOD(@selector(requestNotificationAuthorization:))
UNI_EXPORT_METHOD(@selector(openSettingsForNotification:))

#pragma - 权限
//请求通知权限
- (void)requestNotificationAuthorization:(UniModuleKeepAliveCallback)callback {
    [self logger:@"requestNotificationAuthorization" log:nil];
    [MTPushService requestNotificationAuthorization:^(MTPushAuthorizationStatus status) {
        NSDictionary *result = @{@"status":@(status)};
        callback(result, NO);
    }];
}

//打开通知设置页面
- (void)openSettingsForNotification:(UniModuleKeepAliveCallback)callback {
    [self logger:@"openSettingsForNotification" log:nil];
    [MTPushService openSettingsForNotification:^(BOOL success) {
        NSDictionary *result = [self convertResultWithCode:(success?0:1) content:nil];
        callback(result, NO);
    }];
}


UNI_EXPORT_METHOD(@selector(initPushService))
UNI_EXPORT_METHOD(@selector(addConnectEventListener:))

#pragma  初始化
- (void)initPushService {
    [self logger:@"initMTPushService" log:nil];
    [[MTPushStore shared] initMTPushService:[MTPushStore shared].launchOptions];
}

#pragma - 连接状态监听
- (void)addConnectEventListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addConnectEventListener" log:nil];
    // 监听连接状态
    [[MTPushStore shared] addConnectEventObserver];
    [MTPushStore shared].connectEventCallback = callback;
}



UNI_EXPORT_METHOD(@selector(addNotificationListener:))
UNI_EXPORT_METHOD(@selector(addCustomMessageListener:))

#pragma - 通知回调
// 远程通知事件 notificationEventType：分为notificationArrived和notificationOpened两种
- (void)addNotificationListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addPushNotificationReceiveListener" log:nil];
    [MTPushStore shared].pushNotiCallback = callback;
    
    /* 经测试，app杀死的情况，点击通知进入app，各函数的执行情况为：
     1. application:didFinishLaunchingWithOptions:
     2. mtpushNotificationCenter:didReceiveNotificationResponse: withCompletionHandler:
     3. uniapp --- onLaunch()
    以下代码为了防止的情况：当app杀死的情况下，点击通知进入app，因为该方法在点击通知的回调方法(mtpushNotificationCenter:didReceiveNotificationResponse: withCompletionHandler:)之后,callback值为空，所以并没有回调值给js端，导致js端监听不到通知。
     */
    static BOOL onceLaunchPushBack = NO;
    if (onceLaunchPushBack == YES) {
        return;
    }
    onceLaunchPushBack = YES;
    if ([MTPushStore shared].launchOptions == nil || ![[MTPushStore shared].launchOptions isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([[MTPushStore shared].launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
        [[MTPushStore shared] handeleApnsCallback:[[MTPushStore shared].launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] type:NOTIFICATION_OPENED];
    }
}

// 监听自定义消息/应用处于前台
- (void)addCustomMessageListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addCustomNotificationReceiveListener" log:nil];
    [MTPushStore shared].receiveCustomNotiCallback = callback;
}


UNI_EXPORT_METHOD(@selector(addTagAliasListener:))
UNI_EXPORT_METHOD(@selector(addTags:))
UNI_EXPORT_METHOD(@selector(updateTags:))
UNI_EXPORT_METHOD(@selector(deleteTags:))
UNI_EXPORT_METHOD(@selector(cleanTags:))
UNI_EXPORT_METHOD(@selector(queryTag:))
UNI_EXPORT_METHOD(@selector(getAllTags:))
UNI_EXPORT_METHOD(@selector(setAlias:))
UNI_EXPORT_METHOD(@selector(deleteAlias:))
UNI_EXPORT_METHOD(@selector(queryAlias:))
UNI_EXPORT_METHOD(@selector(filterValidTags:))


#pragma mark - tags/alias

- (void)addTagAliasListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addTagAliasListener" log:nil];
    [MTPushStore shared].tagAliasCallBack = callback;
}


// 新增tags
- (void)addTags:(NSDictionary *)params {
    [self logger:@"addTags with params:" log:params];
    NSSet *tags = [NSSet setWithArray:params[TAGS]];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService addTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 更新tags
- (void)updateTags:(NSDictionary *)params {
    [self logger:@"updateTags with params:" log:params];
    NSSet *tags = [NSSet setWithArray:params[TAGS]];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 删除所有tags
- (void)cleanTags:(NSDictionary *)params {
    [self logger:@"deleteTags with params:" log:params];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 删除指定的tags
- (void)deleteTags:(NSDictionary *)params {
    [self logger:@"deleteTag with params:" log:params];
    NSSet *tags = [NSSet setWithArray:params[TAGS]];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService deleteTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 查询tags
- (void)getAllTags:(NSDictionary *)params {
    [self logger:@"queryTags with params:" log:params];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 查询某一个tag
- (void)queryTag:(NSDictionary *)params {
    [self logger:@"queryTag with params:" log:params];
    NSString *tag = params[TAG];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService validTag:tag completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind) {
        NSArray *tempTags = (iTags.allObjects.count > 0 ? iTags.allObjects : @[]);
        NSDictionary *content = @{
            TAGS:tempTags,
            SEQUENCE:@(seq),
            TAG_ENABLE:@(isBind),
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 设置别名
- (void)setAlias:(NSDictionary *)params {
    [self logger:@"setAlias with params:" log:params];
    NSString *alias = params[ALIAS];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSDictionary *content = @{
            ALIAS:iAlias? iAlias : @"",
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 删除别名
- (void)deleteAlias:(NSDictionary *)params {
    [self logger:@"deleteAlias with params:" log:params];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSDictionary *content = @{
            ALIAS:iAlias? iAlias : @"",
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 查询别名
- (void)queryAlias:(NSDictionary *)params {
    [self logger:@"queryAlias with params:" log:params];
    NSInteger seq = params[SEQUENCE]?[params[SEQUENCE] integerValue]:-1;
    weakObj(self)
    [MTPushService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSDictionary *content = @{
            ALIAS:iAlias? iAlias : @"",
            SEQUENCE:@(seq)
        };
        NSDictionary *result = [weakself convertResultWithCode:iResCode content:content];
        if ([MTPushStore shared].tagAliasCallBack) {
            [MTPushStore shared].tagAliasCallBack(result, YES);
        }
    } seq:seq];
}

// 过滤掉无效的 tags
- (void)filterValidTags:(NSDictionary *)params {
    [self logger:@"filterValidTags with params:" log:params];
    NSSet *tags = [NSSet setWithArray:params[TAGS]];
    [MTPushService filterValidTags:tags];
}


UNI_EXPORT_METHOD(@selector(addLocalNotificationListener:))
UNI_EXPORT_METHOD(@selector(addLocalNotification:))
UNI_EXPORT_METHOD(@selector(removeLocalNotification:))
UNI_EXPORT_METHOD(@selector(clearLocalNotifications))


#pragma mark - 本地通知

- (void)addLocalNotificationListener:(UniModuleKeepAliveCallback)callback {
    [self logger:@"addLocalNotificationListener" log:nil];
    [MTPushStore shared].localNotiCallback = callback;
    
    // 解决 app被本地通知唤醒 接收不到通知回调
    static BOOL onceLaunchLocalPushBack = NO;
    if (onceLaunchLocalPushBack == YES) {
        return;
    }
    onceLaunchLocalPushBack = YES;
    if ([MTPushStore shared].launchOptions == nil || ![[MTPushStore shared].launchOptions isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if ([[MTPushStore shared].launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil){
        UILocalNotification *localNotification = [[MTPushStore shared].launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        [[MTPushStore shared] handlerLocalNotiCallback:localNotification.userInfo type:NOTIFICATION_OPENED];
    }
}

- (void)addLocalNotification:(NSDictionary *)params {

    NSString *messageID = params[MESSAGE_ID]?params[MESSAGE_ID]:@"";
    
    MTPushNotificationContent *content = [[MTPushNotificationContent alloc] init];
    NSString *notificationTitle = params[TITLE]?params[TITLE]:@"";
    NSString *notificationContent = params[CONTENT]?params[CONTENT]:@"";
    content.title = notificationTitle;
    content.body = notificationContent;
    if(params[EXTRAS]){
        content.userInfo = @{MESSAGE_ID:messageID,TITLE:notificationTitle,CONTENT:notificationContent,EXTRAS:params[EXTRAS]};
    }else{
        content.userInfo = @{MESSAGE_ID:messageID,TITLE:notificationTitle,CONTENT:notificationContent};
    }
    MTPushNotificationTrigger *trigger = [[MTPushNotificationTrigger alloc] init];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    components = dateComponent;
    components.second = [dateComponent second]+1;
    if (@available(iOS 10.0, *)) {
        trigger.dateComponents = components;
    } else {
        trigger.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    }
    MTPushNotificationRequest *request = [[MTPushNotificationRequest alloc] init];
    request.requestIdentifier = messageID;
    request.content = content;
    request.trigger = trigger;
    [MTPushService addNotification:request];
    
}

// 移除指定的本地通知
- (void)removeLocalNotification:(NSDictionary *)params {
    NSString *requestIdentifier = params[MESSAGE_ID];
    if ([requestIdentifier isKindOfClass:[NSString class]]) {
        MTPushNotificationIdentifier *identifier = [[MTPushNotificationIdentifier alloc] init];
        identifier.identifiers = @[requestIdentifier];
        if (@available(iOS 10.0, *)) {
            identifier.delivered = YES;
        }
        [MTPushService removeNotification:identifier];
    }
}

// 移除所有的本地通知
- (void)clearLocalNotifications {
    [self logger:@"clearLocalNotifications" log:nil];
    [MTPushService removeNotification:nil];
}

#pragma mark - other
- (NSDictionary *)convertResultWithCode:(NSInteger)code content:(NSDictionary *)dicInfo {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[CODE] = @(code);
    [dicInfo enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if(![key isEqualToString:CODE]) {
            [result setObject:obj forKey:key];
        }
    }];
    return [result copy];
}

// debug 打印控制
- (void)logger:(NSObject *)tag log:(NSObject *)log
{
    if(mtpush_debugMode){
          NSLog(@"MTPushModule--->%@ %@", tag,log);
    }
}

@end
