//
//  JYNearPersonBtn.m
//  JYFriend
//
//  Created by ylz on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearPersonBtn.h"

@implementation JYNearPersonBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
  CGRect rect =  [super imageRectForContentRect:contentRect];
 
    rect = CGRectMake(rect.origin.x /[self scale], rect.origin.y /[self scale], rect.size.width *[self scale], rect.size.height *[self scale]);
    return rect;

}

- (CGFloat)scale {
    
    return kScreenWidth*0.9/375.;
}

@end
