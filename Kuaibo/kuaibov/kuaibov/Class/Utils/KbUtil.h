//
//  KbUtil.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;
@class KbPaymentInfo;

@interface KbUtil : NSObject

+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSArray<KbPaymentInfo *> *)allPaymentInfos;
+ (NSArray<KbPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<KbPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (KbPaymentInfo *)successfulPaymentInfo;
+ (BOOL)isPaid;


+ (NSString *)accessId;
+ (NSString *)userId;
+ (NSString *)deviceName;
+ (KbDeviceType)deviceType;

+ (void)startMonitoringNetwork;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;

+ (UIViewController *)currentVisibleViewController;

+ (NSString *)getIPAddress;


@end
