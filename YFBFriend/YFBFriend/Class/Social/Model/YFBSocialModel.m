//
//  YFBSocialModel.m
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBSocialModel.h"

@implementation YFBCommentModel
@end


@implementation YFBSocialServiceModel
@end


@implementation YFBSocialInfo
- (Class)commentsElementClass {
    return [YFBCommentModel class];
}
- (Class)serviceListsElementClass {
    return [YFBSocialServiceModel class];
}

+ (NSArray *)transients {
    return @[@"nickName",@"portraitUrl",@"servNum",@"star",@"describe",@"imgUrl1",@"imgUrl2",@"imgUrl3",@"weixin",@"serviceLists",@"comments",@"needShowButton",@"showAllDesc"];
}

@end


@implementation YFBSocialResponse
- (Class)cityServicesElementClass {
    return [YFBSocialInfo class];
}
@end


@implementation YFBSocialModel

+ (Class)responseClass {
    return [YFBSocialResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchSocialContentWithType:(YFBSocialType)socialType CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"type":@(socialType)
                             };
    BOOL success = [self requestURLPath:YFB_CITYSERVICE_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBSocialResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.cityServices);
        }
    }];
    return success;
}

@end
