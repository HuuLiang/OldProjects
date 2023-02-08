//
//  SACleanUpVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SACleanUpVC.h"
#import "UISliderView.h"
#import "SACleanUpContentVC.h"

@interface SACleanUpVC ()
@property (nonatomic) UISliderView *sliderView;
@end

@implementation SACleanUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:self.view];
    _sliderView.titleScrollViewFrame = CGRectMake(0, 64, kScreenWidth, kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    _sliderView.imageBackViewFrame = CGRectMake(kWidth(80), kWidth(80) - 3.5, kScreenWidth/2 - kWidth(160), 3);
    
    NSArray *titles = @[@"分享赚钱",@"收徒赚钱"];
    _sliderView.titlesArr = titles;
    [self.view addSubview:_sliderView];
    
    for (NSString *title in titles) {
        SACleanUpContentVC *cleanUpContent = [[SACleanUpContentVC alloc] initWithType:[titles indexOfObject:title]];
        [_sliderView addChildViewController:cleanUpContent title:title];
    }
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
