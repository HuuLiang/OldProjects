//
//  JYDetailBottomButton.m
//  JYFriend
//
//  Created by ylz on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYDetailBottomButton.h"

@interface JYDetailBottomButton ()

@property (nonatomic,retain) UIView *lineView;
@end

@implementation JYDetailBottomButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -kWidth(18), 0, 0);
    }
    return self;
}

- (UIView *)lineView {
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self addSubview:_lineView];
    {
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-1);
        make.height.mas_equalTo(self).multipliedBy(0.45);
        make.width.mas_equalTo(1);
    }];
    }
    
    return _lineView;
}

- (void)setHasLine:(BOOL)hasLine {
    _hasLine = hasLine;
    if (hasLine) {
        self.lineView.hidden = NO;
    }else {
        _lineView.hidden = YES;
    }
}


@end
