//
//  SADrawMoneyVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADrawMoneyVC.h"
#import "UISliderView.h"
#import "SADrawMoneyDetailVC.h"

@interface SADrawMoneyVC ()
@property (nonatomic) UISliderView *sliderView;
@end

@implementation SADrawMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:self.view];
    _sliderView.titleScrollViewFrame = CGRectMake(0, 64, kScreenWidth, kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    _sliderView.imageBackViewFrame = CGRectMake(10, kWidth(80) - 3.5, kScreenWidth/4-20, 3);
    
    NSArray *titles = @[@"全部记录",@"正在处理",@"提现成功",@"提现失败"];
    NSArray *statusKeys = @[kSADrawMoneyStatusAllKeyName,kSADrawMoneyStatusProcessing,kSADrawMoneyStatusSuccess,kSADrawMoneyStatusFailed];
    _sliderView.titlesArr = titles;
    [self.view addSubview:_sliderView];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        NSString *status = statusKeys[i];
        SADrawMoneyDetailVC *contentVC = [[SADrawMoneyDetailVC alloc] initWithStatus:status];
        [_sliderView addChildViewController:contentVC title:title];
    }
    
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
