//
//  YFBAdviseVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAdviseVC.h"
#import "YFBPasswordView.h"
#import "YFBInteractionManager.h"

@interface YFBAdviseVC ()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) YFBPasswordView *contactView;
@property (nonatomic,strong) UILabel *noticeLabel;
@property (nonatomic,strong) UIButton *sendButton;
@end

@implementation YFBAdviseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configTextView];
    [self configContactView];
    [self configNoticeLabel];
    [self configSendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTextView {
    self.textView = [[UITextView alloc] init];
    _textView.font = kFont(14);
    _textView.textColor = kColor(@"#333333");
    [self.view addSubview:_textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"写些对红包来了的意见和建议......";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = kColor(@"#999999");
    placeHolderLabel.font = kFont(14);
    [placeHolderLabel sizeToFit];
    [_textView addSubview:placeHolderLabel];
    
    [_textView setValue:placeHolderLabel forKey:@"placeholderLabel"];
    
    {
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(180));
        }];
    }
}

- (void)configContactView {
    self.contactView = [[YFBPasswordView alloc] initWithTitle:@"联系方式" placeholder:@"手机/QQ/邮箱"];
    [self.view addSubview:_contactView];
    
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_textView.mas_bottom).offset(kWidth(6));
        make.height.mas_equalTo(kWidth(88));
    }];
}

- (void)configNoticeLabel {
    self.noticeLabel = [[UILabel alloc] init];
    _noticeLabel.textColor = kColor(@"#cccccc");
    _noticeLabel.numberOfLines = 0;
    _noticeLabel.font = kFont(12);
    _noticeLabel.text = @"意见一旦被采纳，我们会有小礼品赠送，请记得留下您的联系方式哦。";
    [self.view addSubview:_noticeLabel];
    
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(26));
        make.right.equalTo(self.view).offset(-kWidth(26));
        make.height.mas_equalTo(kWidth(100));
        make.top.equalTo(_contactView.mas_bottom).offset(kWidth(20));
    }];
}

- (void)configSendButton {
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _sendButton.titleLabel.font = kFont(15);
    _sendButton.layer.cornerRadius = kWidth(40);
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setBackgroundColor:kColor(@"#FD5C61")];
    [self.view addSubview:_sendButton];
    
    @weakify(self);
    [_sendButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        //发送信息
        [[YFBInteractionManager manager] sendAdviceWithContent:self->_textView.text Contact:self.contactView.content handler:^(BOOL success) {
            if (success) {
                if (!self) {
                    return ;
                }
                [[YFBHudManager manager] showHudWithText:@"发送成功"];
                self.textView.text = @"";
                return;
            }
            [[YFBHudManager manager] showHudWithText:@"发送失败"];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_noticeLabel.mas_bottom).offset(kWidth(10));
            make.size.mas_equalTo(CGSizeMake(kWidth(560), kWidth(80)));
        }];
    }
}

@end
