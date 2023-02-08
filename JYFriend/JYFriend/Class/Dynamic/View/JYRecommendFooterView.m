//
//  JYRecommendFooterView.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRecommendFooterView.h"
#import "JYNextButton.h"

@interface JYRecommendFooterView ()
{
    JYNextButton    *_greetButton;
    UIButton        *_refreshButton;
}
@end

@implementation JYRecommendFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColor(@"#ffffff");
        
        @weakify(self);
        _greetButton = [[JYNextButton alloc] initWithTitle:@"跟她们打个招呼" action:^{
            @strongify(self);
            if (self.recommendAction) {
                self.recommendAction(self);
            }
        }];
        [_greetButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [self addSubview:_greetButton];
        
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setTitle:@"换一换" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:kColor(@"#666666") forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [_refreshButton setImage:[UIImage imageNamed:@"recommend_refresh"] forState:UIControlStateNormal];
        [self addSubview:_refreshButton];
        [_refreshButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.refreshAction) {
                self.refreshAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(frame.size.width *0.55, kWidth(72)));
            }];
            
            [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_greetButton.mas_bottom).offset(kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(24)));
            }];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIEdgeInsets imageInsets = _refreshButton.imageEdgeInsets;
    _refreshButton.imageEdgeInsets = UIEdgeInsetsMake(imageInsets.top,imageInsets.left-kWidth(8),imageInsets.bottom,imageInsets.right+kWidth(8));
    UIEdgeInsets titleInsets = _refreshButton.titleEdgeInsets;
    _refreshButton.titleEdgeInsets = UIEdgeInsetsMake(titleInsets.top,titleInsets.left+kWidth(8),titleInsets.bottom,titleInsets.right-kWidth(8));
}

@end
