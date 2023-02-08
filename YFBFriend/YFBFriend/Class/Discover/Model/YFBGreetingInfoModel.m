//
//  YFBGreetingInfoModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGreetingInfoModel.h"
#import "YFBRobot.h"

#pragma mark - 获取一键打招呼用户

@implementation YFBGreetingInfoResponse
- (Class)userListElementClass {
    return [YFBRobot class];
}
@end

@implementation YFBGreetingInfoModel
- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBGreetingInfoResponse class];
}

- (BOOL)fetchGreetingInfoWithCompletionHandler:(QBCompletionHandler)handler {
    
    NSDictionary *params = @{@"gender":[YFBUser currentUser].userSex == YFBUserSexMale ? @"M" : @"F",
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_GREETINFO_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBGreetingInfoResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.userList);
        }
    }];
    return success;
}
@end
