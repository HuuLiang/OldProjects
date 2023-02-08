//
//  YFBVisiteModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVisiteModel.h"


@implementation YFBVisiteRobotModel
@end


@implementation YFBVisiteResponse
- (Class)userListElementClass {
    return [YFBVisiteRobotModel class];
}
@end


@implementation YFBVisiteModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBVisiteResponse class];
}

+ (instancetype)manager {
    static YFBVisiteModel *_visiteModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _visiteModel = [[YFBVisiteModel alloc] init];
    });
    return _visiteModel;
}

- (BOOL)fetchVisitemeInfoWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_VISITEME_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBVisiteResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp);
        }
    }];
    return success;
}

@end
