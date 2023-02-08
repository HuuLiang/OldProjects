//
//  YFBGiftManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftManager.h"

@implementation YFBGiftInfo

@end


@implementation YFBGiftResponse
- (Class)giftListElementClass {
    return [YFBGiftInfo class];
}
@end


@implementation YFBGiftManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBGiftResponse class];
}

+ (instancetype)manager {
    static YFBGiftManager *_giftModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _giftModel = [[YFBGiftManager alloc] init];
    });
    return _giftModel;
}

- (void)getGiftListCache {
    if (self.giftList.count == 0) {
        [self fetchGiftListWithCompletionHandler:^(BOOL success, NSArray <YFBGiftInfo *> *obj) {
            if (success) {
                _giftList = obj;
            } else {
                [self performSelector:@selector(getGiftListCache) withObject:nil afterDelay:30];
            }
        }];
    }
}

- (BOOL)fetchGiftListWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_GIFTLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YFBGiftResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.giftList);
        }
        
    }];
    return success;
}


@end
