//
//  YFBAttentionTableViewCell.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionTableViewCell.h"

@interface YFBAttentionTableViewCell ()

{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_ageLabel;
    UIImageView *_photoImageView;
    UILabel *_photoLabel;
}

@property (nonatomic,retain) UIButton *attentionBtn;

@end


@implementation YFBAttentionTableViewCell

- (UIButton *)attentionBtn {
    if (_attentionBtn) {
        return _attentionBtn;
    }
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [_attentionBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _attentionBtn.titleLabel.font = kFont(14);
    [self addSubview:_attentionBtn];
    {
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(kWidth(-30));
            make.centerY.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(40)));
        }];
    }
    @weakify(self);
    [_attentionBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        if (self.attentionAction) {
            self.attentionAction();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return _attentionBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_default_avatar_icon"]];
        [self addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).mas_offset(kWidth(30));
                make.top.mas_equalTo(self).mas_offset(kWidth(14));
                make.bottom.mas_equalTo(self).mas_offset(kWidth(-14));
                make.width.mas_equalTo(_headerImageView.mas_height);
            }];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kColor(@"#333333");
        _nameLabel.font = kFont(15);
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_headerImageView.mas_right).mas_offset(kWidth(30));
                make.top.mas_equalTo(self).mas_offset(kWidth(28));
                make.height.mas_equalTo(kWidth(30));
                make.right.mas_equalTo(self);
            }];
        }
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.textColor = kColor(@"#666666");
        _ageLabel.font = kFont(14);
        [self addSubview:_ageLabel];
        {
            [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLabel);
                make.bottom.mas_equalTo(self).mas_offset(kWidth(-26));
//                make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(28)));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_attention_photo_icon"]];
        [self addSubview:_photoImageView];
        {
            [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_ageLabel.mas_right).mas_offset(kWidth(14));
                make.centerY.mas_equalTo(_ageLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
            }];
        }
        
        _photoLabel = [[UILabel alloc] init];
        _photoLabel.textColor = kColor(@"#999999");
        _photoLabel.font = kFont(14);
        [self addSubview:_photoLabel];
        {
            [_photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_photoImageView.mas_right).mas_offset(kWidth(12));
                make.centerY.mas_equalTo(_ageLabel);
//                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(28)));
                make.height.mas_equalTo(kWidth(28));
            }];
        }
    }
    
    return self;
}


- (void)setHeaderUrl:(NSString *)headerUrl {
    _headerUrl = headerUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl]];
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setAge:(NSInteger)age {
    _age = age;
    _ageLabel.text = [NSString stringWithFormat:@"%ld岁",age];
}

- (void)setPhotoCount:(NSInteger)photoCount {
    _photoCount = photoCount;
    _photoLabel.text = [NSString stringWithFormat:@"%zd照片",photoCount];
}

- (void)setAttentionAction:(YFBAction)attentionAction {
    _attentionAction = attentionAction;
    self.attentionBtn.backgroundColor = [UIColor clearColor];
}

@end
