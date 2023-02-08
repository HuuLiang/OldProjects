//
//  SAUser.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAUser.h"

#define CurrentUserId 1

@interface SAUser ()
@end

@implementation SAUser

+ (instancetype)user {
    static SAUser *_user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [SAUser findByPK:CurrentUserId];;
        if (!_user) {
            _user = [[SAUser alloc] init];
            _user.pk = CurrentUserId;
            [_user save];
        }
    });
    return _user;
}

- (void)setValueWithObj:(SAUser *)responseUser {
    [responseUser.allProperties enumerateObjectsUsingBlock:^(NSString *  _Nonnull keyName , NSUInteger idx, BOOL * _Nonnull stop) {
        if ([responseUser valueForKey:keyName]) {
            [[SAUser user].allProperties enumerateObjectsUsingBlock:^(NSString *  _Nonnull propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([keyName isEqualToString:propertyName] && ![keyName isEqualToString:@"pk"]) {
                    [[SAUser user] setValue:[responseUser valueForKey:keyName] forKey:propertyName];
                }
            }];
        }
    }];
}
@end
