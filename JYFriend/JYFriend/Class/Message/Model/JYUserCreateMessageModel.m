//
//  JYUserGreetMessageModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYUserCreateMessageModel.h"

@implementation JYRobotReplyMsgs
@end

@implementation JYReplyRobot
- (Class)dialogMsgsElementClass {
    return [JYRobotReplyMsgs class];
}
@end



@implementation JYUserCreateMessageResponse
- (Class)robotMsgsElementClass {
    return [JYReplyRobot class];
}
@end

@implementation JYUserGreetModel

+ (Class)responseClass {
    return [JYUserCreateMessageResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchRobotsReplyMessagesWithBatchRobotId:(NSArray *)userIdList CompletionHandler:(QBCompletionHandler)handler {
    
    NSString *str = [userIdList componentsJoinedByString:@"|"];
    
    NSDictionary *params = @{@"sendUserId":[JYUser currentUser].userId,
                             @"receiveUserId":str};
    
    BOOL success = [self requestURLPath:JY_BATCHGREET_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYUserCreateMessageResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.robotMsgs);
        }
    }];
    return success;
}
@end


@implementation JYSendMessageModel
+ (Class)responseClass {
    return [JYUserCreateMessageResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchRebotReplyMessagesWithRobotId:(NSString *)receiverId
                                       msg:(NSString *)message
                               ContentType:(NSString *)contentType
                                   msgType:(JYUserCreateMessageType)type
                         CompletionHandler:(QBCompletionHandler)handler {
    NSString *msgType = nil;
    if (type == JYUserCreateMessageTypeGreet) {
        msgType = @"GREET";
        message = @"用户主动向机器人打了个招呼";;
    } else if (type == JYUserCreateMessageTypeFollow) {
        msgType = @"FOLLOW";
        message = @"我关注了你哦";
    } else if (type == JYUserCreateMessageTypeChat) {
        msgType = @"CHAT";
    }
    
    NSDictionary *params = @{@"msg":message,
                             @"sendUserId":[JYUser currentUser].userId ? : @"",
                             @"receiveUserId":receiverId ? : @"",
                             @"msgType":msgType,
                             @"contentType":contentType};
    
    BOOL success = [self requestURLPath:JY_MESSAGECREATE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYUserCreateMessageResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.robotMsgs);
        }
    }];
    
    return success;
}
@end



