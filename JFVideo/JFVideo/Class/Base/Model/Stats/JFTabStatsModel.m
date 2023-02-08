//
//  JFTabStatsModel.m
//  JFuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFTabStatsModel.h"

@implementation JFTabStatsModel

- (BOOL)statsTabWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos
             completionHandler:(JFCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        SafelyCallBlock4(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:JF_STATS_TAB_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock4(completionHandler, respStatus == QBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
