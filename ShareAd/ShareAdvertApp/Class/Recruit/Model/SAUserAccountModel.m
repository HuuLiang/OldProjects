//
//  SAUserAccountModel.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAUserAccountModel.h"
#import "SAReqManager.h"

@implementation SAUserAccountDetailModel

@end

@implementation SAUserAccountModel

- (Class)accountClass {
    return [SAUserAccountDetailModel class];
}

+ (instancetype)account {
    static SAUserAccountModel *_accountModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountModel = [[SAUserAccountModel alloc] init];
    });
    return _accountModel;
}

- (void)refreshAccountInfo {
    [[SAReqManager manager] fetchUserAccountInfoWithClass:[SAUserAccountModel class] handler:^(BOOL success, SAUserAccountModel * obj) {
        if (success) {
            [SAUserAccountModel account].account = obj.account;
            [SAUser user].amount = [SAUserAccountModel account].account.amount;
            [[SAUser user] update];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSARefreshAccountInfoNotification object:nil];
        }
    }];
}

@end
