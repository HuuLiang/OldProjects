//
//  YFBDiscoverModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiscoverModel.h"
#import "YFBRobot.h"

NSString *const kYFBFriendDiscoverRecommendKeyName = @"RMD";
NSString *const kYFBFriendDiscoverNearbyKeyName    = @"NEARBY";

@implementation YFBRmdNearByDtoModel
- (Class)userListElementClass {
    return [YFBRobot class];
}
@end

@implementation YFBDiscoverResponse

- (Class)realEvalUserListElementClass {
    return [YFBRobot class];
}

- (Class)rmdNearbyDtoClass {
    return [YFBRmdNearByDtoModel class];
}
@end

@implementation YFBDiscoverModel

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBDiscoverResponse class];
}

- (BOOL)fetchUserInfoWithType:(NSString *)type pageNum:(NSInteger)pageNum CompletionHandler:(void (^)(BOOL, NSArray<YFBRobot *> *, YFBRmdNearByDtoModel *))handler {
    NSDictionary *params = @{@"gender":[YFBUser currentUser].userSex == YFBUserSexMale ? @"M" : @"F",
                             @"type":type,
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"pageNum":@(pageNum)};
    
    BOOL success = [self requestURLPath:YFB_RMDNEARBY_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBDiscoverResponse *resp = nil;
                        NSMutableArray *arr = [NSMutableArray array];
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.realEvalUserList,resp.rmdNearbyDto);
                        }
                    }];
    
    return success;

}

@end
