//
//  YFBUserInfoEditView.m
//  YFBFriend
//
//  Created by Liang on 2017/3/23.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUserInfoEditView.h"

@interface YFBUserInfoEditView () <UITextFieldDelegate>
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton   *vipButton;
@property (nonatomic,strong) UIButton   *secretButton;
@property (nonatomic,strong) UIButton   *cancleButton;
@property (nonatomic,strong) UIButton   *enterButton;
@property (nonatomic) YFBUserInfoOpenType openType;
@end

@implementation YFBUserInfoEditView

- (instancetype)initWithTitle:(NSString *)title hander:(void (^)(NSString *textFieldContent,YFBUserInfoOpenType openType))hander {
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor(@"#FF181A");
        _titleLabel.font = kFont(15);
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        self.textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = kFont(20);
        if ([title isEqualToString:@"QQ"] || [title isEqualToString:@"手机号"]) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self addSubview:_textField];
        
        self.vipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipButton setTitle:@"对VIP用户公开" forState:UIControlStateNormal];
        [_vipButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        _vipButton.titleLabel.font = kFont(14);
        [_vipButton setImage:[UIImage imageNamed:@"mine_datainfo_normal"] forState:UIControlStateNormal];
        [_vipButton setImage:[UIImage imageNamed:@"mine_datainfo_selected"] forState:UIControlStateSelected];
        _vipButton.selected = YES;
        self.openType = YFBUserInfoOpenTypeVip;
        [self addSubview:_vipButton];
        
        self.secretButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secretButton setTitle:@"保密" forState:UIControlStateNormal];
        [_secretButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
        _secretButton.titleLabel.font = kFont(14);
        [_secretButton setImage:[UIImage imageNamed:@"mine_datainfo_normal"] forState:UIControlStateNormal];
        [_secretButton setImage:[UIImage imageNamed:@"mine_datainfo_selected"] forState:UIControlStateSelected];
        _secretButton.selected = NO;
        [self addSubview:_secretButton];

        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:kColor(@"#333333") forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = kFont(15);
        [self addSubview:_cancleButton];
        
        self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [_enterButton setTitleColor:kColor(@"#FA557C") forState:UIControlStateNormal];
        _enterButton.titleLabel.font = kFont(15);
        [self addSubview:_enterButton];
        
        @weakify(self);
        [_vipButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self->_vipButton.selected) {
                return ;
            }
            self->_vipButton.selected = !self->_vipButton.selected;
            self->_secretButton.selected = !self->_secretButton.selected;
            self.openType = YFBUserInfoOpenTypeVip;
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_secretButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self->_secretButton.selected) {
                return ;
            }
            self->_vipButton.selected = !self->_vipButton.selected;
            self->_secretButton.selected = !self->_secretButton.selected;
            self.openType = YFBUserInfoOpenTypeClose;
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_cancleButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self removeSuperview];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_enterButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            hander(_textField.text,self.openType);
            [self removeSuperview];
        } forControlEvents:UIControlEventTouchUpInside];

        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(28));
                make.top.equalTo(self).offset(kWidth(26));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(120));
                make.size.mas_equalTo(CGSizeMake(kWidth(600), kWidth(80)));
            }];
            
            [_vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textField.mas_bottom).offset(kWidth(40));
                make.left.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(340), kWidth(88)));
            }];
            
            [_secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_vipButton);
                make.right.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(340), kWidth(88)));
            }];
            
            [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(340), kWidth(88)));
            }];
            
            [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(340), kWidth(88)));
            }];
            
        }
    }
    return self;
}

- (void)removeSuperview {
    if (self.cancel) {
        self.cancel();
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    _vipButton.imageEdgeInsets = UIEdgeInsetsMake(_vipButton.imageEdgeInsets.top, _vipButton.imageEdgeInsets.left-3, _vipButton.imageEdgeInsets.bottom, _vipButton.imageEdgeInsets.right+3);
    _vipButton.titleEdgeInsets = UIEdgeInsetsMake(_vipButton.titleEdgeInsets.top, _vipButton.titleEdgeInsets.left+3, _vipButton.titleEdgeInsets.bottom, _vipButton.titleEdgeInsets.right-3);
    
    _secretButton.imageEdgeInsets = UIEdgeInsetsMake(_secretButton.imageEdgeInsets.top, _secretButton.imageEdgeInsets.left-3, _secretButton.imageEdgeInsets.bottom, _secretButton.imageEdgeInsets.right+3);
    _secretButton.titleEdgeInsets = UIEdgeInsetsMake(_secretButton.titleEdgeInsets.top, _secretButton.titleEdgeInsets.left+3, _secretButton.titleEdgeInsets.bottom, _secretButton.titleEdgeInsets.right-3);

    
    CAShapeLayer *redline = [CAShapeLayer layer];
    CGMutablePathRef redPath = CGPathCreateMutable();
    [redline setStrokeColor:[kColor(@"#FF181A") CGColor]];
    redline.lineWidth = 1.0f;
    CGPathMoveToPoint(redPath, NULL, 0, kWidth(80));
    CGPathAddLineToPoint(redPath, NULL, self.frame.size.width, kWidth(80));
    [redline setPath:redPath];
    [self.layer addSublayer:redline];
    
    CAShapeLayer *grayline = [CAShapeLayer layer];
    CGMutablePathRef grayPath = CGPathCreateMutable();
    [grayline setStrokeColor:[kColor(@"#D2D2D2") CGColor]];
    grayline.lineWidth = 1.0f;
    CGPathMoveToPoint(grayPath, NULL, _textField.origin.x, _textField.origin.y+kWidth(81));
    CGPathAddLineToPoint(grayPath, NULL, _textField.origin.x+_textField.size.width, _textField.origin.y+kWidth(81));
    [grayline setPath:grayPath];
    [self.layer addSublayer:grayline];
    
    CAShapeLayer *graylineB = [CAShapeLayer layer];
    CGMutablePathRef grayPathB = CGPathCreateMutable();
    [graylineB setStrokeColor:[kColor(@"#D2D2D2") CGColor]];
    graylineB.lineWidth = 1.0f;
    CGPathMoveToPoint(grayPathB, NULL, _cancleButton.origin.x, _cancleButton.origin.y-1);
    CGPathAddLineToPoint(grayPathB, NULL, self.frame.size.width, _cancleButton.origin.y-1);
    [graylineB setPath:grayPathB];
    [self.layer addSublayer:graylineB];
    
    CAShapeLayer *graylineC = [CAShapeLayer layer];
    CGMutablePathRef grayPathC = CGPathCreateMutable();
    [graylineC setStrokeColor:[kColor(@"#D2D2D2") CGColor]];
    graylineC.lineWidth = 1.0f;
    CGPathMoveToPoint(grayPathC, NULL, self.frame.size.width/2, _cancleButton.origin.y);
    CGPathAddLineToPoint(grayPathC, NULL, self.frame.size.width/2, self.frame.size.height);
    [graylineC setPath:grayPathC];
    [self.layer addSublayer:graylineC];
}

@end
