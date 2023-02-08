//
//  SAMineUserInfoCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineUserInfoCell.h"

@implementation SAUserField

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end

@interface SAMineUserInfoCell () <UITextFieldDelegate>
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) SAUserField *textField;
@end

@implementation SAMineUserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(12);
        _titleLabel.textColor = kColor(@"#666666");
        [self.contentView addSubview:_titleLabel];
        
        self.textField = [[SAUserField alloc] init];
        _textField.font = kFont(12);
        _textField.textColor = kColor(@"#222222");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(240));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(100));
                make.height.mas_equalTo(_textField.font.lineHeight);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _textField.text = content;
}

- (void)setTextFieldResponder:(BOOL)textFieldResponder {
    if (textFieldResponder) {
        [_textField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _content = _textField.text;
    [_textField resignFirstResponder];
    if (self.action) {
        self.action();
    }
    return YES;
}

@end
