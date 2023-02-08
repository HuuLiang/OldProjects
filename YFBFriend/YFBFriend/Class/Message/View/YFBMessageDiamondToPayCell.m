//
//  YFBMessageDiamondToPayCell.m
//  YFBFriend
//
//  Created by Liang on 2017/4/25.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageDiamondToPayCell.h"

@interface YFBMessageDiamondToPayCell ()
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBMessageDiamondToPayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = kColor(@"#F94882");
        
        self.contentView.layer.cornerRadius = 3;
        self.contentView.layer.masksToBounds = YES;
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [_payButton setTitle:@"立即充值" forState:UIControlStateNormal];
        _payButton.backgroundColor = kColor(@"#F94882");
        _payButton.titleLabel.font = kFont(15);
        [self.contentView addSubview:_payButton];
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
        
    }
    return self;
}

@end
