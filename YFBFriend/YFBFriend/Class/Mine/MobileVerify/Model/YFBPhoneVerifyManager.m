//
//  YFBPhoneVerifyManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPhoneVerifyManager.h"

@implementation YFBPhoneVerifyManager

+ (instancetype)manager {
    static YFBPhoneVerifyManager *_phoneManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _phoneManager = [[YFBPhoneVerifyManager alloc] init];
    });
    return _phoneManager;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)sendVerifyNumberWithMobileNumber:(NSString *)phoneNumber handler:(void (^)(BOOL))handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"mobile":phoneNumber};
    BOOL success = [self requestURLPath:YFB_SENDVERIFY_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (handler) {
            handler(respStatus == QBURLResponseSuccess);
        }
    }];
    
    return success;
}

- (BOOL)mobileVerifyWithVerifyCode:(NSString *)verifyCode handler:(void (^)(BOOL))handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"mobile":[YFBUser currentUser].phoneNumber,
                             @"verifyCode":verifyCode};
    BOOL success = [self requestURLPath:YFB_MOBILEVERIFY_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    
    return success;
}

@end
