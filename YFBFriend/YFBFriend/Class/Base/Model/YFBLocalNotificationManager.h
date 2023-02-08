//
//  YFBLocalNotificationManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBLocalNotificationManager : NSObject

+ (instancetype)manager;

- (void)startAutoLocalNotification;

- (void)setAutoNotification;

@end
