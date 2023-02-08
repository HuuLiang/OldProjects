//
//  SAMineViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineViewController.h"

#import "SAMineCenterUserInfoCell.h"
#import "SAMineCenterAdCell.h"
#import "SAMineCenterBalanceCell.h"
#import "SAMineCenterFunctionCell.h"

#import "SAMineAlertUIHelper.h"

#import "SAMineUserInfoVC.h"
#import "SABalanceVC.h"
#import "SADrawMoneyVC.h"
#import "SAAccountDetailVC.h"
#import "SARankListVC.h"
#import "SACleanUpVC.h"
#import "SAAboutUsVC.h"
#import "SARecruitInfoVC.h"

#import "SAReqManager.h"
#import "SAConfigModel.h"
#import "SAUserAccountModel.h"
#import "SASignModel.h"

static NSString *const kSAMineCenterUserInfoCellReusableIdentifier = @"kSAMineCenterUserInfoCellReusableIdentifier";
static NSString *const kSAMineCenterAdCellReusableIdentifier = @"kSAMineCenterAdCellReusableIdentifier";
static NSString *const kSAMineCenterBalanceCellReusableIdentifier = @"kSAMineCenterBalanceCellReusableIdentifier";
static NSString *const kSAMineCenterFunctionCellReusableIdentifier = @"kSAMineCenterFunctionCellReusableIdentifier";

typedef NS_ENUM(NSInteger,SAMineCenterSection) {
    SAMineCenterUserInfoSection = 0,    //用户信息
    SAMineCenterAdSection,              //广告
    SAMineCenterBalanceSection,         //提现
    SAMineCenterFunctionSection,        //功能
    SAMineCenterSectionCount
};

typedef NS_ENUM(NSInteger,SAMineFunctionRow) {
    SAMineFunctionWithdrawDepositRow = 0,   //提现记录
    SAMineFunctionAccountDetailRow,         //账户明细
    SAMineFunctionRankingListRow,           //排行榜
    SAMineFunctionServiveRow,               //官方QQ
    SAMineFunctionCleanUpRow,               //赚钱攻略
    SAMineFunctionAboutUsRow,              //关于我们
    SAMineFunctionRecruitInfoRow,           //收徒信息
    SAMineFunctionRowCount
};

@interface SAMineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation SAMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalanceSection) name:kSARefreshAccountInfoNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![SAUtil checkUserIsLogin]) {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeMineCenterOffline onCurrentVC:self];
    }
//    _tableView.hidden = ![SAUtil checkUserIsLogin];
    [self configMineCenter];
    [self configRightBarButtonItem];
}

- (void)configMineCenter {
    if (![SAUtil checkUserIsLogin]) {
        return;
    }
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColor(@"#efefef");
        [_tableView setSeparatorColor:kColor(@"#f0f0f0")];
        [_tableView registerClass:[SAMineCenterUserInfoCell class] forCellReuseIdentifier:kSAMineCenterUserInfoCellReusableIdentifier];
        [_tableView registerClass:[SAMineCenterAdCell class] forCellReuseIdentifier:kSAMineCenterAdCellReusableIdentifier];
        [_tableView registerClass:[SAMineCenterBalanceCell class] forCellReuseIdentifier:kSAMineCenterBalanceCellReusableIdentifier];
        [_tableView registerClass:[SAMineCenterFunctionCell class] forCellReuseIdentifier:kSAMineCenterFunctionCellReusableIdentifier];
        [self.view addSubview:_tableView];
        {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    } else {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)configRightBarButtonItem {
    if (![SAUtil checkUserIsLogin]) {
        return;
    }
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"签到" style:UIBarButtonItemStylePlain handler:^(id sender) {
            //签到
            [[SAReqManager manager] signWithClass:[SASignModel class] handler:^(BOOL success, id obj) {
                if (success) {
                    [SAUtil fetchAccountInfo];
                    [[SAHudManager manager] showHudWithText:@"签到成功"];
                }
            }];
        }];
    }
}

