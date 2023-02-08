//
//  SAUtil.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAUtil.h"
#import <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "SAUserAccountModel.h"

static NSString *const SACurrentUserKeyName         = @"SACurrentUserKeyName";

static NSString *const kRegisterKeyName           = @"SA_register_keyname";
static NSString *const kUserRegisterKeyName       = @"SA_userRegister_keyname";
static NSString *const kUserAccessUsername        = @"SA_user_access_username";
static NSString *const kUserAccessServicename     = @"SA_user_access_service";
static NSString *const kImageTokenKeyName         = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword   = @"wafei@#$%^%$^$wfsssfsf";

static NSString *const kSAMessageReplyIsFirstDayKeyName = @"kSAMessageReplyIsFirstDayKeyName";
//static NSString *const kSAMessageReplayTimesKeyName = @"kSAMessageReplayTimesKeyName";
static NSString *const kSAMessageReplayTodayKeyName = @"kSAMessageReplayTodayKeyName";

@implementation SAUtil

#pragma mark -- 设备注册激活

//+ (NSString *)accessId {
//    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
//    if (accessIdInKeyChain) {
//        return accessIdInKeyChain;
//    }
//
//    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
//    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
//    return accessIdInKeyChain;
//}

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


#pragma mark - 判断用户是否登录

+ (BOOL)checkUserIsLogin {
    NSInteger currentUserId = [[SAUser user].userId integerValue];
    return currentUserId > 0;
}

+ (void)fetchAccountInfo {
    SAUserAccountModel *accountModel = [[SAUserAccountModel alloc] init];
    [accountModel refreshAccountInfo];
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

+ (SADeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return SADeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return SADeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return SADeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return SADeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return SADeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return SADeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return SADeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return SADeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return SADeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return SADeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return SADeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return SADeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return SADeviceType_iPad;
    } else {
        return SADeviceTypeUnknown;
    }
}

#pragma mark - 图片加密

+ (NSString *)imageToken {
    NSString *imageToken = [[NSUserDefaults standardUserDefaults] objectForKey:kImageTokenKeyName];
    if (!imageToken) {
        return nil;
    }
    return nil;
//    return [imageToken decryptedStringWithPassword:kImageTokenCryptPassword];
}


+ (void)setImageToken:(NSString *)imageToken {
    if (imageToken) {
//        imageToken = [imageToken encryptedStringWithPassword:kImageTokenCryptPassword];
        [[NSUserDefaults standardUserDefaults] setObject:imageToken forKey:kImageTokenKeyName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kImageTokenKeyName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 时间转换

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

+ (NSString *)compareCurrentTime:(NSTimeInterval)compareTimeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:compareTimeInterval];
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    
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

#pragma mark - VIP

+ (BOOL)isFirstDay {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSAMessageReplyIsFirstDayKeyName];
    if (!lastDate) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kSAMessageReplyIsFirstDayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    if ([lastDate isToday]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isToday {
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSAMessageReplayTodayKeyName];
    if (!lastDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kSAMessageReplayTodayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    if ([lastDate isToday]) {
        return YES;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kSAMessageReplayTodayKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return NO;
    }
}

#pragma mark 获取视频的播放时长
+ (float)getVideoLengthWithVideoUrl:(NSURL *)videoUrl {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}


@end
