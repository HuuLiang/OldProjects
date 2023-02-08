//
//  JFPayStatsModel.m
//  JFuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPayStatsModel.h"

@implementation JFPayStatsModel

- (BOOL)statsPayWithStatsInfos:(NSArray<JFStatsInfo *> *)statsInfos completionHandler:(JFCompletionHandler)completionHandler {
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos shouldIncludeStatsType:NO];
    if (params.count == 0) {
        SafelyCallBlock4(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:JF_STATS_PAY_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock4(completionHandler, respStatus==QBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
