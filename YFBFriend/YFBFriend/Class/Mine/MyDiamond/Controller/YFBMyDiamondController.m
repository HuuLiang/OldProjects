//
//  YFBMyDiamondController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyDiamondController.h"
#import "YFBDiamondCell.h"
#import "YFBDiamondExplainController.h"
#import "YFBDiamondVoucherController.h"
#import "YFBDiamondManager.h"
#import "YFBPaymentManager.h"
#import "YFBDiamondTitleCell.h"

static NSString *const kYFBDiamondCellIdentifier = @"kyfb_diamond_cell_identifier";
static NSString *const kYFBDiamondTitleCellIdentifier = @"kYFBDiamondTitleCellIdentifier";

typedef NS_ENUM(NSInteger,YFBMyDiamondSectionType) {
    YFBMyDiamondSectionTypeTitle = 0,
    YFBMyDiamondSectionTypeCategory,
    YFBMyDiamondSectionTypeCount
};

@interface YFBMyDiamondController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation YFBMyDiamondController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天套餐";
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorInset:UIEdgeInsetsZero];
    [_layoutTableView registerClass:[YFBDiamondCell class] forCellReuseIdentifier:kYFBDiamondCellIdentifier];
    [_layoutTableView registerClass:[YFBDiamondTitleCell class] forCellReuseIdentifier:kYFBDiamondTitleCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"说明" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        YFBDiamondExplainController *explainVC = [[YFBDiamondExplainController alloc] init];
        [self.navigationController pushViewController:explainVC animated:YES];
    }];
    
    [self.dataSource addObjectsFromArray:[YFBDiamondManager manager].diamonList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBMyDiamondSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBMyDiamondSectionTypeTitle) {
        return 1;
    } else if (section == YFBMyDiamondSectionTypeCategory) {
        return self.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMyDiamondSectionTypeTitle) {
        YFBDiamondTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDiamondTitleCellIdentifier forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.section == YFBMyDiamondSectionTypeCategory) {
        YFBDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDiamondCellIdentifier forIndexPath:indexPath];
        if (indexPath.row < self.dataSource.count) {
            YFBDiamondInfo *diamondInfo = self.dataSource[indexPath.item];
            cell.amount = [NSString stringWithFormat:@"%ld",diamondInfo.diamondAmount];
            cell.price = [NSString stringWithFormat:@"¥ %ld",(long)(diamondInfo.price/100)];
            cell.desc = diamondInfo.giveDesc;
            @weakify(self);
            cell.payAction = ^{
                @strongify(self);
                YFBDiamondVoucherController *voucherVC = [[YFBDiamondVoucherController alloc] initWithPrice:diamondInfo.price diamond:diamondInfo.diamondAmount Action:kYFBPaymentActionPURCHASEDIAMONDKeyName];
                [self.navigationController pushViewController:voucherVC animated:YES];
            };
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMyDiamondSectionTypeTitle) {
        return kWidth(220);
    } else if (indexPath.section == YFBMyDiamondSectionTypeCategory) {
        return kWidth(140);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kColor(@"#f0f0f0");
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kColor(@"#333333");
    label.font = kFont(15);
    [headerView addSubview:label];
    
    if (section == YFBMyDiamondSectionTypeTitle) {
        label.text = @"  聊天套餐服务";
    } else if (section == YFBMyDiamondSectionTypeCategory) {
        label.text = @"  开通套餐";
    }
    
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBMyDiamondSectionTypeTitle) {
        return kWidth(90);
    } else if (section == YFBMyDiamondSectionTypeCategory) {
        return kWidth(90);
    }
    return 0;
}


@end
