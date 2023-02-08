//
//  JFErrorHandler.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFErrorHandler.h"
#import <QBNetworking/QBURLRequest.h>

NSString *const kNetworkErrorNotification = @"LTNetworkErrorNotification";
NSString *const kNetworkErrorCodeKey = @"LTNetworkErrorCodeKey";
NSString *const kNetworkErrorMessageKey = @"LTNetworkErrorMessageKey";

@implementation JFErrorHandler

+ (instancetype)sharedHandler {
    static JFErrorHandler *_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[JFErrorHandler alloc] init];
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
        JFShowError(@"网络数据返回失败");
    } else if (resp == QBURLResponseFailedByNetwork) {
        JFShowError(@"网络错误，请检查网络连接");
    }
}


@end
