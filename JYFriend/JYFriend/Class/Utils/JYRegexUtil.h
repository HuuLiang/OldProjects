//
//  JYRegexUtil.h
//  JYFriend
//
//  Created by ylz on 2017/1/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYRegexUtil : NSObject

+ (BOOL)isQQWithString:(NSString *)string;
+ (BOOL)isWechatWithString:(NSString *)string;
+ (BOOL)isPhoneNumberWithString:(NSString *)string;

@end
