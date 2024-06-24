//
//  MTPushStore.h
//  UniPluginMTPush
//
//  Created by huangshuni on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import "DCUniModule.h"
#import "MTPushService.h"

#define infoConfig_MTPush                   @"MTPush"
#define infoConfig_MTPush_APP_KEY           @"APP_KEY"
#define infoConfig_MTPush_CHANNEL           @"CHANNEL"
#define infoConfig_MTPush_ISPRODUCTION      @"ISPRODUCTION"
#define infoConfig_MTPush_ADVERTISINGID     @"ADVERTISINGID"
#define infoConfig_MTPush_DEFAULTINIT       @"DEFAULTINIT"

#define CONNECT_ENABLE          @"connectEnable"
#define NOTIFICATION_EVENTTYPE  @"notificationEventType"
#define NOTIFICATION_ARRIVED    @"notificationArrived"
#define NOTIFICATION_OPENED     @"notificationOpened"


NS_ASSUME_NONNULL_BEGIN

@interface MTPushStore : NSObject <MTPushRegisterDelegate>

@property (nonatomic, copy) UniModuleKeepAliveCallback connectEventCallback; // 连接状态
@property (nonatomic, copy) UniModuleKeepAliveCallback pushNotiCallback; // apns推送消息
@property (nonatomic, copy) UniModuleKeepAliveCallback receiveCustomNotiCallback; //自定义消息

@property (nonatomic, copy) UniModuleKeepAliveCallback localNotiCallback; // 本地通知

@property (nonatomic, copy) UniModuleKeepAliveCallback locationAuthorizationCallBack;

@property (nonatomic, copy) UniModuleKeepAliveCallback tagAliasCallBack; // 标签别名回调

@property (nonatomic, copy) UniModuleKeepAliveCallback addMobileNumberCallBack;

@property (nonatomic, strong) NSDictionary *launchOptions;

+ (instancetype)shared;

// 初始化push
- (void)initMTPushService:(NSDictionary *)launchOptions;

- (void)addConnectEventObserver;

- (void)handeleApnsCallback:(NSDictionary *)userInfo type:(NSString *)type;

- (void)handlerLocalNotiCallback:(NSDictionary *)userInfo type:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
