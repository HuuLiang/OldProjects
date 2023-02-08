//
//  YFBCommentCell.m
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBCommentCell.h"

@interface YFBCommentView ()
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *serverLabel;
@property (nonatomic) UILabel *commentLabel;
@property (nonatomic) UIImageView *lineImgV;
@end


@implementation YFBCommentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = kColor(@"#999999");
        _nickLabel.font = kFont(12);
        [self addSubview:_nickLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#B3B3B3");
        _timeLabel.font = kFont(11);
        [self addSubview:_timeLabel];
        
        self.serverLabel = [[UILabel alloc] init];
        _serverLabel.textColor = kColor(@"#B3B3B3");
        _serverLabel.font = kFont(11);
        [self addSubview:_serverLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = kColor(@"#333333");
        _commentLabel.font = kFont(12);
        _commentLabel.numberOfLines = 0;
        [self addSubview:_commentLabel];
        
        self.lineImgV = [[UIImageView alloc] init];
        _lineImgV.backgroundColor = kColor(@"#efefef");
        [self addSubview:_lineImgV];
        
        {
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(20));
                make.left.equalTo(self).offset(kWidth(30));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickLabel);
                make.right.equalTo(self.mas_right).offset(-kWidth(30));
                make.height.mas_equalTo(_timeLabel.font.lineHeight);
            }];
            
            [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(30));
                make.top.equalTo(_nickLabel.mas_bottom).offset(kWidth(10));
                make.height.mas_equalTo(_serverLabel.font.lineHeight);
            }];
            
            [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_serverLabel.mas_bottom).offset(kWidth(26));
                make.left.equalTo(self).offset(kWidth(30));
                make.width.mas_equalTo(kWidth(560));
                make.height.mas_equalTo(32);
            }];
            
            [_lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(30));
                make.bottom.equalTo(self.mas_bottom).offset(-2);
                make.size.mas_equalTo(CGSizeMake(kWidth(560), 1));
            }];
        }

    }
    return self;
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = [nickName stringByReplacingCharactersInRange:NSMakeRange(1, nickName.length-1) withString:@"***"];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setServerOption:(NSString *)serverOption {
    _serverLabel.text = [NSString stringWithFormat:@"服务选项:%@",serverOption];
}

- (void)setCommentStr:(NSString *)commentStr {
    _commentLabel.text = commentStr;
    CGFloat commentContentHeight = [commentStr sizeWithFont:_commentLabel.font maxWidth:kWidth(560)].height;
    [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(commentContentHeight));
    }];
}

@end





@interface YFBCommentCell ()
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *serverLabel;
@property (nonatomic) UILabel *commentLabel;
@property (nonatomic) UIImageView *lineImgV;
@end

@implementation YFBCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.contentView.backgroundColor = kColor(@"#ffffff");
        
        self.nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = kColor(@"#999999");
        _nickLabel.font = kFont(14);
        [self.contentView addSubview:_nickLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#B3B3B3");
        _timeLabel.font = kFont(12);
        [self.contentView addSubview:_timeLabel];
        
        self.serverLabel = [[UILabel alloc] init];
        _serverLabel.textColor = kColor(@"#B3B3B3");
        _serverLabel.font = kFont(12);
        [self.contentView addSubview:_serverLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = kColor(@"#333333");
        _commentLabel.font = kFont(14);
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
        
        self.lineImgV = [[UIImageView alloc] init];
        _lineImgV.backgroundColor = kColor(@"#efefef");
        [self.contentView addSubview:_lineImgV];
        
        {
            [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(kWidth(20));
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(_nickLabel.font.lineHeight);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickLabel);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.height.mas_equalTo(_timeLabel.font.lineHeight);
            }];
            
            [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(_nickLabel.mas_bottom).offset(kWidth(10));
                make.height.mas_equalTo(_serverLabel.font.lineHeight);
            }];
            
            [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_serverLabel.mas_bottom).offset(kWidth(26));
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.width.mas_equalTo(kWidth(690));
                make.height.mas_equalTo(32);
            }];
            
            [_lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
                make.size.mas_equalTo(CGSizeMake(kWidth(560), 1));
            }];
        }

    }
    return self;
}

- (void)setNickName:(NSString *)nickName {
    _nickLabel.text = [nickName stringByReplacingCharactersInRange:NSMakeRange(1, nickName.length-2) withString:@"***"];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setServerOption:(NSString *)serverOption {
    _serverLabel.text = [NSString stringWithFormat:@"服务选项:%@",serverOption];
}

- (void)setCommentStr:(NSString *)commentStr {
    _commentLabel.text = commentStr;
    CGFloat commentContentHeight = [commentStr sizeWithFont:_commentLabel.font maxWidth:kWidth(690)].height;
    [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(commentContentHeight));
    }];
}

@end
