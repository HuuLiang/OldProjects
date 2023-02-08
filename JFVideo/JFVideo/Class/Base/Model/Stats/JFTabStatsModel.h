//
//  JFTabStatsModel.h
//  JFuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFStatsBaseModel.h"

@interface JFTabStatsModel : JFStatsBaseModel

- (BOOL)statsTabWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos completionHandler:(JFCompletionHandler)completionHandler;

@end
