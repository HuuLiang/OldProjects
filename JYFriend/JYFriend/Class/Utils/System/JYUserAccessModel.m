//
//  JYUserAccessModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUserAccessModel.h"

@implementation JYUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static JYUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[JYUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [JYUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:JY_ACCESS_URL
                      standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_ACCESS_URL params:nil]
                          withParams:@{@"userId":userId,@"accessId":[JYUtil accessId]}
                     responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    BOOL success = NO;
                    if (respStatus == QBURLResponseSuccess) {
                        NSString *resp = self.response;
                        success = [resp isEqualToString:@"SUCCESS"];
                        if (success) {
                            QBLog(@"Record user access!");
                        }
                    }
                }];
    return ret;
}


@end
