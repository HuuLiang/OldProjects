//
//  YFBPasswordView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPasswordView.h"
#include "YFBTextField.h"

@interface YFBPasswordView () <UITextFieldDelegate>
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) YFBTextField *textField;
@end

@implementation YFBPasswordView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    if (self = [super init]) {
        
        self.backgroundColor = kColor(@"#ffffff");
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        _titleLabel.textColor = kColor(@"#333333");
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        self.textField = [[YFBTextField alloc] init];
        _textField.placeholder = placeholder;
        _textField.delegate = self;
        [self addSubview:_textField];
        
        [_textField addTarget:self action:@selector(changeTextFieldContent:) forControlEvents:UIControlEventEditingChanged];
        
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.bottom.top.equalTo(self);
                make.left.equalTo(self).offset(kWidth(20));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.bottom.top.right.equalTo(self);
                make.left.equalTo(self).offset(kWidth(190));
            }];
        }
    }
    return self;
}

- (NSString *)content {
    return _textField.text;
}

- (void)resignFirstResponse {
    [_textField resignFirstResponder];
}

- (void)changeTextFieldContent:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldEditingContent:)]) {
        [self.delegate textFieldEditingContent:textField.text];
    }
}

@end
