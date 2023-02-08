//
//  YFBBaseViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/2/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"
#import "YFBDetailViewController.h"
#import "YFBMessageViewController.h"
#import "YFBVipViewController.h"

@interface YFBBaseViewController ()

@end

@implementation YFBBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushIntoDetailVC:(NSString *)userID {
    YFBDetailViewController *detailVC = [[YFBDetailViewController alloc] initWithUserId:userID];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)pushIntoMessageVCWithUserId:(NSString *)userId nickName:(NSString *)nickName avatarUrl:(NSString *)avatarUrl {
    [YFBMessageViewController showMessageWithUserId:userId nickName:nickName avatarUrl:avatarUrl inViewController:self];
}

- (void)pushIntoPayVC {
    YFBVipViewController *vipVC = [[YFBVipViewController alloc] initWithTitle:@"开通VIP"];
    [self.navigationController pushViewController:vipVC animated:YES];
}

@end
