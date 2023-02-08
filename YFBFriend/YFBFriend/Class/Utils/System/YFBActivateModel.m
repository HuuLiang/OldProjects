//
//  YFBActivateModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBActivateModel.h"

@implementation YFBActivateResponse

@end

@implementation YFBActivateModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBActivateResponse class];
}

+ (instancetype)manager {
    static YFBActivateModel *_activateModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _activateModel = [[YFBActivateModel alloc] init];
    });
    return _activateModel;
}

- (void)activateWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"versionNo":YFB_REST_APP_VERSION,
                             @"appId":YFB_REST_APPID};
    
    [self requestURLPath:YFB_ACTIVATION_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBActivateResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.uuid);
        }
    }];
}

@end
