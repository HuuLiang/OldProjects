//
//  KbUserAccessModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "KbUserAccessModel.h"

@implementation KbUserAccessModel

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static KbUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[KbUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)requestUserAccess {
    NSString *userId = [KbUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:KB_USER_ACCESS_URL
                         withParams:@{@"userId":userId,@"accessId":[KbUtil accessId]}
                    responseHandler:^(KbURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        BOOL success = NO;
        if (respStatus == KbURLResponseSuccess) {
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
