//
//  YFBGiftReusableView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftFooterView.h"

@interface YFBGiftFooterView ()
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) UIButton *payButton;//充值
@property (nonatomic) UIButton *sendButton;
@property (nonatomic) UIImageView *diamondImageView;
@property (nonatomic) UILabel *diamondLabel;
@property (nonatomic) YFBGiftPopViewType type;
@end

@implementation YFBGiftFooterView

- (instancetype)initWithGiftType:(YFBGiftPopViewType)type {
    self = [super init];
    if (self) {
        
        self.type = type;
        
        self.pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        
        {
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.height.mas_equalTo(self);
                make.width.mas_equalTo(self).multipliedBy(0.3);
            }];
        }
        
        if (type == YFBGiftPopViewTypeList) {
            self.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.8];
            
            self.diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_gift_diamond_icon"]];
            [self addSubview:_diamondImageView];
            
            self.diamondLabel = [[UILabel alloc] init];
            _diamondLabel.textColor = kColor(@"#ffffff");
            _diamondLabel.font = kFont(14);
            [self addSubview:_diamondLabel];
            
            self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _payButton.titleLabel.font = kFont(12);
            [_payButton setTitleColor:kColor(@"#fd4ca1") forState:UIControlStateNormal];
            [_payButton setTitle:@"充值 >" forState:UIControlStateNormal];
            [self addSubview:_payButton];
            
            @weakify(self);
            [_payButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.payAction) {
                    self.payAction();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            
            
            self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.layer.cornerRadius = kWidth(3);
            _sendButton.clipsToBounds = YES;
            _sendButton.titleLabel.font = kFont(13);
            [_sendButton setTitle:@"赠送" forState:UIControlStateNormal];
            _sendButton.backgroundColor = kColor(@"#ffffff");
            [_sendButton setTitleColor:kColor(@"#FD4CA1") forState:UIControlStateNormal];
            [self addSubview:_sendButton];
            
            [_sendButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.sendAction) {
                    self.sendAction();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            
            {
                [_diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(kWidth(16));
                    make.centerY.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(32)));
                }];
                
                [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(_diamondImageView.mas_right).offset(kWidth(6));
                    make.height.mas_equalTo(kWidth(28));
                }];
                
                [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.mas_centerY);
                    make.left.equalTo(_diamondLabel.mas_right).offset(kWidth(8));
                }];
                
                [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.mas_centerY);
                    make.right.equalTo(self.mas_right).offset(kWidth(-20));
                    make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(52)));
                }];
            }
        } else {
            self.backgroundColor = kColor(@"#FD5C61");
            
            self.diamondLabel = [[UILabel alloc] init];
            _diamondLabel.textColor = kColor(@"#ffffff");
            _diamondLabel.font = kFont(11);
            [self addSubview:_diamondLabel];
            
            {
                [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(kWidth(16));
                    make.centerY.equalTo(self);
                    make.height.mas_equalTo(kWidth(22));
                }];
            }
        }

    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
}

- (void)setPageNumbers:(NSInteger)pageNumbers {
    _pageNumbers = pageNumbers;
    _pageControl.numberOfPages = pageNumbers;
}

- (void)setDiamondCount:(NSInteger)diamondCount{
    _diamondCount = diamondCount;
    if (_type == YFBGiftPopViewTypeBlag) {
        _diamondLabel.text = [NSString stringWithFormat:@"钻石:%zd",diamondCount];
    } else if (_type == YFBGiftPopViewTypeList) {
        _diamondLabel.text = [NSString stringWithFormat:@"%zd",diamondCount];
    }
}

@end
