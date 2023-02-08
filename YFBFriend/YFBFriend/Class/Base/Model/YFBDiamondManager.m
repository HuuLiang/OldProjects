//
//  YFBDiamondManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondManager.h"

@implementation YFBDiamondInfo

@end


@implementation YFBDiamondResponse
- (Class)diamondPriceConfListElementClass {
    return [YFBDiamondInfo class];
}
@end


@implementation YFBDiamondManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBDiamondResponse class];
}

+ (instancetype)manager {
    static YFBDiamondManager *_diamondModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _diamondModel = [[YFBDiamondManager alloc] init];
    });
    return _diamondModel;
}

- (void)getDiamondListCache {
    if (self.diamonList.count == 0) {
        [self fetchDiamonListWithCompletionHandler:^(BOOL success, NSArray <YFBDiamondInfo *> *obj) {
            if (success) {
                _diamonList = obj;
            } else {
                [self performSelector:@selector(getDiamondListCache) withObject:nil afterDelay:30];
            }
        }];
    }
}

- (BOOL)fetchDiamonListWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success = [self requestURLPath:YFB_DIAMONLIST_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YFBDiamondResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess,resp.diamondPriceConfList);
                        }
                    }];
    return success;
}


@end
