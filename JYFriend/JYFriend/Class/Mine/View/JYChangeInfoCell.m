//
//  JYChangeInfoCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYChangeInfoCell.h"

@interface JYChangeInfoCell ()<UITextFieldDelegate>

{
    UILabel *_titleLabel;
}

@end

@implementation JYChangeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:_titleLabel];
        {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(30));
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kWidth(70), kWidth(42)));
        }];
        }
        
        
    }

    return self;
}

- (UITextField *)textField {
    if (_textField) {
        return _textField;
    }
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:kWidth(30)];
    [self addSubview:_textField];
    {
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).mas_offset(kWidth(60.));
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    }

    return _textField;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setUserInfo:(NSString *)userInfo {
    _userInfo = userInfo;
    self.textField.text = userInfo;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (self.cancleEditing) {
        if ([self.delegate respondsToSelector:@selector(JYChageInfoCell:DidCancleEditingWithTextFiled:)]) {
            [self.delegate JYChageInfoCell:self DidCancleEditingWithTextFiled:textField];
        }
//        return NO;
//    }
    return YES;
}


@end
