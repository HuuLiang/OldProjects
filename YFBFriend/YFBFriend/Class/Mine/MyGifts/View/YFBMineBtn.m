//
//  YFBMineBtn.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineBtn.h"

@implementation YFBMineBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    return CGRectMake(CGRectGetWidth(contentRect) - CGRectGetHeight(contentRect)*0.55, contentRect.origin.y, CGRectGetHeight(contentRect)*0.55, CGRectGetHeight(contentRect)*0.4);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    if ([YFBUtil deviceType] < YFBDeviceType_iPhone5) {
        return CGRectMake(0, contentRect.origin.y - 3, CGRectGetWidth(contentRect) - (CGRectGetWidth(imageRect)), CGRectGetHeight(imageRect) + 6);
    }
    return CGRectMake(0,contentRect.origin.y , CGRectGetWidth(contentRect) - (CGRectGetWidth(imageRect)), CGRectGetHeight(imageRect));
}

@end
