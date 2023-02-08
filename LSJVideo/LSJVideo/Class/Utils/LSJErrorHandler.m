//
//  LSJErrorHandler.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJErrorHandler.h"
#import <QBURLRequest.h>

NSString *const kNetworkErrorNotification = @"LTNetworkErrorNotification";
NSString *const kNetworkErrorCodeKey = @"LTNetworkErrorCodeKey";
NSString *const kNetworkErrorMessageKey = @"LTNetworkErrorMessageKey";

@implementation LSJErrorHandler

+ (instancetype)sharedHandler {
    static LSJErrorHandler *_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[LSJErrorHandler alloc] init];
    });
    return _handler;
}

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkError:) name:kNetworkErrorNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onNetworkError:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    QBURLResponseStatus resp = (QBURLResponseStatus)(((NSNumber *)userInfo[kNetworkErrorCodeKey]).unsignedIntegerValue);
    
    if (resp == QBURLResponseFailedByInterface) {
        [[LSJHudManager manager] showHudWithText:@"网络数据返回失败"];
    } else if (resp == QBURLResponseFailedByNetwork) {
        [[LSJHudManager manager] showHudWithText:@"网络错误，请检查网络连接"];
    }
}

@end

