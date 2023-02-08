//
//  SARecruitViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitViewController.h"
#import "SARecruitScrollView.h"
#import "SAMineAlertUIHelper.h"
#import "SAReqManager.h"
#import "SAUserAccountModel.h"
#import "SAShareManager.h"

@interface SARecruitViewController ()
@property (nonatomic) SARecruitScrollView *recruitScrollView;
@end

@implementation SARecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configRecruitContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRecruitContent) name:kSARefreshAccountInfoNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![SAUtil checkUserIsLogin]) {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeRecruitOffline onCurrentVC:self];
    } else {
        [self configRecruitContent];
    }
}

- (void)configRecruitContent {
    if (!_recruitScrollView) {
        self.recruitScrollView = [[SARecruitScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_recruitScrollView];
        
        @weakify(self);
        _recruitScrollView.startRecruitAction = ^{
            [[SAShareManager manager] startToRecruitUrlWoWx];
        };
        
        _recruitScrollView.QRCodeRecruitAction = ^{
            @strongify(self);
            [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeQRCode onCurrentVC:self];
        };
    }
    _recruitScrollView.hidden = ![SAUtil checkUserIsLogin];

    [SAUser user].amount = [SAUserAccountModel account].account.amount;
    [[SAUser user] update];
    
    _recruitScrollView.toRecruitCount = [SAUserAccountModel account].account.todayApNumber;
    _recruitScrollView.allRecruitCount = [SAUserAccountModel account].account.apNumber;
    _recruitScrollView.toBalanceCount = [SAUserAccountModel account].account.apDiAmount;
    _recruitScrollView.allBalanceCount = [SAUserAccountModel account].account.apAmount;
}

@end
