//
//  YFBDetailFooterView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailFooterView.h"

@interface YFBDetailFooterView ()
@property (nonatomic,strong) UIButton *msgButton;
@property (nonatomic,strong) UIButton *greetButton;
@property (nonatomic,strong) UIButton *followButton;
@end

@implementation YFBDetailFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgButton setBackgroundImage:[UIImage imageNamed:@"detail_send_msg"] forState:UIControlStateNormal];
        [self addSubview:_msgButton];
        
        self.greetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"detail_send_greet"] forState:UIControlStateNormal];
        [self addSubview:_greetButton];

        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setBackgroundImage:[UIImage imageNamed:@"detail_send_follow"] forState:UIControlStateNormal];
        [self addSubview:_followButton];
        
        @weakify(self);
        [_msgButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.infoType) {
                self.infoType(YFBFunctionSendMsg);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_greetButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.infoType) {
                self.infoType(YFBFunctionSendGreet);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_followButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.infoType) {
                self.infoType(YFBFunctionSendFollow);
            }
        } forControlEvents:UIControlEventTouchUpInside];

        {
            [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_greetButton.mas_left).offset(-kWidth(40));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
            
            [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_greetButton.mas_right).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
            }];
        }
    }
    return self;
}

@end
