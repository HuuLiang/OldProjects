//
//  SADrawMoneyDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADrawMoneyDetailVC.h"
#import "SADrawMoneyCell.h"
#import "SADrawMoneyModel.h"
#import "SAReqManager.h"

static NSString *const kSADrawMoneyCellReusableIdentifier = @"kSADrawMoneyCellReusableIdentifier";

NSString *const kSADrawMoneyStatusAllKeyName = @"";
NSString *const kSADrawMoneyStatusProcessing = @"WI_IN_PROCESS";
NSString *const kSADrawMoneyStatusSuccess    = @"WI_SUCCESS";
NSString *const kSADrawMoneyStatusFailed     = @"WI_FAILURE";

@interface SADrawMoneyDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString *currentStatu;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSMutableArray <SADrawDetailModel *> *dataSource;
@end

@implementation SADrawMoneyDetailVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithStatus:(NSString *)status {
    self = [super init];
    if (self) {
        _currentStatu = status;
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SADrawMoneyCell class] forCellReuseIdentifier:kSADrawMoneyCellReusableIdentifier];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self.view);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(80));
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView SA_addPullToRefreshWithHandler:^{
        @strongify(self);
        self.page = 1;
        [self fetchDataWithPage:self.page];
    }];
    
    [_tableView SA_addPagingRefreshWithHandler:^{
        @strongify(self);
        self.page++;
        [self fetchDataWithPage:self.page];
    }];
    
    [_tableView SA_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDataWithPage:(NSInteger)page {
    @weakify(self);
    [[SAReqManager manager] fetchDrawMoenyStatusWithStatus:self.currentStatu
                                                      Page:self.page
                                                     class:[SADrawMoneyModel class]
                                                   handler:^(BOOL success, SADrawMoneyModel * obj)
    {
        @strongify(self);
        [self.tableView SA_endPullToRefresh];
        if (obj.withdraw.count == 0) {
            [self.tableView SA_pagingRefreshNoMoreData];
        }
        if (success) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:obj.withdraw];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SADrawMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:kSADrawMoneyCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        SADrawDetailModel *detailModel = self.dataSource[indexPath.row];
        SAMineDrawMoneyStatus status;
        if ([detailModel.wiStatus isEqualToString:kSADrawMoneyStatusAllKeyName]) {
            status = SAMineDrawMoneyStatusAllRecrod;
        } else if ([detailModel.wiStatus isEqualToString:kSADrawMoneyStatusProcessing]) {
            status = SAMineDrawMoneyStatusProcessing;
        } else if ([detailModel.wiStatus isEqualToString:kSADrawMoneyStatusSuccess]) {
            status = SAMineDrawMoneyStatusSuccess;
        } else {
            status = SAMineDrawMoneyStatusFailed;
        }
        cell.drawStatus = status;
        cell.count = [NSString stringWithFormat:@"%.2f",(float)detailModel.wiAmount/100];
        cell.timeStr = detailModel.createTime;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(120);
}

@end
