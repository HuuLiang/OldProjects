//
//  YFBBlagGiftView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBlagGiftView.h"
#import "YFBGiftPopView.h"
#import "YFBGiftManager.h"

@interface YFBBlagGiftView ()
{
    UILabel *_titileLabel;
    UILabel *_subTitleLabel;
    UIImageView *_headerImageView;
    UIButton *_sendBtn;
    YFBGiftPopView *_popView;
}
@property (nonatomic) YFBGiftInfo *giftInfo;
@end

@implementation YFBBlagGiftView
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_pop_back_image"]];
        backImage.userInteractionEnabled = YES;
        [self addSubview:backImage];
        
        UIImageView *startImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_pop_star_image"]];
        [self addSubview:startImage];
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.forceRoundCorner = YES;
        _headerImageView.layer.borderColor = kColor(@"#b96ad7").CGColor;
        _headerImageView.layer.borderWidth = kWidth(4);
        [self addSubview:_headerImageView];
        
        
        _titileLabel = [[UILabel alloc] init];
        _titileLabel.font = kFont(16);
        _titileLabel.textColor = kColor(@"#333333");
        _titileLabel.textAlignment = NSTextAlignmentCenter;
        _titileLabel.backgroundColor = [UIColor clearColor];
        [backImage addSubview:_titileLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kFont(12);
        _subTitleLabel.textColor = kColor(@"#999999");
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        [backImage addSubview:_subTitleLabel];
        
        _popView = [[YFBGiftPopView alloc] initWithGiftInfos:nil WithGiftViewType:YFBGiftPopViewTypeBlag];
        [backImage addSubview:_popView];
        @weakify(self);
        _popView.sendGiftAction = ^(YFBGiftInfo * obj) {
            @strongify(self);
            self.giftInfo = obj;
        };
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundColor:kColor(@"#f3b050")];
        _sendBtn.layer.cornerRadius = kWidth(38);
        _sendBtn.clipsToBounds = YES;
        _sendBtn.titleLabel.font = kFont(15);
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"打赏礼物" forState:UIControlStateNormal];
        [_sendBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.sendGiftAction && self.giftInfo) {
                self.sendGiftAction(self.giftInfo);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [backImage addSubview:_sendBtn];
        
        {
            [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(self.mas_bottom).offset(-kWidth(720));
            }];
            
            [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.bottom.equalTo(backImage.mas_top).offset(kWidth(60));
            }];
            
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backImage);
                make.top.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
            
            [_titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(backImage);
                make.top.equalTo(backImage.mas_top).offset(kWidth(104));
                make.height.mas_equalTo(kWidth(32));
            }];

            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titileLabel.mas_bottom).offset(kWidth(26));
                make.centerX.equalTo(backImage);
                make.size.mas_equalTo(CGSizeMake(kWidth(440), kWidth(48)));
            }];
            
            [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backImage);
                make.top.equalTo(_subTitleLabel.mas_bottom).offset(kWidth(22));
                make.size.mas_equalTo(CGSizeMake(kWidth(620), kWidth(360)));
            }];
            
            [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backImage);
                make.bottom.equalTo(backImage.mas_bottom).offset(kWidth(-24));
                make.size.mas_equalTo(CGSizeMake(kWidth(500), kWidth(76)));
            }];
        }
        
    }
    return self;
}

- (void)startSelectedDefaultIndexPath {
    [_popView startSelectedDefaultIndexPath];
}

- (void)setSendTitle:(NSString *)sendTitle {
    _sendTitle = sendTitle;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@向你索要礼物",sendTitle]];
    [attribute setAttributes:@{NSForegroundColorAttributeName : kColor(@"#fd5c61")} range:NSMakeRange(0, sendTitle.length)];
    _titileLabel.attributedText = attribute.copy;
}

- (void)setSendSubTitle:(NSString *)sendSubTitle {
    _sendSubTitle = sendSubTitle;
    _subTitleLabel.text = sendSubTitle;
}

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _popView.diamondCount = diamondCount;
}

@end
