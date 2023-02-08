//
//  YFBUtil.h
//  YFBFriend
//
//  Created by Liang on 2017/2/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBUtil : NSObject

//设备激活
+ (NSString *)accessId;

+ (NSString *)UUID;
+ (BOOL)isRegisteredUUID;
+ (void)setRegisteredWithUUID:(NSString *)uuid;

//用户登录状态
+ (BOOL)checkUserIsLogin;

//设备类型
+ (BOOL)isIpad;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (YFBDeviceType)deviceType;

//图片加密
+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

//时间转换
+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat;
+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat;
+ (NSString *)compareCurrentTime:(NSTimeInterval)compareTimeInterval;

+(BOOL)isVip;
+ (BOOL)isFirstDay;
+ (BOOL)isToday;


+ (float)getVideoLengthWithVideoUrl:(NSURL *)videoUrl;
@end
