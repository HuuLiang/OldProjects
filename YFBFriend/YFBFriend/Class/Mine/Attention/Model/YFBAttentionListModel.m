//
//  YFBAttentionListModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionListModel.h"

NSString *const kYFBAttentionListConcernKeyName = @"concern";
NSString *const kYFBAttentionListConcernedKeyName = @"concerned";


@implementation YFBAttentionInfo

@end


@implementation YFBAttentionListResponse
- (Class)userListElementClass {
    return [YFBAttentionInfo class];
}
@end


@implementation YFBAttentionListModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBAttentionListResponse class];
}

- (BOOL)fetchAttentionListWithType:(NSString *)type CompletionHandler:(QBCompletionHandler)handler {
    
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"type":type};
    
    BOOL success = [self requestURLPath:YFB_ATTENTIONLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBAttentionListResponse *resp = nil;
        
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
