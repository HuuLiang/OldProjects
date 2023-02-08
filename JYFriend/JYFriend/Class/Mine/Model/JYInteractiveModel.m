//
//  JYInteractiveModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYInteractiveModel.h"

@implementation JYInteractiveUser


@end


@implementation JYInteractiveResponse

- (Class)userListElementClass {
    return [JYInteractiveUser class];
}

@end

@implementation JYInteractiveModel

+ (Class)responseClass {
    return [JYInteractiveResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchInteractiveInfoWithType:(JYMineUsersType)type CompletionHandler:(QBCompletionHandler)handler {
    
    NSDictionary *params = nil;
    if (type == JYMineUsersTypeFollow) {
        params = @{@"receiveUserId":[JYUser currentUser].userId,
                   @"msgType":@"FOLLOW"};
    } else if (type == JYMineUsersTypeFans) {
        params = @{@"sendUserId":[JYUser currentUser].userId,
                   @"msgType":@"FOLLOW"};
    } else if (type == JYMineUsersTypeVisitor) {
        params = @{@"receiveUserId":[JYUser currentUser].userId,
                   @"msgType":@"VISIT"};
    }
    
    
    BOOL success = [self requestURLPath:JY_INTERACTIVE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYInteractiveResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.userList);
        }
        
    }];
    return success;
}

@end
