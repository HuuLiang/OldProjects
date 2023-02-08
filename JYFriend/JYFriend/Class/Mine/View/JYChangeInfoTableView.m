//
//  JYChangeInfoTableView.m
//  JYFriend
//
//  Created by ylz on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYChangeInfoTableView.h"

@implementation JYChangeInfoTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
    if (![view isKindOfClass:[UITextField class]] && ![view isKindOfClass:[UITextView class]]) {
        [self endEditing:YES];
        return self;
    }
    return view;
}

@end
