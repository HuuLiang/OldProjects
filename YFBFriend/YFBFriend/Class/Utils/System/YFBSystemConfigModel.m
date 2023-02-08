//
//  YFBSystemConfigModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSystemConfigModel.h"

@implementation YFBSystemConfigInfo
@end

@implementation YFBSystemConfigReponse

- (Class)configClass {
    return [YFBSystemConfigInfo class];
}

@end


@implementation YFBSystemConfigModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBSystemConfigReponse class];
}

+ (instancetype)defaultConfig {
    static YFBSystemConfigModel *_defaultConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfig = [[YFBSystemConfigModel alloc] init];
    });
    return _defaultConfig;
}

- (void)fetchSystemConfigInfoWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"versionNo":YFB_REST_APP_VERSION,
                             @"appId":YFB_REST_APPID,
                             @"type":@(2)};
    
    [self requestURLPath:YFB_SYSTEM_CONFIG_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
     {
         YFBSystemConfigReponse *resp = nil;
         if (respStatus == QBURLResponseSuccess) {
             resp = self.response;
         }
         if (handler) {
             handler(respStatus == QBURLResponseSuccess,resp.config);
         }
     }];
}


@end
