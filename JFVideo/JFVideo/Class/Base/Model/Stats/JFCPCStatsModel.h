//
//  JFCPCStatsModel.h
//  JFuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFStatsBaseModel.h"

@interface JFCPCStatsModel : JFStatsBaseModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos
             completionHandler:(JFCompletionHandler)completionHandler;

@end
