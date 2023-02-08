//
//  JFErrorHandler.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFErrorHandler : NSObject

+ (instancetype)sharedHandler;
- (void)initialize;

@end

extern NSString *const kNetworkErrorNotification;
extern NSString *const kNetworkErrorCodeKey;
extern NSString *const kNetworkErrorMessageKey;
