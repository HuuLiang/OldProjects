//
//  KbActivateModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "KbActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation KbActivateModel

+ (instancetype)sharedModel {
    static KbActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[KbActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(KbActivateHandler)handler {
    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    
    NSDictionary *params = @{@"cn":KB_CHANNEL_NO,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"sms":@"00000000000",
                             @"cw":@(mainWidth),
                             @"ch":@(mainHeight),
                             @"cm":[KbUtil deviceName],
                             @"mf":[UIDevice currentDevice].model,
                             @"sdkV":sdkV,
                             @"cpuV":@"",
                             @"appV":KB_REST_APP_VERSION,
                             @"appVN":@"",
                             @"ccn":KB_PACKAGE_CERTIFICATE,
                             @"operator":[KbNetworkInfo sharedInfo].carriarName ?: @""
                             };
    
    BOOL success = [self requestURLPath:KB_ACTIVATE_URL withParams:params responseHandler:^(KbURLResponseStatus respStatus, NSString *errorMessage) {
        NSString *userId;
        if (respStatus == KbURLResponseSuccess) {
            NSString *resp = self.response;
            NSArray *resps = [resp componentsSeparatedByString:@";"];
            
            NSString *success = resps.firstObject;
            if ([success isEqualToString:kSuccessResponse]) {
                userId = resps.count == 2 ? resps[1] : nil;
            }
        }
        
        if (handler) {
            handler(respStatus == KbURLResponseSuccess && userId, userId);
        }
    }];
    return success;
}

@end
