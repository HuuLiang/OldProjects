//
//  AppDelegate+configuration.h
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (configuration)

- (void)checkNetworkInfoState;
- (void)setCommonStyle;
- (void)setApplicationIconBadgeNumber:(UIApplication *)application;
- (void)checkLocalNotificationWithLaunchOptionsOptions:(NSDictionary *)launchOptions;
//test
- (void)showHomeViewController;

@end
