//
//  JYUtil.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "JYApplicationManager.h"
#import "JYAppSpreadBannerModel.h"
#import "JYSpreadBannerViewController.h"
#import "JYAppSpread.h"

static NSString *const kRegisterKeyName           = @"JY_register_keyname";
static NSString *const kUserRegisterKeyName       = @"JY_userRegister_keyname";
static NSString *const kUserAccessUsername        = @"JY_user_access_username";
static NSString *const kUserAccessServicename     = @"JY_user_access_service";
static NSString *const kLaunchSeqKeyName          = @"JY_launchseq_keyname";
static NSString *const kImageTokenKeyName         = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword   = @"wafei@#$%^%$^$wfsssfsf";
static NSString *const kUserVipExpireTimeKeyName  = @"kUserVipExpireTimeKeyName";
static NSString *const kCurrentUserIsSendPackey   = @"kcurrent_user_is_sendPacket_key";

static NSString *const kInteractiveFollowKeyName  = @"kInteractiveFollowKeyName";
static NSString *const kInteractiveFansKeyName  = @"kInteractiveFansKeyName";
static NSString *const kInteractiveVisiterKeyName  = @"kInteractiveVisiterKeyName";

@implementation JYUtil

#pragma mark -- 注册激活

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

//设备激活
+ (NSString *)UUID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegisteredUUID {
    return [self UUID] != nil;
}

+ (void)setRegisteredWithUUID:(NSString *)uuid {
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户注册
+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserRegisterKeyName];
}

+ (BOOL)isRegisteredUserId {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserRegisterKeyName];
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

+ (BOOL)isVip {
    NSDate *expireDate = [self expireDateTime];
    if (expireDate) {
        return [expireDate isLaterThanDate:[NSDate date]];
    } else {
        return NO;
    }
}

+ (NSDate *)expireDateTime {
    NSDate *expireDate = [[NSUserDefaults standardUserDefaults] objectForKey:kUserVipExpireTimeKeyName];
    if (!expireDate) {
        expireDate = [NSDate date];
    }
    return expireDate;
}

+ (void)setVipExpireTime:(NSString *)expireTime {
    NSDate *date = [self dateFromString:expireTime WithDateFormat:kDateFormatShort];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kUserVipExpireTimeKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 图片加密

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

#pragma mark - 设备类型

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
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

+ (JYDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return JYDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return JYDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return JYDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return JYDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return JYDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return JYDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return JYDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return JYDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return JYDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return JYDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return JYDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return JYDeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return JYDeviceType_iPad;
    } else {
        return JYDeviceTypeUnknown;
    }
}

#pragma mark -- app

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[JYApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

+ (void)showSpreadBanner {
    if ([JYAppSpreadBannerModel sharedModel].fetchedSpreads) {
        [self showBanner];
    }else{
        [[JYAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [self showBanner];
            }
        }];
    }
}

+ (void)getSpreadeBannerInfo {
    [[JYAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:nil];
}

+ (void)showBanner {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * uninstalledSpreads = [self getUnInstalledSpreads];
        
        if (uninstalledSpreads.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JYSpreadBannerViewController *spreadVC = [[JYSpreadBannerViewController alloc] initWithSpreads:uninstalledSpreads];
                [spreadVC showInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            });
        }
    });
}

+ (NSArray <JYAppSpread *> *)getUnInstalledSpreads {
    NSArray *spreads = [JYAppSpreadBannerModel sharedModel].fetchedSpreads;
    NSArray *allInstalledAppIds = [[JYApplicationManager defaultManager] allInstalledAppIdentifiers];
    NSArray *uninstalledSpreads = [spreads bk_select:^BOOL(id obj) {
        return ![allInstalledAppIds containsObject:[obj specialDesc]];
    }];
    return uninstalledSpreads;
}

#pragma mark -- 时间

+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (BOOL)shouldRefreshContentWithKey:(NSString *)refreshKey timeInterval:(NSUInteger)timeInterval {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:refreshKey];
    if (!lastDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[self currentDate] forKey:refreshKey];
        return YES;
    } else {
        NSDate *newDate = [self currentDate];
        NSTimeInterval time = [newDate timeIntervalSinceDate:lastDate];
        if (time > timeInterval) {
            [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:refreshKey];
            return YES;
        } else {
            return NO;
        }
    }
}

+ (NSDate *)currentDate {
    return [NSDate date];
}

