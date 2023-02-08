//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/4.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh.h>

NSString *const kYFBNearRefreshKeyName = @"kYFBNearReRreshKeyName";
NSString *const kYFBRankRefreshKeyName = @"kYFBRankRefreshKeyName";
NSString *const kYFBRecommendRefreshKeyName = @"kYFBRecommendRefreshKeyName";

@implementation UIScrollView (Refresh)

- (void)YFB_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        self.header = refreshHeader;
    }
}

- (void)YFB_triggerPullToRefresh {
    [self.header beginRefreshing];
}

- (void)YFB_endPullToRefresh {
    [self.header endRefreshing];
    [self.footer resetNoMoreData];
}

- (void)YFB_addPagingRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        self.footer = refreshFooter;
    }
}

- (void)YFB_addPagingRefreshWithNotice:(NSString *)notiStr Handler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        [refreshFooter setTitle:notiStr forState:MJRefreshStateIdle];
        self.footer = refreshFooter;
    }
}


- (void)YFB_pagingRefreshNoMoreData {
    [self.footer endRefreshingWithNoMoreData];
}

- (void)YFB_addIsRefreshing {
    if (!self.header) {
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
        [refreshHeader setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
        self.header = refreshHeader;
    }
}
    
- (void)YFB_addVIPNotiRefreshWithHandler:(void (^)(void))handler {
    if (!self.footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        [refreshFooter setTitle:@"升级VIP可观看更多" forState:MJRefreshStateIdle];
        self.footer = refreshFooter;
    }
}



@end
