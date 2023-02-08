//
//  JYNextButton.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNextButton.h"

@implementation JYNextButton

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(void))handler {
    self = [super init];
    if (self) {
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#E147A5"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithHexString:@"#E147A5"];
        self.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        
        [self bk_addEventHandler:^(id sender) {
            handler();
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

@end
