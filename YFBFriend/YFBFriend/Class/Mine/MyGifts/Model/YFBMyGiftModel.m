//
//  YFBMyGiftModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyGiftModel.h"

@implementation YFBGift

@end

@implementation YFBGiftListModel

- (Class)giftListElementClass {
    return [YFBGift class];
}

@end

@implementation YFBUserGift

- (Class)userGiftListElementClass {
    return [YFBGiftListModel class];
}

@end

@implementation YFBMyGiftModel

+ (Class)responseClass {
    return [YFBUserGift class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (void)fetchMyGiftModelWithType:(NSString *)typeString CompleteHandler :(QBCompletionHandler)handler {

    NSDictionary *params = @{@"type" : typeString ,
                             @"token" : [YFBUser currentUser].token ,
                             @"channelNo":YFB_CHANNEL_NO,
                             @"userId" : [YFBUser currentUser].userId};
    [self requestURLPath:YFB_MY_GIFT_URL standbyURLPath:nil withParams:params responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        YFBUserGift *giftList = nil;
        if (respStatus == QBURLResponseSuccess) {
            giftList = self.response;
            if (handler) {
                handler(respStatus == QBURLResponseSuccess,giftList.userGiftList);
            }
        }
    }];

}

@end
