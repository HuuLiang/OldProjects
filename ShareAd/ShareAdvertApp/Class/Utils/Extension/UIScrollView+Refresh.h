//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)SA_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)SA_triggerPullToRefresh;
- (void)SA_endPullToRefresh;

- (void)SA_addPagingRefreshWithHandler:(void (^)(void))handler;

- (void)SA_addPagingRefreshWithNotice:(NSString *)notiStr Handler:(void (^)(void))handler;

- (void)SA_pagingRefreshNoMoreData;

@end
