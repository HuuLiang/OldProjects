//
//  YFBRankModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRankModel.h"
#import "YFBRobot.h"

NSString *const kYFBFriendRankReceiveCountKeyName = @"CHARM_LIST";
NSString *const kYFBFriendRankSendCountKeyName    = @"REGAL_LIST";


@implementation YFBRankFentYunListModel

- (Class)userListElementClass {
    return [YFBRobot class];
}
@end

@implementation YFBRankResponse
- (Class)fengYunListDtoClass {
    return [YFBRankFentYunListModel class];
}
@end


@implementation YFBRankModel
- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBRankResponse class];
}

- (BOOL)fetchRankListInfoWithType:(NSString *)type pageNum:(NSInteger)pageNum CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"type":type,
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"pageNum":@(pageNum)};
    BOOL success = [self requestURLPath:YFB_RANK_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBRankResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.fengYunListDto);
        }
    }];
    return success;
}

@end
