//
//  MTPushStore.m
//  UniPluginMTPush
//
//  Created by huangshuni on 2021/1/13.
//

#import "MTPushStore.h"
#import <UserNotifications/UserNotifications.h>

@interface MTPushStore ()

@end

@implementation MTPushStore

+ (instancetype)shared {
    static MTPushStore *store;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[MTPushStore alloc] init];
    });
    return store;
}

// mtpush初始化
- (void)initMTPushService:(NSDictionary *)launchOptions {
    
    [self registerForRemoteNotificationConfig];
    // 初始化sdk
    [self setupWithOption:launchOptions];
    // 监听透传消息
    [self addCustomMessageObserver];
}

#pragma mark - 初始化
- (void)setupWithOption:(NSDictionary *)launchOptions {

    NSDictionary *launchingOption = launchOptions;

    NSString *path = [[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    // appkey
    NSString *appkey = dict[infoConfig_MTPush][infoConfig_MTPush_APP_KEY];
    // channel
    NSString *channel = dict[infoConfig_MTPush][infoConfig_MTPush_CHANNEL];
    if (channel == nil ||channel.length == 0) {
        channel = @"developer-default";
    }
    // isProduction
    BOOL isProduction = NO;
    NSString *isProductionStr = dict[infoConfig_MTPush][infoConfig_MTPush_ISPRODUCTION];
    if (isProductionStr == nil || isProductionStr.length == 0 || [isProductionStr isEqualToString:@"false"]) {
        isProduction = NO;
    }else if ([isProductionStr isEqualToString:@"true"]) {
        isProduction = YES;
    }
    // advertisingId
    NSString *advertisingId = dict[infoConfig_MTPush][infoConfig_MTPush_ADVERTISINGID];
    if (![advertisingId isKindOfClass:[NSString class]] || advertisingId == nil || advertisingId.length == 0) {
        advertisingId = nil;
    }
    
    [MTPushService setupWithOption:launchingOption appKey:appkey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];

}

- (void)registerForRemoteNotificationConfig {
    
    MTPushRegisterEntity * entity = [[MTPushRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = MTPushAuthorizationOptionAlert|MTPushAuthorizationOptionBadge|MTPushAuthorizationOptionSound|MTPushAuthorizationOptionProvidesAppNotificationSettings;
        if (@available(iOS 13.0, *)) {
            entity.types = entity.types | MTPushAuthorizationOptionAnnouncement;
        }
    } else {
        entity.types = MTPushAuthorizationOptionAlert|MTPushAuthorizationOptionBadge|MTPushAuthorizationOptionSound;
    }
    [MTPushService registerForRemoteNotificationConfig:entity delegate:[MTPushStore shared]];
    
}

#pragma mark - 连接状态
- (void)addConnectEventObserver {
    
    if ([MTPushStore shared].connectEventCallback) {
        // 已经观察过
        return;
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kMTCNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegisterFailed:)
                          name:kMTCNetworkFailedRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kMTCNetworkDidLoginNotification
                        object:nil];
}


- (void)networkDidClose:(NSNotification *)notification {
    [self connectEventCallbackHandle:notification];
}

- (void)networkDidRegisterFailed:(NSNotification *)notification {
    [self connectEventCallbackHandle:notification];
}

- (void)networkDidLogin:(NSNotification *)notification {
    [self connectEventCallbackHandle:notification];
}

- (void)connectEventCallbackHandle:(NSNotification *)notification {
    
    BOOL isConnect = false;
    NSNotificationName notificationName = notification.name;
    if([notificationName isEqualToString:kMTCNetworkDidLoginNotification]){
        isConnect = true;
    }
    NSDictionary *responseData = @{CONNECT_ENABLE:@(isConnect)};
    if ([MTPushStore shared].connectEventCallback) {
        [MTPushStore shared].connectEventCallback(responseData, YES);
    }
}

#pragma mark - 透传消息
- (void)addCustomMessageObserver {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kMTCNetworkDidReceiveMessageNotification
                        object:nil];
}

// 收到透传消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *result = @{
        @"messageID":userInfo[@"_j_msgid"]?:@"",
        @"content":userInfo[@"content"]?:@"",
        @"extras":userInfo[@"extras"]?:@{},
    };
    if ([MTPushStore shared].receiveCustomNotiCallback) {
        [MTPushStore shared].receiveCustomNotiCallback(result, YES);
    }
}


