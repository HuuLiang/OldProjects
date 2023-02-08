//
//  YFBAboutVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAboutVC.h"

@interface YFBAboutVC ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *label;
@property (nonatomic) UILabel *subLabel;
@end

@implementation YFBAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");
    
    [self configAboutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configAboutUI {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appicon"]];
    [self.view addSubview:_imageView];
    
    self.label = [[UILabel alloc] init];
    _label.textColor = kColor(@"#B9B9B9");
    _label.font = kFont(12);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"jiaouyoukf@126.com";
    [self.view addSubview:_label];
    
    self.subLabel = [[UILabel alloc] init];
    _subLabel.textColor = kColor(@"#B9B9B9");
    _subLabel.font = kFont(12);
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.text = @"Copyright@2017";
    [self.view addSubview:_subLabel];
    
    {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(88));
            make.size.mas_equalTo(CGSizeMake(kWidth(104), kWidth(104)));
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_imageView.mas_bottom).offset(kWidth(50));
            make.height.mas_equalTo(kWidth(30));
        }];
        
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(160));
            make.height.mas_equalTo(kWidth(30));
        }];
    }
}

@end
