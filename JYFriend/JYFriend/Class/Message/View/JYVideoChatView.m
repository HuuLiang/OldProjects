//
//  JYVideoChatView.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYVideoChatView.h"

@interface JYVideoChatView ()
{
    UIImageView *_headerView;
    UILabel *_nickNameLabel;
    UILabel *_chateStateLabel;
    UIButton *_chatBtn;
}

@end

@implementation JYVideoChatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        _headerView = [[UIImageView alloc] init];;
        _headerView.forceRoundCorner = YES;
        [self addSubview:_headerView];
        {
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self).mas_offset(kWidth(40));
//            make.top.mas_equalTo(self).mas_offset(kWidth(80));
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(kWidth(-160));
            make.size.mas_equalTo(CGSizeMake(kWidth(180), kWidth(180)));
        }];
        }
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        _nickNameLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        [self addSubview:_nickNameLabel];
        {
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView);
            make.top.mas_equalTo(_headerView.mas_bottom).mas_offset(kWidth(20));
        }];
        }
        
        _chateStateLabel = [[UILabel alloc] init];
        _chateStateLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _chateStateLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        [self addSubview:_chateStateLabel];
        {
        [_chateStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nickNameLabel.mas_bottom).mas_offset(kWidth(50.));
            make.centerX.mas_equalTo(_headerView);
        }];
        }
        
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_call_reject_normal"] forState:UIControlStateNormal];
        [self addSubview:_chatBtn];
        {
        [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).mas_offset(kWidth(-140));
            make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(120)));
        }];
        }
        
        @weakify(self);
        [_chatBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            QBSafelyCallBlock(self.action,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [_headerView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    _nickNameLabel.text = nickName;
}

- (void)setChatState:(NSString *)chatState {
    _chatState = chatState;
    _chateStateLabel.text = chatState;
}

@end
