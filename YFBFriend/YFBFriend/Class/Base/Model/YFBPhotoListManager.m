//
//  YFBPhotoListManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPhotoListManager.h"

@implementation YFBPhoto

@end


@implementation YFBPhotoListResponse
- (Class)userPhotoListElementClass {
    return [YFBPhoto class];
}
@end



@implementation YFBPhotoListManager

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

+ (Class)responseClass {
    return [YFBPhotoListResponse class];
}


+ (instancetype)manager {
    static YFBPhotoListManager *_photoListModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _photoListModel = [[YFBPhotoListManager alloc] init];
    });
    return _photoListModel;
}

- (BOOL)fetchPhotoListWithCompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token};
    
    BOOL success =  [self requestURLPath:YFB_PHOTOLIST_URL
                          standbyURLPath:nil
                              withParams:params
                         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                     {
                         YFBPhotoListResponse *resp = nil;
                         if (respStatus == QBURLResponseSuccess) {
                             resp = self.response;
                         }
                         
                         if (handler) {
                             handler(respStatus == QBURLResponseSuccess,resp.userPhotoList);
                         }
                     }];
    return success;
}

- (BOOL)savePhotoWithUrl:(NSString *)url CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
                             @"userId":[YFBUser currentUser].userId,
                             @"token":[YFBUser currentUser].token,
                             @"photoStr":url};
    
    BOOL success =  [self requestURLPath:YFB_SAVEPHOTO_URL
                          standbyURLPath:nil
                              withParams:params
                         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                     {
                         if (handler) {
                             handler(respStatus == QBURLResponseSuccess,nil);
                         }
                     }];
    return success;
}

@end
