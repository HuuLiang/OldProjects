//
//  YFBDiamondLabel.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDiamondLabel.h"

@implementation YFBDiamondLabel

-(void)drawTextInRect:(CGRect)rect{
    
    CGRect frame = CGRectMake(rect.origin.x + 8, rect.origin.y + 5, rect.size.width - 16, rect.size.height -10);
    
    [super drawTextInRect:frame];
    
    
}

@end
