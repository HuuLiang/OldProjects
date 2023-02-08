//
//  JYActivateModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation JYActivate


@end

@implementation JYActivateModel

+ (Class)responseClass {
    return [JYActivate class];
}

+ (instancetype)sharedModel {
    static JYActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JYActivateModel alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(JYActivateHandler)handler {
//    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
//                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
//                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
//    
//    NSDictionary *params = @{@"cn":JY_CHANNEL_NO,
//                             @"imsi":@"999999999999999",
//                             @"imei":@"999999999999999",
//                             @"sms":@"00000000000",
//                             @"cw":@(kScreenWidth),
//                             @"ch":@(kScreenHeight),
//                             @"cm":[JYUtil deviceName],
//                             @"mf":[UIDevice currentDevice].model,
//                             @"sdkV":sdkV,
//                             @"cpuV":@"",
//                             @"appV":[JYUtil appVersion],
//                             @"appVN":@"",
//                             @"ccn":JY_PACKAGE_CERTIFICATE,
//                             @"operator":[QBNetworkInfo sharedInfo].carriarName ?: @"",
//                             @"systemVersion":[UIDevice currentDevice].systemVersion};
    
    NSDictionary *params = @{@"channelNo":JY_CHANNEL_NO,
                             @"appVersion":[JYUtil appVersion],
                             @"appId":JY_REST_APPID};
    
    BOOL success = [self requestURLPath:JY_ACTIVATION_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_ACTIVATION_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                            JYActivate *resp;
                            if (respStatus == QBURLResponseSuccess) {
                                resp = self.response;
                            }
                            
                            if (handler) {
                                handler(respStatus == QBURLResponseSuccess , resp.uuid);
                            }
                        }];
    return success;
}


@end
