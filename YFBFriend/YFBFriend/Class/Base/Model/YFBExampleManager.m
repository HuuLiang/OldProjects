//
//  YFBExampleManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBExampleManager.h"

@implementation YFBExampleResponse
- (Class)diamondTplContListElementClass {
    return [YFBExampleResponse class];
}

- (Class)giftTplContListElementClass {
    return [YFBExampleResponse class];
}

- (Class)vipTplContListElementClass {
    return [YFBExampleResponse class];
}

@end


@implementation YFBExampleManager

+ (instancetype)manager {
    static YFBExampleManager *_exampleManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _exampleManager = [[YFBExampleManager alloc] init];
    });
    return _exampleManager;
}

+ (Class)responseClass {
    return [YFBExampleResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (void)getExampleList {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    [self requestURLPath:YFB_EXAMPLEHISTORY_URL
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBExampleResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
            
            self.diamondExampleSource = resp.diamondTplContList;
            self.vipExampleSource = resp.vipTplContList;
            self.giftExampleSource = resp.giftTplContList;
            
        }
        [self performSelector:@selector(getExampleList) withObject:nil afterDelay:300];
    }];
}

@end
