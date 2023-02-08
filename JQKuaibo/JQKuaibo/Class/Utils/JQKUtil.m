//
//  JQKUtil.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "NSDate+Utilities.h"
//#import "JQKPaymentInfo.h"
#import "JQKVideo.h"
#import "JQKApplicationManager.h"
#import "JQKBaseViewController.h"
#import "JQKSystemConfigModel.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

static NSString *const kImageTokenKeyName = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword = @"wafei@#$%^%$^$wfsssfsf";

NSString *const kPaymentInfoKeyName = @"jqkuaibov_paymentinfo_keyname";

static NSString *const kRegisterKeyName = @"jqkuaibov_register_keyname";
static NSString *const kUserAccessUsername = @"jqkuaibov_user_access_username";
static NSString *const kUserAccessServicename = @"jqkuaibov_user_access_service";
static NSString *const kLaunchSeqKeyName = @"jqkuaibov_launchseq_keyname";


@implementation JQKUtil

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<JQKPaymentInfo *> *)allPaymentInfos {
   return [QBPaymentInfo allPaymentInfos];
}

+ (NSArray<JQKPaymentInfo *> *)payingPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusPaying;
    }];
}

+ (NSArray<JQKPaymentInfo *> *)paidNotProcessedPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        JQKPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusNotProcessed;
    }];
}

+ (JQKPaymentInfo *)successfulPaymentInfo {
    return [self.allPaymentInfos bk_match:^BOOL(id obj) {
                JQKPaymentInfo *paymentInfo = obj;
                if (paymentInfo.paymentResult == QBPayResultSuccess) {
                    return YES;
                }
                return NO;
            }];
}

+ (NSArray<JQKPaymentInfo *> *)allUnsuccessfulPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        JQKPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult != QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}


+ (BOOL)isPaid {
//    return YES;
    return [self successfulPaymentInfo] != nil;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
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

+ (JQKDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return JQKDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return JQKDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return JQKDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return JQKDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return JQKDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return JQKDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return JQKDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return JQKDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return JQKDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return JQKDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return JQKDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return JQKDeviceType_iPhone7P;
    }else if ([deviceName rangeOfString:@"iPad"].location == 0){
    
        return JQKDeviceType_iPad;
    } else {
        return JQKDeviceTypeUnknown;
    }
}

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
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

+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
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
            if ([navVC.visibleViewController isKindOfClass:[JQKBaseViewController class]]) {
                JQKBaseViewController *baseVC = (JQKBaseViewController *)navVC.visibleViewController;
                return [baseVC currentIndex];
            }
        }
    }
    return NSNotFound;
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


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)currentTimeString {
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:kDefaultDateFormat];
    return [fomatter stringFromDate:[NSDate date]];
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

//+ (void)setDefaultPrice {
//    [JQKSystemConfigModel sharedModel].payAmount = 35;
//    
//}

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(id)params {
    NSMutableString *standbyUrl = [NSMutableString stringWithString:JQK_STANDBY_BASE_URL];
    [standbyUrl appendString:[url substringToIndex:url.length-4]];
    [standbyUrl appendFormat:@"-%@-%@",JQK_REST_APP_ID,JQK_REST_PV];
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
    NSString *signKey = [JQKSystemConfigModel sharedModel].videoSignKey;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeInterval + (long)[JQKSystemConfigModel sharedModel].expireTime];
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
