//
//  JFActivateModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation JFActivateModel

+ (instancetype)sharedModel {
    static JFActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JFActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(JFActivateHandler)handler {
    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    
    NSDictionary *params = @{@"cn":JF_CHANNEL_NO,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"sms":@"00000000000",
                             @"cw":@(kScreenWidth),
                             @"ch":@(kScreenHeight),
                             @"cm":[JFUtil deviceName],
                             @"mf":[UIDevice currentDevice].model,
                             @"sdkV":sdkV,
                             @"cpuV":@"",
                             @"appV":[JFUtil appVersion],
                             @"appVN":@"",
                             @"ccn":JF_PACKAGE_CERTIFICATE,
                             @"operator":[QBNetworkInfo sharedInfo].carriarName ?: @"",
                             @"systemVersion":[UIDevice currentDevice].systemVersion};
    
    BOOL success = [self requestURLPath:JF_ACTIVATION_URL withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        NSString *userId;
        if (respStatus == QBURLResponseSuccess) {
            NSString *resp = self.response;
            NSArray *resps = [resp componentsSeparatedByString:@";"];
            NSString *success = resps.firstObject;
            if ([success isEqualToString:kSuccessResponse]) {
                userId = resps.count == 2 ? resps[1] : nil;
            }
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess && userId, userId);
        }
    }];
    return success;
}


@end
