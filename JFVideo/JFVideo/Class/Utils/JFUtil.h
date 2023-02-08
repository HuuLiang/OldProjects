//
//  JFUtil.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QBPayment/QBPaymentInfo.h>

extern NSString *const kPaymentInfoKeyName;

@interface JFUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (JFDeviceType)deviceType;
+ (BOOL)isIpad;

+ (void)registerVip;
+ (BOOL)isVip;

+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (QBPaymentInfo *)successfulPaymentInfo;
+ (NSArray<QBPaymentInfo *> *)allUnsuccessfulPaymentInfos;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)currentTimeString;

+ (NSString *)paymentReservedData;

+ (UIViewController *)currentVisibleViewController;

+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;
//+ (void)setDefaultPrice;
+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(id)params;
+ (NSString *)encodeVideoUrlWithVideoUrlStr:(NSString *)videoUrlStr;

@end
