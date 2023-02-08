//
//  JFUserAccessModel.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFUserAccessModel.h"

@implementation JFUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static JFUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[JFUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [JFUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:JF_ACCESS_URL
                          withParams:@{@"userId":userId,@"accessId":[JFUtil accessId]}
                     responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    BOOL success = NO;
                    if (respStatus == QBURLResponseSuccess) {
                        NSString *resp = self.response;
                        success = [resp isEqualToString:@"SUCCESS"];
                        if (success) {
                            DLog(@"Record user access!");
                        }
                    }
                }];
    return ret;
}


@end
