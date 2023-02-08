//
//  JQKUtil.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;

@class JQKVideo;

@interface JQKUtil : NSObject

+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSArray<JQKPaymentInfo *> *)allPaymentInfos;
+ (NSArray<JQKPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<JQKPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (JQKPaymentInfo *)successfulPaymentInfo;
+ (NSArray<JQKPaymentInfo *> *)allUnsuccessfulPaymentInfos;

+ (BOOL)isPaid;

+ (NSString *)accessId;
+ (NSString *)userId;
+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (JQKDeviceType)deviceType;
+ (BOOL)isIpad;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;
+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (UIViewController *)currentVisibleViewController;

+ (NSString *)getIPAddress;
+ (NSString *)currentTimeString;
+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;
//+ (void)setDefaultPrice;
+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(id)params;
+ (NSString *)encodeVideoUrlWithVideoUrlStr:(NSString *)videoUrlStr;
@end