#ifdef __IPHONE_10_0
#pragma mark- MTPushRegisterDelegate
- (void)mtpNotificationAuthorization:(MTPushAuthorizationStatus)status withInfo:(NSDictionary *)info {
    NSLog(@"receive notification authorization status:%lu, info:%@", (unsigned long)status, info);
}


// 应用在前台 推送消息过来 会触发 需要回调completionHandler才能显示
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程推送
        [self handeleApnsCallback:userInfo type:NOTIFICATION_ARRIVED];
    }
    else {
        //本地通知
        [self handlerLocalNotiCallback:userInfo type:NOTIFICATION_ARRIVED];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// 点击通知会触发
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handeleApnsCallback:userInfo type:NOTIFICATION_OPENED];
    }
    else {
        [self handlerLocalNotiCallback:userInfo type:NOTIFICATION_OPENED];
    }
    completionHandler();
}


#ifdef __IPHONE_12_0
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{

}

#endif

#endif



#pragma mark -
// 处理远程通知回调
- (void)handeleApnsCallback:(NSDictionary *)userInfo type:(NSString *)type {
    [MTPushService handleRemoteNotification:userInfo];
    NSDictionary *result = [self convertApnsMessage:userInfo type:type];
    if ([MTPushStore shared].pushNotiCallback) {
        [MTPushStore shared].pushNotiCallback(result, YES);
    }
}

- (NSDictionary *)convertApnsMessage:(NSDictionary *)userInfo type:(NSString *)type{
    NSMutableDictionary *extras = [NSMutableDictionary dictionary];
    for (NSString *key in userInfo.allKeys) {
        if ([key isEqualToString:@"_j_business"] || [key isEqualToString:@"_j_msgid"] || [key isEqualToString:@"_j_uid"] || [key isEqualToString:@"aps"] || [key isEqualToString:@"_j_geofence"] || [key isEqualToString:@"_j_extras"] || [key isEqualToString:@"_j_ad_content"] || [key isEqualToString:@"_j_data_"] || [key isEqualToString:@"_j_private_cloud"]) {
            continue;
        }
        [extras setValue:userInfo[key] forKey:key];
    }

    id alertData =  userInfo[@"aps"][@"alert"];
    NSString *badge = userInfo[@"aps"][@"badge"]?[userInfo[@"aps"][@"badge"] stringValue]:@"";
    NSString *sound = userInfo[@"aps"][@"sound"]?userInfo[@"aps"][@"sound"]:@"";
    NSString *title = @"";
    NSString *content = @"";
    if([alertData isKindOfClass:[NSString class]]){
        content = alertData;
    }else if([alertData isKindOfClass:[NSDictionary class]]){
        title = alertData[@"title"]?alertData[@"title"]:@"";
        content = alertData[@"body"]?alertData[@"body"]:@"";
    }
    
    if (userInfo[@"_j_extras"] && [userInfo[@"_j_extras"] isKindOfClass:[NSDictionary class]]) {
        badge = userInfo[@"_j_extras"][@"badge"];
        sound = userInfo[@"_j_extras"][@"sound"];
        if ([userInfo[@"_j_extras"][@"alert"] isKindOfClass:[NSDictionary class]]) {
            title = userInfo[@"_j_extras"][@"alert"][@"title"];
            content = userInfo[@"_j_extras"][@"alert"][@"body"];
        }
    }

    NSMutableDictionary *temResult = [NSMutableDictionary dictionaryWithDictionary:@{
        @"messageID":userInfo[@"_j_msgid"]?:@"",
        @"title":title?:@"",
        @"content":content?:@"",
        @"badge":badge?:@"",
        @"ring":sound?:@"",
        @"extras":[extras copy]?:@{},
        @"iOS":userInfo?:@{},
        NOTIFICATION_EVENTTYPE:type,
    }];

    NSDictionary *result = [temResult copy];
    
    return result;
}

// 处理本地通知回调
- (void)handlerLocalNotiCallback:(NSDictionary *)userInfo type:(NSString *)type {
   
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
       result = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    }
    [result setValue:type forKey:NOTIFICATION_EVENTTYPE];
    if ([MTPushStore shared].localNotiCallback) {
        [MTPushStore shared].localNotiCallback(result, YES);
    }
}

#pragma mark -
- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

@end
