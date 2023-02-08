//
//  YFBWordsObserve.h
//  YFBFriend
//
//  Created by Liang on 2017/5/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFBMessageModel;

@interface YFBWordsObserve : NSObject

+ (instancetype)observe;

- (void)checkMessageContent:(YFBMessageModel *)messageModel;

@end
