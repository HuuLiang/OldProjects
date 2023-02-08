//
//  AppDelegate.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "AppDelegate.h"

#import "JFActivateModel.h"
#import "JFUserAccessModel.h"

#import "JFSystemConfigModel.h"
//#import "JFVideoTokenManager.h"

#import "JFHomeViewController.h"
#import "JFChannelListViewController.h"
#import "JFHotViewController.h"
#import "JFMineViewController.h"
#import "MobClick.h"

#import <QBPayment/QBPaymentManager.h>
#import <QBNetworking/QBNetworkingConfiguration.h>
#import <QBPaymentConfig.h>

//#import <DXTXPay/PayuPlugin.h>

static NSString *const kHTPaySchemeUrl = @"wxd3c9c179bb827f2c";
static NSString *const kIappPaySchemeUrl = @"comdongjingrebo2016ppiapppayurlscheme";

@interface AppDelegate () <UITabBarControllerDelegate>
{
    UITabBarController *_tabBarController;
    
}
@property (nonatomic,retain) UIViewController *rootViewController;

@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];

    return _window;
}

- (UIViewController *)rootViewController {
    if (_rootViewController) {
        return _rootViewController;
    }
    
    JFHomeViewController *homeVC        = [[JFHomeViewController alloc] init];
    homeVC.title                         = @"首页";
    UINavigationController *homeNav      = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_home_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    
    
    JFChannelListViewController *channelVC = [[JFChannelListViewController alloc] init];
    channelVC.title                     = @"女优特辑";
    UINavigationController *channelNav  = [[UINavigationController alloc] initWithRootViewController:channelVC];
    channelNav.tabBarItem               = [[UITabBarItem alloc] initWithTitle:channelVC.title
                                                                        image:[UIImage imageNamed:@"tabbar_channel_normal"]
                                                                selectedImage:[UIImage imageNamed:@"tabbar_channel_selected"]];
    
    JFHotViewController *hotVC = [[JFHotViewController alloc] init];
    hotVC.title                          = @"热搜";
    UINavigationController * hotNav      = [[UINavigationController alloc] initWithRootViewController:hotVC];
    hotNav.tabBarItem                    = [[UITabBarItem alloc] initWithTitle:hotVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_hot_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_hot_selected"]];
    
    JFMineViewController *mineVC        = [[JFMineViewController alloc] init];
    mineVC.title                         = @"私密区";
    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_mine_selected"]];
    
    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,channelNav,hotNav,mineNav];
    tabBarController.tabBar.translucent = NO;
    tabBarController.delegate = self;
//    _window.rootViewController              = tabBarController;
    _rootViewController = tabBarController;
    return _rootViewController;
}

- (void)setupCommonStyles {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#efefef"]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"#ec5382"]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.],
                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b0b0b0"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.],
                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#e51c23"]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#212121"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                                   thisVC.navigationController.navigationBar.translucent = NO;
//                                   [thisVC.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar.jpg"] forBarMetrics:UIBarMetricsDefault];
                               } error:nil];
    
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
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
    
    
}


- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:JF_UMENG_APP_ID reportPolicy:BATCH channelId:JF_CHANNEL_NO];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = JF_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([JF_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = JF_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = JF_BASE_URL;
#ifdef DEBUG
//    [QBNetworkingConfiguration defaultConfiguration].logEnabled = YES;
#endif
    
    
    [JFUtil accumateLaunchSeq];
//    [JFUtil setDefaultPrice];
    [self setupCommonStyles];
    [[QBNetworkInfo sharedInfo] startMonitoring];
//    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];//支付测试
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JF_REST_APPID paymentPv:@([JF_PAYMENT_PV integerValue]) channelNo:JF_CHANNEL_NO urlScheme:kIappPaySchemeUrl defaultConfig:[self setDefaultPaymentConfig]];
    [self setupMobStatistics];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^(BOOL reachable) {
        if (reachable && ![JFSystemConfigModel sharedModel].loaded) {
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        if (reachable && ![JFUtil isRegistered]) {
            [[JFActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
                if (success) {
                    [JFUtil setRegisteredWithUserId:userId];
                    [[JFUserAccessModel sharedModel] requestUserAccess];
//                    [[JFVideoTokenManager sharedManager]requestTokenWithCompletionHandler:nil];
                }
            }];
        } else {
            [[JFUserAccessModel sharedModel] requestUserAccess];
//             [[JFVideoTokenManager sharedManager]requestTokenWithCompletionHandler:nil];
        }
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![JFUtil isRegistered] || ![JFSystemConfigModel sharedModel].loaded)) {
            
            if ([JFUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
                //                [[CRBHudManager manager] showHudWithText:@"请检查您的网络连接!"];
            }else {
            [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            }}
    };

    
    BOOL requestedSystemConfig = NO;
//#ifdef JF_IMAGE_TOKEN_ENABLED
    NSString *imageToken = [JFUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
//              [[JFVideoTokenManager sharedManager] setValue:imageToken forVideoHttpHeader:@"Referer"];
        self.window.rootViewController = self.rootViewController;
        [self.window makeKeyAndVisible];
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            self.window.rootViewController = self.rootViewController;
        }];

    }

    
    if (!requestedSystemConfig) {
        [[JFSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//#ifdef JF_IMAGE_TOKEN_ENABLED
            if (success) {
                [JFUtil setImageToken:[JFSystemConfigModel sharedModel].imageToken];
            }
//#endif
            NSUInteger statsTimeInterval = 180;
            if ([JFSystemConfigModel sharedModel].loaded && [JFSystemConfigModel sharedModel].statsTimeInterval > 0) {
                statsTimeInterval = [JFSystemConfigModel sharedModel].statsTimeInterval;
            }
            [[JFStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        }];
    }
   
    return YES;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[JFSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [JFSystemConfigModel sharedModel].imageToken;
            [JFUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
//                  [[JFVideoTokenManager sharedManager] setValue:fetchedToken forVideoHttpHeader:@"Referer"];
            }
            
        }
        
        NSUInteger statsTimeInterval = 180;
        [[JFStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        QBSafelyCallBlock(completionHandler, success);
    }];
}

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3006339410";
    iAppPayConfig.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCylTy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlltV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    
    //海豚默认配置
    QBHTPayConfig *htpayConfig = [[QBHTPayConfig alloc] init];
    htpayConfig.mchId = @"10014";
    htpayConfig.key = @"55f4f728b7a01c2e57a9f767fd34cb8e";
    htpayConfig.appid = @"wx875f657cb7c841de";
    htpayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyHtPay.json";
    htpayConfig.payType = @"w";
    configDetails.htpayConfig = htpayConfig;
    
    //WJPAY
//        QBWJPayConfig *wjPayCofig = [[QBWJPayConfig alloc] init];
//        wjPayCofig.mchId = @"50000009";
//        wjPayCofig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyWujism.json";
//        wjPayCofig.signKey = @"B0C65DF81AA7EA85";
//        configDetails.wjPayConfig = wjPayCofig;
    
    //ZhangPay
//    QBZhangPayConfig *zhangPayConfig = [[QBZhangPayConfig alloc] init];
//    zhangPayConfig.key = @"bc1a56fc75dfb0c89631a8598189f3bf";
//    zhangPayConfig.mchId = @"102580055502";
//    zhangPayConfig.appid = @"wx3ec6aaf9bdd25d44";
//    zhangPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyMly.json";
//    configDetails.zhangPayConfig = zhangPayConfig;
    
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = @"IAPPPAY";
    payConfig.wechat = @"HAITUN";//@"SYSK";//
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    
    [config setAsCurrentConfig];
    return config;
}



- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
}
#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [[JFStatsManager sharedManager] statsTabIndex:tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forClickCount:1];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[JFStatsManager sharedManager] statsStopDurationAtTabIndex:tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
    return YES;
}

@end
