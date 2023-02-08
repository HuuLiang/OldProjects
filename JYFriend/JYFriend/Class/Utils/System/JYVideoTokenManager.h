//
//  JYVideoTokenManager.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JYVideoTokenCompletionHandler)(BOOL success, NSString *token, NSString *userId);

@interface JYVideoTokenManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTokenWithCompletionHandler:(JYVideoTokenCompletionHandler)completionHandler;

- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink;

@end