+ (NSString *)compareCurrentTime:(NSString *)compareDateString
{
    NSDate *compareDate = [self dateFromString:compareDateString WithDateFormat:KDateFormatLong];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (BOOL)isTodayWithKeyName:(NSString *)keyName {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
    if (!lastDate) {
        lastDate = [self currentDate];
        [[NSUserDefaults standardUserDefaults] setObject:lastDate forKey:keyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }
    BOOL isToday = [lastDate isToday];
    if (!isToday) {
        [[NSUserDefaults standardUserDefaults] setObject:[self currentDate] forKey:keyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isToday;
}

#pragma mark -- 其他

+ (id)getValueWithKeyName:(NSString *)keyName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
}

+ (void)setValue:(id)object withKeyName:(NSString *)keyName {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(NSDictionary *)params {
    NSMutableString *standbyUrl = [NSMutableString stringWithString:JY_STANDBY_BASE_URL];
    [standbyUrl appendString:[url substringToIndex:url.length-4]];
    [standbyUrl appendFormat:@"-%@-%@",JY_REST_APPID,JY_REST_PV];
    if (params) {
        for (int i = 0; i<[params allKeys].count; i++) {
            [standbyUrl appendFormat:@"-%@",[params allValues][i]];
        }
    }
    [standbyUrl appendString:@".json"];
    
    return standbyUrl;
}
//判断是否像改用户发送过红包
+ (BOOL)isSendPacketWithUserId:(NSString *)userId {
    if (!userId) {
        return NO;
    }
    NSMutableArray *userIds = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserIsSendPackey];
    if ([userIds containsObject:userId]) {
        return YES;
    }
    return NO;
}
//把发送过红包的用户缓存起来
+ (void)saveSendPacketUserId:(NSString *)userId {
    if (userId == nil) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserIsSendPackey]];
    if (!arr) {
        arr = [NSMutableArray array];
    }
    [arr addObject:userId];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:kCurrentUserIsSendPackey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setInteractiveCount:(NSInteger)count WithUserType:(JYMineUsersType)type {
    NSString *keyName = nil;
    if (type == JYMineUsersTypeFollow) {
        keyName = kInteractiveFollowKeyName;
    } else if (type == JYMineUsersTypeFans) {
        keyName = kInteractiveFansKeyName;
    } else if (type == JYMineUsersTypeVisitor) {
        keyName = kInteractiveVisiterKeyName;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(count) forKey:keyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getInteractiveCountWithUserType:(JYMineUsersType)type {
    NSString *keyName = nil;
    if (type == JYMineUsersTypeFollow) {
        keyName = kInteractiveFollowKeyName;
    } else if (type == JYMineUsersTypeFans) {
        keyName = kInteractiveFansKeyName;
    } else if (type == JYMineUsersTypeVisitor) {
        keyName = kInteractiveVisiterKeyName;
    }
    
    NSInteger count = [[[NSUserDefaults standardUserDefaults] objectForKey:keyName] integerValue];
    return count;
}

//+ (NSUInteger)currentTabPageIndex {
//    LeftSlideViewController *rootVC = (LeftSlideViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([rootVC.mainVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabVC = (UITabBarController *)rootVC.mainVC;
//        if (tabVC.selectedIndex == tabVC.childViewControllers.count - 1) {
//            //论坛
//            return 6;
//        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 2) {
//            //直播
//            return 5;
//        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 3) {
//            //撸点
//            return 4;
//        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 4) {
//            //vipC 3 vipB 3 vipA 2 vipNone 1
//            if ([PPUtil currentVipLevel] == PPVipLevelVipC) {
//                return 3;
//            } else {
//                return [PPUtil currentVipLevel] + 1;
//            }
//        } else if (tabVC.selectedIndex == tabVC.childViewControllers.count - 5) {
//            //vipC null vipB 2 vipA 1 vipNone 0
//            return [PPUtil currentVipLevel];
//        }
//    } else if ([rootVC.leftVC isKindOfClass:[PPNavigationController class]]) {
//        return 7;
//    }
//    return 0;
//}
//
//+ (NSUInteger)currentSubTabPageIndex {
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        UITabBarController *tabVC = (UITabBarController *)rootVC;
//        if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
//            UINavigationController *navVC = (UINavigationController *)tabVC.selectedViewController;
//            if ([navVC.visibleViewController isKindOfClass:[PPBaseViewController class]]) {
//                return NSNotFound;
//            }
//        }
//    }
//    return NSNotFound;
//}

@end
