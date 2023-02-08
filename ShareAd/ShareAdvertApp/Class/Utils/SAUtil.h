//
//  SAUtil.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAUtil : NSObject

//设备激活
//+ (NSString *)accessId;

+ (NSString *)UUID;
+ (BOOL)isRegisteredUUID;
+ (void)setRegisteredWithUUID:(NSString *)uuid;

//用户登录状态
+ (BOOL)checkUserIsLogin;
//获取用户账户信息
+ (void)fetchAccountInfo;

//设备类型
+ (BOOL)isIpad;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (SADeviceType)deviceType;

//图片加密
+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

//时间转换
+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat;
+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat;
+ (NSString *)compareCurrentTime:(NSTimeInterval)compareTimeInterval;

+ (BOOL)isFirstDay;
+ (BOOL)isToday;


+ (float)getVideoLengthWithVideoUrl:(NSURL *)videoUrl;

@end
