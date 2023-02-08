//
//  SATextField.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SATextField.h"

@interface SATextField () <UITextFieldDelegate>
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *contentField;
@property (nonatomic) UIImageView *lineV;
@end

@implementation SATextField

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14);
        _titleLabel.text = title;
        _titleLabel.textColor = kColor(@"#333333");
        [self addSubview:_titleLabel];
        
        self.contentField = [[UITextField alloc] init];
        _contentField.textColor = kColor(@"#666666");
        _contentField.font = kFont(14);
        _contentField.placeholder = placeholder;
        _contentField.returnKeyType = UIReturnKeyDone;
        _contentField.delegate = self;
        [_contentField setValue:kColor(@"#cccccc") forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_contentField];
        
        self.lineV = [[UIImageView alloc] init];
        _lineV.backgroundColor = kColor(@"#f0f0f0");
        [self addSubview:_lineV];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(64));
                make.height.mas_equalTo(_titleLabel.font.lineHeight);
            }];
            
            [_contentField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(200));
                make.size.mas_equalTo(CGSizeMake(kWidth(270), _contentField.font.lineHeight));
            }];
            
            [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom);
                make.centerX.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(600), 0.5));
            }];
        }
    }
    return self;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _contentField.keyboardType = keyboardType;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (!hitView) {
        return hitView;
    }
    
    CGRect fieldFrame = _contentField.frame;
    if (CGRectIsEmpty(fieldFrame)) {
        return hitView;
    }
    
    CGRect expandedFrame = CGRectInset(fieldFrame, -kWidth(78), -kWidth(20));
    if (CGRectContainsPoint(expandedFrame, point)) {
        return _contentField;
    }
    return hitView;
}

- (NSString *)text {
    return _contentField.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_contentField resignFirstResponder];
    return YES;
}

@end
