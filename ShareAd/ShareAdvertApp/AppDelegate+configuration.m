//
//  AppDelegate+configuration.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate+configuration.h"
#import "QBNetworkInfo.h"
#import <UMMobClick/MobClick.h>
#import "SATabBarController.h"
#import "QBImageUploadManager.h"
#import "QBDataManager.h"
#import "SAReqManager.h"
#import "SAActivateModel.h"
#import <WXApi.h>
#import "SAShareManager.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate (configuration)

- (void)showHomeViewController {
    [self defaultConfiguration];
    
    SATabBarController *rootVC = [[SATabBarController alloc] init];
    self.window.rootViewController = rootVC;
}

- (void)defaultConfiguration {
    [self setupMobStatistics];
    [WXApi registerApp:SA_WEXIN_APP_ID];
    [QBImageUploadManager registerWithSecretKey:SA_UPLOAD_SECRET_KEY accessKey:SA_UPLOAD_ACCESS_KEY scope:SA_UPLOAD_SCOPE];
}


- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = SA_UMENG_APP_ID;
    UMConfigInstance.channelId = SA_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)setCommonStyle {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#FAFAFA"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor(@"#999999")} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor(@"#FF3366")} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UINavigationBar appearance] setBarTintColor:kColor(@"#FF3366")];
    [[UINavigationBar appearance] setBackgroundColor:kColor(@"#FF3366")];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [UINavigationBar appearance].translucent = NO;
    
//    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
//                                withOptions:AspectPositionInstead
//                                 usingBlock:^(id<AspectInfo> aspectInfo){
//                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
//                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
//                                     
//                                     BOOL autoRotate = NO;
//                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
//                                     } else {
//                                         autoRotate = [selectedVC shouldAutorotate];
//                                     }
//                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
//                                 } error:nil];
//    
//    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
//                                withOptions:AspectPositionInstead
//                                 usingBlock:^(id<AspectInfo> aspectInfo){
//                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
//                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
//                                     
//                                     NSUInteger result = 0;
//                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
//                                     } else {
//                                         result = [selectedVC supportedInterfaceOrientations];
//                                     }
//                                     [[aspectInfo originalInvocation] setReturnValue:&result];
//                                 } error:nil];
//    
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
//
//    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
//                          withOptions:AspectPositionInstead
//                           usingBlock:^(id<AspectInfo> aspectInfo)
//     {
//         BOOL bShow = NO;
//         [[aspectInfo originalInvocation] setReturnValue:&bShow];
//     } error:nil];
}

- (void)checkNetworkInfoState {
    [QBDataConfiguration configuration].baseUrl = SA_BASE_URL;
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
        if (reachable && [SAUtil isRegisteredUUID]) {
            [self showHomeViewController];
        } else {
            [self activate];
        }
        
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![SAUtil isRegisteredUUID])) {
            if ([SAUtil isIpad]) {
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

/** 激活 */
- (void)activate {
    [[SAReqManager manager] fetchActivateInfoWithClass:[SAActivateModel class] Handler:^(BOOL success, SAActivateModel * obj) {
        if (success) {
            [SAUtil setRegisteredWithUUID:obj.uuid];
            [self showHomeViewController];
        }
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}


#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    QBLog(@"%@",req);
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        [[SAShareManager manager] receiveWxResp:resp];
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [[SAShareManager manager] sendAuthRespCode:resp];
    }
}


@end
