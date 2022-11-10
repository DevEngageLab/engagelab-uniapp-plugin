//
//  MTPushProxy.m
//  UniPluginMTPush
//
//  Created by huangshuni on 2021/1/13.
//

#import "MTPushProxy.h"
#import "MTPushStore.h"
#import "MTPushService.h"


@implementation MTPushProxy


- (void)onCreateUniPlugin {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (BOOL)application:(UIApplication *_Nullable)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
    
    [MTPushStore shared].launchOptions = launchOptions;
    
    // 初始化
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *defaultInitPush = dict[infoConfig_MTPush][infoConfig_MTPush_DEFAULTINIT];
    if ([defaultInitPush isEqualToString:@"true"]) {
        [[MTPushStore shared] initMTPushService:launchOptions];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication * _Nullable)application {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationDidBecomeActive:(UIApplication *_Nullable)application {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationDidEnterBackground:(UIApplication *_Nullable)application {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationWillEnterForeground:(UIApplication *_Nullable)application {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationWillTerminate:(UIApplication *_Nullable)application {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"UniPluginProtocol Func: %@,%s",self,__func__);
    [MTPushService registerDeviceToken:deviceToken];
}

// ios8 - ios10 应用前台收到apns消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[MTPushStore shared] handeleApnsCallback:userInfo type:NOTIFICATION_ARRIVED];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    [[MTPushStore shared] handlerLocalNotiCallback:userInfo type:NOTIFICATION_ARRIVED];
}




@end
