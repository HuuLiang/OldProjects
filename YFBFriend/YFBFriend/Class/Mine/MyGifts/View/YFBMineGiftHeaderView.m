//
//  YFBMineGiftHeaderView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineGiftHeaderView.h"
#import "YFBMineBtn.h"

@interface YFBMineGiftHeaderView ()
{
    UIImageView *_headerImage;
    UILabel *_titleLabel;
    YFBMineBtn *_allGiftBtn;
}

@end

@implementation YFBMineGiftHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _headerImage = [[UIImageView alloc] init];
        _headerImage.forceRoundCorner = YES;
        [self addSubview:_headerImage];
        {
            [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(self).mas_offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(60)));
            }];
        }
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(12);
        _titleLabel.textColor = kColor(@"#999999");
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_headerImage.mas_right).mas_offset(kWidth(18));
                make.centerY.mas_equalTo(_headerImage);
            }];
        }
        _allGiftBtn = [YFBMineBtn buttonWithType:UIButtonTypeCustom];
        [_allGiftBtn setImage:[UIImage imageNamed:@"mine_gift_down_icon"] forState:UIControlStateNormal];
        [_allGiftBtn setImage:[UIImage imageNamed:@"mine_gift_up_icon"] forState:UIControlStateSelected];
        _allGiftBtn.titleLabel.font = kFont(12);
        [_allGiftBtn setTitleColor:kColor(@"#666666") forState:UIControlStateNormal];
        [self addSubview:_allGiftBtn];
        {
            [_allGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).mas_offset(kWidth(-30));
                make.centerY.mas_equalTo(_titleLabel).mas_offset(kWidth(3));
                if ([YFBUtil deviceType] < YFBDeviceType_iPhone5) {
                    make.height.mas_equalTo(kWidth(40));
                }
            }];
        }
        @weakify(self);
        [_allGiftBtn bk_addEventHandler:^(YFBMineBtn *sender) {
            @strongify(self);
            sender.selected = !sender.selected;
            if (self.action) {
                self.action(sender);
            }
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTitle:(NSAttributedString *)title {
    _title = title;
    _titleLabel.attributedText = title;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setAllGift:(NSInteger)allGift {
    _allGift = allGift;
    [_allGiftBtn setTitle:[NSString stringWithFormat:@"共%zd件",allGift] forState:UIControlStateNormal];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        return view;
    }
    CGRect aimRect = _allGiftBtn.frame;
    if (CGRectIsEmpty(aimRect)) {
        return view;
    }
    CGRect expandedRect = CGRectInset(aimRect, -15, -10);
    if (CGRectContainsPoint(expandedRect, point)) {
        return _allGiftBtn;
    }
    return view;
}


@end
