//
//  AppDelegate+login.m
//  JYFriend
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "AppDelegate+login.h"
#import "JYLoginViewController.h"
#import "JYTabBarController.h"
#import "JYNavigationController.h"
#import "JYSystemConfigModel.h"
#import "JYActivateModel.h"
#import "JYUserAccessModel.h"
#import <UMMobClick/MobClick.h>
#import <QBPaymentManager.h>
#import <QBPaymentConfig.h>

static NSString *const kAliPaySchemeUrl = @"JYFriendAliPayUrlScheme";


@interface AppDelegate ()
//{
//    UIViewController *_rootViewController;
//}
@end

@implementation AppDelegate (login)

- (void)checkNetworkInfoState {
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = JY_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([JY_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = JY_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = JY_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = NO;
    [QBNetworkingConfiguration defaultConfiguration].encryptedType = QBURLEncryptedTypeNew;
#ifdef DEBUG
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JY_REST_APPID
                                                     paymentPv:@([JY_PAYMENT_PV integerValue])
                                                     channelNo:JY_CHANNEL_NO
                                                     urlScheme:kAliPaySchemeUrl
                                                 defaultConfig:[self setDefaultPaymentConfig]];

    
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
        if (reachable && ![JYSystemConfigModel sharedModel].loaded) {
            //系统配置
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        
        //激活信息
        if (reachable && ![JYUtil isRegisteredUUID]) {
            [[JYActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *uuid) {
                if (success) {
                    [JYUtil setRegisteredWithUUID:uuid];
//                    [[JYUserAccessModel sharedModel] requestUserAccess];
                }
            }];
        }
//        else {
//            [[JYUserAccessModel sharedModel] requestUserAccess];
//        }
        
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![JYUtil isRegisteredUUID] || ![JYSystemConfigModel sharedModel].loaded)) {
            if ([JYUtil isIpad]) {
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
    
//    设置图片referer
    BOOL requestedSystemConfig = NO;
    NSString *imageToken = [JYUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
        [self checkUserIsLogin];
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            [self checkUserIsLogin];
        }];
        
    }
    
    if (!requestedSystemConfig) {
        [[JYSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                [JYUtil setImageToken:[JYSystemConfigModel sharedModel].imageToken];
            }
            NSUInteger statsTimeInterval = 180;
            //数据统计相关
            [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        }];
    }
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = JY_UMENG_APP_ID;
    UMConfigInstance.channelId = JY_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)checkUserIsLogin {
    
    if ([JYUtil isRegisteredUserId]) {
        self.window.rootViewController = self.rootViewController;
    } else {
        JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
        JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
    }
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userloginSuccess:) name:kUserLoginNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseErrorInfo:) name:kQBNetworkingErrorNotification object:nil];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[JYSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [JYSystemConfigModel sharedModel].imageToken;
            [JYUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
            }
        }
        NSUInteger statsTimeInterval = 180;
        [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        QBSafelyCallBlock(completionHandler, success);
    }];
}

- (void)userloginSuccess:(NSNotification *)notification {
    if (self.window.rootViewController.presentedViewController == nil) {
        [self.window.rootViewController presentViewController:self.rootViewController animated:YES completion:^{
            self.window.rootViewController = self.rootViewController;
            [self.window makeKeyAndVisible];
        }];
    }
}

- (void)responseErrorInfo:(NSNotification *)notification {
    
}

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3009833585";
    iAppPayConfig.privateKey = @"MIICXAIBAAKBgQCUQdOH7B8xMBvAv2W+4qGtIQnVEIPEMic+T2GYYGCtx9VCoFXB/flUv6SPGkbUcvkafk9Goh2+Qk6jPzTBYt0FlrbJg1BBs0XcKaR/YE+P8eaQVuOgdaffD4G38kMwwJBbOFzyg/n4ovQx3tyURn4Cz/4AKeiV7pyoDFhvUxfXkQIDAQABAoGAbi19RkXz6FoYReX3dyR1gnRLGkxroCKlh2j23obBUmRv2FPPZ5uW76R8ZtzgRoIrHcVApP1VnU8poagXTKBsH9lYcjuDXDx3nGkop7K69oddzwMvR+RiMva5ryBjAD8kZZYGP/1ZqNts6Hg+vXGLn4gRdrXCHFcEpaqVZeR55QECQQDKnCDUaN9c9MEtctf40JeMMRatKaMP/73BvsyXD1jfjdFJw5tER/AUTMC9omyds93rY6nPZJI0qfmQy48Q5U1LAkEAu1Mc+PdoDo81Y3ElEuClS1zicjrFya68QL5Y4q0cqU+3tjCa2J9UpBG5Qqk4j9kxPHtlHgBjIbjWmjBHkL9xEwJAU/Ql1l4uT8JLWZ3AyCUG5txgXRhnrPV3l5SMCfweA2QsWLho2f5FCORU6T8oaqBhUGxXrMwrmQ7ljo4KliGtyQJAeohaWkzTpzpsDNk1DA0gcpSWl2v0dwGyqJMaZ2QfbGz12dofX/WREyV4zq8MjaPfvhVlRmOwdJ2I2yEbnwZrOwJBAKE+Xh5mXoGv+IFaKPbenlTmk38Zcxaokx8gvdzHaJQOQtFhkf/eFOhXGGufpeQOHIdGFTjjoOKKPh5y7XzMrLc=";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQClu8EKXBq54ne+/GGxa09a6xa/8rKJZDnQ8CFe6D9xQLdV9P84kna6A5kqSZOiz3WnWGXDeCL+4M6N+5SiVPkF1cY5Im+eFevsIi2zGO3xUQ5SuVMrEeV86jNS/2VOgWlFWlWHVYndWxAZW7S0QdY0b/Fd+B40r2gwbMAXznsu5QIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = kQBIAppPayConfigName;
    payConfig.wechat = @"kQBIAppPayConfigName";
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    [config setAsCurrentConfig];
    
    return config;
}


@end
