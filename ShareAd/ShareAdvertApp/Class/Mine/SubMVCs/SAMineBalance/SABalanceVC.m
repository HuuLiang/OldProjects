//
//  SABalanceVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABalanceVC.h"
#import "SABalanceHeaderView.h"
#import "SABalanceCell.h"
#import "SAMineUserInfoVC.h"
#import "SAMineAlertUIHelper.h"
#import "SABalanceModel.h"
#import "SAReqManager.h"
#import "SAConfigModel.h"

static NSString *const kSABalanceCellReusableIdentifier = @"kSABalanceCellReusableIdentifier";

@interface SABalanceVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SABalanceHeaderView *headerView;
@property (nonatomic) UIButton *drawButton;
@property (nonatomic) NSArray *priceArr;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation SABalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView registerClass:[SABalanceCell class] forCellReuseIdentifier:kSABalanceCellReusableIdentifier];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    self.priceArr =  [[[SAConfigModel defaultConfig].config.DRAW_CONFIG componentsSeparatedByString:@"|"] bk_select:^BOOL(NSString * obj) {
        return [obj integerValue];
    }];
    
    [self configTableHeaderView];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTableHeaderView {
    self.headerView = [[SABalanceHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(256));
    _tableView.tableHeaderView = _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchWxInfo) name:kSABindingWxNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fetchWxInfo {
//    [self pushViewControllerWith:[SAMineUserInfoVC class] title:@"个人资料"];
    SAMineUserInfoVC *userInfoVC = [[SAMineUserInfoVC alloc] initWithTitle:@"个人资料"];
    userInfoVC.type = SAPushUserInfoVCTypeWx;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)startDrawMoney {
    NSInteger selectedPrice = [self.priceArr[_selectedIndexPath.row] integerValue];
    @weakify(self);
    [[SAReqManager manager] drwaMoneyWithAmount:selectedPrice class:[SABalanceModel class] handler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [SAUtil fetchAccountInfo];
            [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeDrawSuccess onCurrentVC:self];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.priceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SABalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kSABalanceCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.priceArr.count) {
        cell.price = [self.priceArr[indexPath.row] integerValue];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(88);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = kColor(@"#efefef");
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooterView = [[UIView alloc] init];
    self.drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawButton setTitle:@"提现" forState:UIControlStateNormal];
    [_drawButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _drawButton.titleLabel.font = kFont(13);
    _drawButton.backgroundColor = kColor(@"#FF3366");
    [sectionFooterView addSubview:_drawButton];
    {
        [_drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sectionFooterView);
            make.bottom.equalTo(sectionFooterView.mas_bottom).offset(-kWidth(80));
            make.size.mas_equalTo(CGSizeMake(kWidth(490), kWidth(76)));
        }];
    }
    @weakify(self);
    [_drawButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([SAUser user].weixin.length > 0 && [SAUser user].openId.length > 0) {
            [self startDrawMoney];
        } else {
            [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeBingding onCurrentVC:self];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kWidth(370);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
}

@end
