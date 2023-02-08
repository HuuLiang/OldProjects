//
//  YFBPhoneVerifyManager.h
//  YFBFriend
//
//  Created by Liang on 2017/4/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface YFBPhoneVerifyManager : QBEncryptedURLRequest

+ (instancetype)manager;

- (BOOL)sendVerifyNumberWithMobileNumber:(NSString *)phoneNumber handler:(void(^)(BOOL success))handler;

- (BOOL)mobileVerifyWithVerifyCode:(NSString *)verifyCode handler:(void(^)(BOOL success))handler;

@end
