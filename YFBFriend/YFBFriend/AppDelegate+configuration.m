//
//  AppDelegate+configuration.m
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate+configuration.h"
#import "YFBAccountManager.h"
#import "YFBImageUploadManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WeChatPayManager.h"
#import "AlipayManager.h"
#import <UMMobClick/MobClick.h>
#import "YFBAutoReplyManager.h"
#import "YFBContactManager.h"
#import "YFBActivateModel.h"
#import "YFBSystemConfigModel.h"


static NSString *const kAliPaySchemeUrl = @"YFBFriendAliPayUrlScheme";

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate (configuration)

- (void)checkNetworkInfoState {
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = YFB_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([YFB_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = YFB_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = YFB_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = NO;
    [QBNetworkingConfiguration defaultConfiguration].encryptedType = QBURLEncryptedTypeNew;
    [QBNetworkingConfiguration defaultConfiguration].encryptionPasssword = YFB_ENCRYPT_PASSWORD;
#ifdef DEBUG
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
        if (reachable && [YFBUtil isRegisteredUUID]) {
            [self showHomeViewController];
        } else {
            [self registerUUID];
        }
        
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![YFBUtil isRegisteredUUID])) {
            if ([YFBUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
            }else{
                [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
            }
        }
    };
}

- (void)registerUUID {
    [[YFBActivateModel manager] activateWithCompletionHandler:^(BOOL success, NSString * uuid) {
        if (success) {
            [YFBUtil setRegisteredWithUUID:uuid];
            [self showHomeViewController];
        }
    }];
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = YFB_UMENG_APP_ID;
    UMConfigInstance.channelId = YFB_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)showHomeViewController {
    //设置默认配置信息  微信注册  七牛注册  加载钻石 礼物信息
    [WXApi registerApp:YFB_WEXIN_APP_ID];
    [self setupMobStatistics];
    [YFBImageUploadManager registerWithSecretKey:YFB_UPLOAD_SECRET_KEY accessKey:YFB_UPLOAD_ACCESS_KEY scope:YFB_UPLOAD_SCOPE];
    
    [[YFBSystemConfigModel defaultConfig] fetchSystemConfigInfoWithCompletionHandler:^(BOOL success, YFBSystemConfigInfo * obj) {
        if (success) {
            [YFBSystemConfigModel defaultConfig].config = obj;
        }
    }];
    
    self.window.rootViewController = self.launchViewController;
    
    [self.window makeKeyAndVisible];
}

- (void)setCommonStyle {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UINavigationBar appearance] setBarTintColor:kColor(@"#8458D0")];
    [[UINavigationBar appearance] setBackgroundColor:kColor(@"#8458D0")];
        
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
     {
         UIViewController *thisVC = [aspectInfo instance];
         BOOL hidesBottomBar = NO;
         if (thisVC.navigationController.viewControllers.count > 1) {
             hidesBottomBar = YES;
         }
         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
     } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[AlipayManager shareInstance] sendNotificationByResult:resultDic];
    }];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[AlipayManager shareInstance] sendNotificationByResult:resultDic];
    }];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[AlipayManager shareInstance] sendNotificationByResult:resultDic];
    }];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[notification.userInfo.allKeys firstObject] isEqualToString:kYFBAutoNotificationTypeKeyName]) {
        [[YFBAutoReplyManager manager] getRandomReplyMessage];
    }
    [application setApplicationIconBadgeNumber:[[YFBContactManager manager] allUnReadMessageCount]];
}

- (void)checkLocalNotificationWithLaunchOptionsOptions:(NSDictionary *)launchOptions {
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (!localNotification) {
        return;
    }
    if ([[localNotification.userInfo.allKeys firstObject] isEqualToString:kYFBAutoNotificationTypeKeyName]) {
        [[YFBAutoReplyManager manager] getRandomReplyMessage];
    }
}

- (void)setApplicationIconBadgeNumber:(UIApplication *)application {
    application.applicationIconBadgeNumber = [[YFBContactManager manager] allUnReadMessageCount];
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    QBLog(@"%@",req);
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [[YFBAccountManager manager] sendAuthRespCode:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[PayResp class]]) {
        YFBPayResult payResult;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = YFBPayResultCancle;
        } else if (resp.errCode == WXSuccess) {
            payResult = YFBPayResultSuccess;
        } else {
            payResult = YFBPayResultFailed;
        }
        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
    }
}

@end
