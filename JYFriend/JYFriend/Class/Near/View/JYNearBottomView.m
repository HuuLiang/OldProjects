
//
//  JYNearBottomView.m
//  JYFriend
//
//  Created by ylz on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearBottomView.h"

@interface JYNearBottomView ()
{
    UILabel *_bottomLabel;
    UIButton *_notarizeBtn;
}

@end

@implementation JYNearBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.backgroundColor = [UIColor whiteColor];
        _bottomLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_bottomLabel];
        {
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(kWidth(30.));
            make.height.mas_equalTo(kWidth(42.));
        }];
        }
        
        _notarizeBtn = [[UIButton alloc] init];
        _notarizeBtn.layer.cornerRadius = 5.;
        _notarizeBtn.clipsToBounds = YES;
        [_notarizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#e147a5"]];
        [_notarizeBtn setTitle:@"确定" forState:UIControlStateNormal];
        _notarizeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
        [self addSubview:_notarizeBtn];
        {
        [_notarizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).mas_offset(kWidth(-30));
            make.width.mas_equalTo(kWidth(130.));
            make.height.mas_equalTo(kWidth(60.));
        }];
        }
        @weakify(self);
        [_notarizeBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.action) {
                self.action(sender);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        }
        
        
    }
    return self;
}

- (void)setPersonNumber:(NSInteger)personNumber {
    _personNumber = personNumber;
    _bottomLabel.text = [NSString stringWithFormat:@"已经选中%ld人,确定给她们打招呼吗?",personNumber];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        return view;
    }
    CGRect bottomFrame = _notarizeBtn.frame;
    if (CGRectIsEmpty(bottomFrame)) {
        return view;
    }
    
    CGRect expandedFrame = CGRectInset(bottomFrame, -10, -10);
    
    if (CGRectContainsPoint(expandedFrame, point)) {
        return _notarizeBtn;
    }
    
    return view;
}


@end
