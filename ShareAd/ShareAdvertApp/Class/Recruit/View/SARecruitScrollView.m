//
//  SARecruitScrollView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitScrollView.h"
#import "SARecruitTagView.h"

@interface SARecruitScrollView ()
@property (nonatomic) UIView *shadowView;
@property (nonatomic) SARecruitTagView *toRecruitView;
@property (nonatomic) SARecruitTagView *allRecruitView;
@property (nonatomic) SARecruitTagView *toBalanceView;
@property (nonatomic) SARecruitTagView *allBalanceView;

@property (nonatomic) UIButton *startRecruitButton;
@property (nonatomic) UIButton *QRCodeRecruitButton;

@property (nonatomic) UILabel *descTitleLabel;
@property (nonatomic) UILabel *firstDescLabel;
@property (nonatomic) UILabel *secondDescLabel;

@end

@implementation SARecruitScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kColor(@"#efefef");
        
        self.shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = kColor(@"#ffffff");
        [self addSubview:_shadowView];
        
        self.toRecruitView = [[SARecruitTagView alloc] init];
        _toRecruitView.tagType = SATagViewTypeTodayRecruit;
        _toRecruitView.count = @"0";
        [self addSubview:_toRecruitView];

        self.allRecruitView = [[SARecruitTagView alloc] init];
        _allRecruitView.tagType = SATagViewTypeAllRecruit;
        _allRecruitView.count = @"0";
        [self addSubview:_allRecruitView];
        
        self.toBalanceView = [[SARecruitTagView alloc] init];
        _toBalanceView.tagType = SATagViewTypeTodayBalance;
        _toBalanceView.count = @"0";
        [self addSubview:_toBalanceView];
        
        self.allBalanceView = [[SARecruitTagView alloc] init];
        _allBalanceView.tagType = SATagViewTypeAllBalance;
        _allBalanceView.count = @"0";
        [self addSubview:_allBalanceView];

        self.startRecruitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startRecruitButton setTitle:@"开始收徒赚钱" forState:UIControlStateNormal];
        [_startRecruitButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _startRecruitButton.titleLabel.font = kFont(14);
        _startRecruitButton.backgroundColor = kColor(@"#FF3366");
        [self addSubview:_startRecruitButton];
        
        self.QRCodeRecruitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QRCodeRecruitButton setTitle:@"二维码收徒" forState:UIControlStateNormal];
        [_QRCodeRecruitButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _QRCodeRecruitButton.titleLabel.font = kFont(14);
        _QRCodeRecruitButton.backgroundColor = kColor(@"#FF3366");
        [self addSubview:_QRCodeRecruitButton];

        self.descTitleLabel = [[UILabel alloc] init];
        _descTitleLabel.font = kFont(15);
        _descTitleLabel.textColor = kColor(@"#333333");
        _descTitleLabel.text = @"邀请好友的奖励包括两部分";
        [self addSubview:_descTitleLabel];
        
        self.firstDescLabel = [[UILabel alloc] init];
        _firstDescLabel.font = kFont(14);
        _firstDescLabel.textColor = kColor(@"#666666");
        _firstDescLabel.text = @"1.注册奖励：您邀请的好友注册后，您会获得3元注册奖励（当好友提现10元后可到账);";
        _firstDescLabel.numberOfLines = 0;
        [self addSubview:_firstDescLabel];
        
        self.secondDescLabel = [[UILabel alloc] init];
        _secondDescLabel.font = kFont(14);
        _secondDescLabel.textColor = kColor(@"#666666");
        _secondDescLabel.text = @"2.好友分成：好友分享文章阅读时还可以获得平台奖励的20%分成，永久有效！好友的好友你还能的10%分成奖励！一共2级30%永久分成奖励！";
        _secondDescLabel.numberOfLines = 0;
        [self addSubview:_secondDescLabel];
        
        @weakify(self);
        [_startRecruitButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.startRecruitAction) {
                self.startRecruitAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_QRCodeRecruitButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.QRCodeRecruitAction) {
                self.QRCodeRecruitAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];

        
        {
            [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kWidth(338));
            }];
            
            [_toRecruitView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(140));
                make.top.equalTo(_shadowView).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(120)));
            }];
            
            [_allRecruitView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-kWidth(140));
                make.top.equalTo(_shadowView).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(120)));
            }];
            
            [_toBalanceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_toRecruitView);
                make.bottom.equalTo(_shadowView.mas_bottom).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(120)));
            }];
            
            [_allBalanceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_allRecruitView);
                make.bottom.equalTo(_shadowView.mas_bottom).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(120)));
            }];
            
            [_startRecruitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_shadowView.mas_bottom).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(612), kWidth(80)));
            }];
            
            [_QRCodeRecruitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_startRecruitButton.mas_bottom).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(612), kWidth(80)));
            }];
            
            [_descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(40));
                make.top.equalTo(_QRCodeRecruitButton.mas_bottom).offset(kWidth(110));
                make.height.mas_equalTo(_descTitleLabel.font.lineHeight);
            }];
            
            [_firstDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(40));
                make.right.equalTo(self.mas_right).offset(-kWidth(40));
                make.top.equalTo(_descTitleLabel.mas_bottom).offset(kWidth(50));
            }];
            
            [_secondDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(40));
                make.right.equalTo(self.mas_right).offset(-kWidth(40));
                make.top.equalTo(_firstDescLabel.mas_bottom).offset(kWidth(20));
            }];
        }
        
    }
    return self;
}

- (void)setToRecruitCount:(NSInteger)toRecruitCount {
    _toRecruitView.tagType = SATagViewTypeTodayRecruit;
    _toRecruitView.count = [NSString stringWithFormat:@"%ld",toRecruitCount];
}

- (void)setAllRecruitCount:(NSInteger)allRecruitCount {
    _allRecruitView.tagType = SATagViewTypeAllRecruit;
    _allRecruitView.count = [NSString stringWithFormat:@"%ld",allRecruitCount];
}

- (void)setToBalanceCount:(NSInteger)toBalanceCount {
    _toBalanceView.tagType = SATagViewTypeTodayBalance;
    _toBalanceView.count = [NSString stringWithFormat:@"%.2f",(float)toBalanceCount/100];
}

- (void)setAllBalanceCount:(NSInteger)allBalanceCount {
    _allBalanceView.tagType = SATagViewTypeAllBalance;
    _allBalanceView.count = [NSString stringWithFormat:@"%.2f",(float)allBalanceCount/100];
}

@end
