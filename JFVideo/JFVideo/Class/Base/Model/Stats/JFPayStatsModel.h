//
//  JFPayStatsModel.h
//  JFuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFStatsBaseModel.h"

@interface JFPayStatsModel : JFStatsBaseModel

- (BOOL)statsPayWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos completionHandler:(JFCompletionHandler)completionHandler;

@end
