//
//  UIScrollView+Refresh.m
//  PPVideo
//
//  Created by Liang on 16/6/24.
//  Copyright (c) 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)JY_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)JY_triggerPullToRefresh;
- (void)JY_endPullToRefresh;

- (void)JY_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)JY_pagingRefreshNoMoreData;

- (void)JY_addIsRefreshing;

- (void)JY_addVIPNotiRefreshWithHandler:(void (^)(void))handler;

//- (void)JY_addVipDetailNotiWithVipLevel:(PPVipLevel)vipLevel RefreshWithHandler:(void (^)(void))handler;

@end
