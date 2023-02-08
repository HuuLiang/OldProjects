//
//  AppDelegate+configuration.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "AppDelegate+configuration.h"

@implementation AppDelegate (configuration)

- (void)setCommonStyle {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#ffe100"]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#666666"]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[LSJUtil isIpad] ? 21 : kWidth(36)],
//                                                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navi_back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navi_back"]];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"  " style:UIBarButtonItemStylePlain handler:nil];
//                                   if (thisVC.navigationController.viewControllers.count > 1) {
//                                       thisVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//                                           [thisVC.navigationController popViewControllerAnimated:YES];
//                                       }];
//                                   }
                                   thisVC.navigationController.navigationBar.translucent = NO;
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
    
//    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
//                                    withOptions:AspectPositionInstead
//                                     usingBlock:^(id<AspectInfo> aspectInfo){
//                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
//                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
//                                     } error:nil];
    
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

@end
