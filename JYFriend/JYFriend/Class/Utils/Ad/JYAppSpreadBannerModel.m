//
//  JYAppSpreadBannerModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYAppSpreadBannerModel.h"
#import "JYAppSpread.h"

@implementation JYAppResponse
- (Class)programListElementClass {
    return [JYAppSpread class];
}
@end

@implementation JYAppSpreadBannerModel

+ (instancetype)sharedModel {
    static JYAppSpreadBannerModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JYAppResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:PP_APP_URL
                     standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:PP_APP_URL params:nil]
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    JYAppResponse *resp = nil;
                    if (respStatus == QBURLResponseSuccess) {
                        resp = self.response;
                    }
                    
                    if (handler) {
                        handler(QBURLResponseFailedByInterface,resp.programList);
                    }
                }];
    return ret;
}
@end