- (void)contactCustomerService {
    NSString *contactScheme = [SAConfigModel defaultConfig].config.QQ;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服？"]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}

- (void)refreshBalanceSection {
    if (_tableView) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:SAMineCenterBalanceSection];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SAMineCenterSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SAMineCenterUserInfoSection:
        case SAMineCenterAdSection:
        case SAMineCenterBalanceSection:
            return 1;
            break;
            
        case SAMineCenterFunctionSection:
            return SAMineFunctionRowCount;
            break;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SAMineCenterUserInfoSection) {
        SAMineCenterUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAMineCenterUserInfoCellReusableIdentifier forIndexPath:indexPath];
        cell.portraitUrl = [SAUser user].portraitUrl;
        cell.nickName = [SAUser user].nickName;
        cell.userId = [SAUser user].userId;
        return cell;
    } else if (indexPath.section == SAMineCenterAdSection) {
        SAMineCenterAdCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAMineCenterAdCellReusableIdentifier forIndexPath:indexPath];
        cell.title = [SAConfigModel defaultConfig].config.SCROLLING;
        return cell;
    } else if (indexPath.section == SAMineCenterBalanceSection) {
        SAMineCenterBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAMineCenterBalanceCellReusableIdentifier forIndexPath:indexPath];
        cell.balance = [NSString stringWithFormat:@"%.2f",(float)[SAUser user].amount/100];
        
        @weakify(self);
        cell.withDrawAction = ^{
            @strongify(self);
            [self pushViewControllerWith:[SABalanceVC class] title:@"提现"];
        };
        
        return cell;
    } else if (indexPath.section == SAMineCenterFunctionSection) {
        SAMineCenterFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAMineCenterFunctionCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row == SAMineFunctionWithdrawDepositRow) {
            cell.title = @"提现记录";
            cell.imgName = @"mine_withdraw";
        } else if (indexPath.row == SAMineFunctionAccountDetailRow) {
            cell.title = @"账户明细";
            cell.imgName = @"mine_detail";
        } else if (indexPath.row == SAMineFunctionRankingListRow) {
            cell.title = @"排行榜";
            cell.imgName = @"mine_rank";
        } else if (indexPath.row == SAMineFunctionServiveRow) {
            cell.title = @"官方QQ";
            cell.imgName = @"mine_service";
        } else if (indexPath.row == SAMineFunctionCleanUpRow) {
            cell.title = @"赚钱攻略";
            cell.imgName = @"mine_clean";
        } else if (indexPath.row == SAMineFunctionAboutUsRow) {
            cell.title = @"关于我们";
            cell.imgName = @"mine_about";
        } else if (indexPath.row == SAMineFunctionRecruitInfoRow) {
            cell.title = @"收徒信息";
            cell.imgName = @"mine_recruit";
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SAMineCenterUserInfoSection) {
        return kWidth(180);
    } else if (indexPath.section == SAMineCenterAdSection) {
        return kWidth(66);
    } else if (indexPath.section == SAMineCenterBalanceSection) {
        return kWidth(194);
    } else if (indexPath.section == SAMineCenterFunctionSection) {
        return kWidth(88);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == SAMineCenterUserInfoSection) {
        return 0.01f;
    } else if (section == SAMineCenterAdSection) {
        return 20.0f;
    } else if (section == SAMineCenterBalanceSection) {
        return 1.0f;
    } else if (section == SAMineCenterFunctionSection) {
        return 20.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SAMineCenterUserInfoSection) {
        return 0.01f;
    } else if (section == SAMineCenterAdSection) {
        return 0.01f;
    } else if (section == SAMineCenterBalanceSection) {
        return 0.01f;
    } else if (section == SAMineCenterFunctionSection) {
        return 0.01f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = kColor(@"#efefef");
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooterView = [[UIView alloc] init];
    sectionFooterView.backgroundColor = kColor(@"#efefef");
    return sectionFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SAMineCenterUserInfoSection) {
        SAMineUserInfoVC *infoVC = [[SAMineUserInfoVC alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if (indexPath.section == SAMineCenterAdSection) {
        
    } else if (indexPath.section == SAMineCenterBalanceSection) {
        
    } else if (indexPath.section == SAMineCenterFunctionSection) {
        if (indexPath.row == SAMineFunctionWithdrawDepositRow) {
            [self pushViewControllerWith:[SADrawMoneyVC class] title:@"提现记录"];
        } else if (indexPath.row == SAMineFunctionAccountDetailRow) {
            [self pushViewControllerWith:[SAAccountDetailVC class] title:@"账户明细"];
        } else if (indexPath.row == SAMineFunctionRankingListRow) {
            [self pushViewControllerWith:[SARankListVC class] title:@"排行榜"];
        } else if (indexPath.row == SAMineFunctionServiveRow) {
            [self contactCustomerService];
        } else if (indexPath.row == SAMineFunctionCleanUpRow) {
            [self pushViewControllerWith:[SACleanUpVC class] title:@"赚钱攻略"];
        } else if (indexPath.row == SAMineFunctionAboutUsRow) {
//            [self pushViewControllerWith:[SAAboutUsVC class] title:@"关于我们"];
            SAAboutUsVC *aboutUsVC = [[SAAboutUsVC alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",SA_BASE_URL,SA_ABOUNTUS_URL]];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        } else if (indexPath.row == SAMineFunctionRecruitInfoRow) {
            [self pushViewControllerWith:[SARecruitInfoVC class] title:@"收徒信息"];
        }
    }
}

@end
