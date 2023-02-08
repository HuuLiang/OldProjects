//
//  SARankListVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARankListVC.h"
#import "UISliderView.h"
#import "SARankDetailVC.h"

@interface SARankListVC ()
@property (nonatomic) UISliderView *sliderView;
@end

@implementation SARankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:self.view];
    _sliderView.titleScrollViewFrame = CGRectMake(0, 64, kScreenWidth, kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    _sliderView.imageBackViewFrame = CGRectMake(kWidth(80), kWidth(80) - 3.5, kScreenWidth/2- kWidth(160), 3);
    
    NSArray *titles = @[@"收益排行榜",@"收徒排行榜"];
    _sliderView.titlesArr = titles;
    [self.view addSubview:_sliderView];
    
    NSInteger count = 0;
    for (NSString *title in titles) {
        count++;
        SARankDetailVC *detailVC = [[SARankDetailVC alloc] initWithType:count];
        [_sliderView addChildViewController:detailVC title:title];
    }
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
