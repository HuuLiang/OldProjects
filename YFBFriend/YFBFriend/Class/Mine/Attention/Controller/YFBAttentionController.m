//
//  YFBAttentionController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAttentionController.h"
#import "YFBAttentionDetailController.h"
#import "YFBSliderView.h"

@interface YFBAttentionController ()
{
    YFBSliderView *_headerView;
}

@end

@implementation YFBAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的关注";
    _headerView = [[YFBSliderView alloc] init];
    _headerView.titlesArr = @[@"关注我的",@"我关注的"];
    [self.view addSubview:_headerView];
    YFBAttentionDetailController *detailVC = [[YFBAttentionDetailController alloc] initWithIsAttentionMe:YES];
     YFBAttentionDetailController *detailVC2 = [[YFBAttentionDetailController alloc] initWithIsAttentionMe:NO];
    [_headerView addChildViewController:detailVC title:_headerView.titlesArr.firstObject];
    [_headerView addChildViewController:detailVC2 title:_headerView.titlesArr.lastObject];
    [_headerView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
