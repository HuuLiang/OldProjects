//
//  JYRegisterDetailCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterDetailCell.h"
#import "JYNextButton.h"

@interface JYRegisterDetailCell ()
{
    UILabel       *_contentLabel;
    UIImageView   *_arrowImgV;
    JYNextButton  *_femaleBtn;
    JYNextButton  *_maleBtn;
}
@end

@implementation JYRegisterDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16.];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

- (void)setCellType:(JYDetailCellType)cellType {
    if (cellType == JYDetailCellTypeContent) {
        _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_arrow"]];
        [self.contentView addSubview:_arrowImgV];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_contentLabel];
        
        {
            [_arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(18)));
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_arrowImgV.mas_left).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(32));
            }];
        }
    } else if (cellType == JYDetailCellTypeSelect) {
        @weakify(self);
        _femaleBtn = [[JYNextButton alloc] initWithTitle:@"女" action:^{
            @strongify(self);
            if (self->_femaleBtn.isSelected) {
                return ;
            } else {
                self->_femaleBtn.selected = YES;
                [self->_femaleBtn setBackgroundColor:kColor(@"#E147A5")];
                self->_femaleBtn.layer.borderWidth = 0;
                self->_maleBtn.selected = NO;
                [self->_maleBtn setBackgroundColor:kColor(@"#ffffff")];
                self->_maleBtn.layer.borderWidth = 1;
                if (self.sexSelected) {
                    self.sexSelected(@(JYUserSexFemale));
                }
            }
        }];
        [_femaleBtn setBackgroundColor:kColor(@"#ffffff")];
        [_femaleBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateSelected];
        _femaleBtn.layer.borderWidth = 1;
        _femaleBtn.layer.borderColor = kColor(@"#E6E6E6").CGColor;
        _femaleBtn.layer.masksToBounds = YES;
        _femaleBtn.selected = NO;
        [self.contentView addSubview:_femaleBtn];
        
        _maleBtn = [[JYNextButton alloc] initWithTitle:@"男" action:^{
            @strongify(self);
            if (self->_maleBtn.isSelected) {
                return ;
            } else {
                self->_femaleBtn.selected = NO;
                [self->_femaleBtn setBackgroundColor:kColor(@"#ffffff")];
                self->_femaleBtn.layer.borderWidth = 1;
                self->_maleBtn.selected = YES;
                [self->_maleBtn setBackgroundColor:kColor(@"#E147A5")];
                self->_maleBtn.layer.borderWidth = 0;
                if (self.sexSelected) {
                    self.sexSelected(@(JYUserSexMale));
                }
            }
        }];
        [_maleBtn setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        [_maleBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateSelected];
        _maleBtn.layer.borderWidth = 0;
        _maleBtn.layer.borderColor = kColor(@"#E6E6E6").CGColor;
        _maleBtn.layer.masksToBounds = YES;
        _maleBtn.selected = YES;
        [self.contentView addSubview:_maleBtn];
        
        if (self.sexSelected) {
            self.sexSelected(@(JYUserSexMale));
        }
        
        {
            [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(70));
                make.size.mas_equalTo(CGSizeMake(kWidth(110), kWidth(60)));
            }];
            
            [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_maleBtn.mas_left).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(110), kWidth(60)));
            }];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}

@end
