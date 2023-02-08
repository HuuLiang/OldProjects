//
//  JFUtil.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "NSDate+Utilities.h"
#import "JQKApplicationManager.h"
#import "JFBaseViewController.h"
#import "JFSystemConfigModel.h"

NSString *const kPaymentInfoKeyName             = @"jf_paymentinfo_keyname";

static NSString *const kLaunchSeqKeyName        = @"jf_launchseq_keyname";
static NSString *const kRegisterKeyName         = @"jf_register_keyname";
static NSString *const kUserAccessUsername      = @"jf_user_access_username";
static NSString *const kUserAccessServicename   = @"jf_user_access_service";

static NSString *const kVipUserKeyName          = @"jf_isvip_userkey";

static NSString *const kImageTokenKeyName = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword = @"wafei@#$%^%$^$wfsssfsf";

@implementation JFUtil

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (JFDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return JFDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return JFDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return JFDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return JFDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return JFDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return JFDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return JFDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return JFDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return JFDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return JFDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return JFDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return JFDeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return JFDeviceType_iPad;
    } else {
        return JFDeviceTypeUnknown;
    }
}

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (void)registerVip {
    [[NSUserDefaults standardUserDefaults] setObject:IS_VIP forKey:kVipUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isVip {
//    return YES;
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVipUserKeyName] isEqualToString:IS_VIP];
}

+ (NSString *)imageToken {
    NSString *imageToken = [[NSUserDefaults standardUserDefaults] objectForKey:kImageTokenKeyName];
    if (!imageToken) {
        return nil;
    }
    
    return [imageToken decryptedStringWithPassword:kImageTokenCryptPassword];
}

+ (void)setImageToken:(NSString *)imageToken {
    if (imageToken) {
        imageToken = [imageToken encryptedStringWithPassword:kImageTokenCryptPassword];
        [[NSUserDefaults standardUserDefaults] setObject:imageToken forKey:kImageTokenKeyName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kImageTokenKeyName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
}

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[JQKApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos {
//    NSArray<NSDictionary *> *paymentInfoArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
//    
//    NSMutableArray *paymentInfos = [NSMutableArray array];
//    [paymentInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        QBPaymentInfo *paymentInfo = [QBPaymentInfo allPaymentInfos];
//        [paymentInfos addObject:paymentInfo];
//    }];
//    return paymentInfos;
    return [QBPaymentInfo allPaymentInfos];
}

+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusPaying;
    }];
}

+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusNotProcessed;
    }];
}

+ (QBPaymentInfo *)successfulPaymentInfo {
    return [self.allPaymentInfos bk_match:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult == QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}

+ (NSArray<QBPaymentInfo *> *)allUnsuccessfulPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult != QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)currentTimeString {
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:kDefaultDateFormat];
    return [fomatter stringFromDate:[NSDate date]];
}

+ (NSString *)paymentReservedData {
    return [NSString stringWithFormat:@"%@$%@", JF_REST_APPID, JF_CHANNEL_NO];
}

+ (UIViewController *)currentVisibleViewController {
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *selectedVC = tabBarController.selectedViewController;
    if ([selectedVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)selectedVC;
        return navVC.visibleViewController;
    }
    return selectedVC;
}

+ (NSUInteger)currentTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        return tabVC.selectedIndex;
    }
    return 0;
}

+ (NSUInteger)currentSubTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)tabVC.selectedViewController;
            if ([navVC.visibleViewController isKindOfClass:[JFBaseViewController class]]) {
                JFBaseViewController *baseVC = (JFBaseViewController *)navVC.visibleViewController;
                return [baseVC currentIndex];
            }
        }
    }
    return NSNotFound;
}

//+ (void)setDefaultPrice {
//    [JFSystemConfigModel sharedModel].payAmount = 3800;
//    [JFSystemConfigModel sharedModel].payAmountPlus = 5800;
//}

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(id)params {
    NSMutableString *standbyUrl = [NSMutableString stringWithString:JF_STANDBY_BASE_URL];
    [standbyUrl appendString:[url substringToIndex:url.length-4]];
    [standbyUrl appendFormat:@"-%@-%@",JF_REST_APPID,JF_REST_PV];
    if (params) {
        if ([params isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)params;
            for (int i = 0; i<[dic allKeys].count; i++) {
                [standbyUrl appendFormat:@"-%@",[dic allValues][i]];
            }
        }else if ([params isKindOfClass:[NSArray class]]){
            NSArray *para = (NSArray *)params;
            for (int i = 0; i< para.count; i++) {
                [standbyUrl appendFormat:@"-%@",para[i]];
            }
        }
    }
    [standbyUrl appendString:@".json"];
    
    return standbyUrl;
}
#pragma mark - 视频链接加密
//签名原始字符串S = key + url_encode(path) + T 。斜线 / 不编码。

//签名SIGN = md5(S).to_lower()，to_lower指将字符串转换为小写；

+ (NSString *)encodeVideoUrlWithVideoUrlStr:(NSString *)videoUrlStr {
    NSString *signKey = [JFSystemConfigModel sharedModel].videoSignKey;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeInterval + (long)[JFSystemConfigModel sharedModel].expireTime];
    NSString *expireTime = [NSString stringWithFormat:@"%x",[timeStr intValue]];
    
    NSMutableString *newVideoUrl = [[NSMutableString alloc] init];
    [newVideoUrl appendString:[videoUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableString *signString = [[NSMutableString alloc] init];
    [signString appendString:signKey];
    [signString appendString:[self getVideoUrlPath:videoUrlStr]];
    [signString appendString:expireTime];
    
    NSString *signCode = [NSMutableString stringWithFormat:@"%@", [signString.md5 lowercaseString]];
    
    [newVideoUrl appendFormat:@"?sign=%@&t=%@",signCode,expireTime];
    
    return newVideoUrl;
}

+ (NSString *)getVideoUrlPath:(NSString *)videoUrl {
    NSString * string1 = [[videoUrl componentsSeparatedByString:@".com"] lastObject];
    NSString * stirng2 = [[string1 componentsSeparatedByString:@"?"] firstObject];
    NSString *encodingString = [stirng2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodingString;
}


@end
