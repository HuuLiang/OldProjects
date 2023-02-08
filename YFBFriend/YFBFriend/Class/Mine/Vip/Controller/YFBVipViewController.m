//
//  YFBVipViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVipViewController.h"
#import "YFBBuyVipCell.h"
#import "YFBBuyVipDescCell.h"
#import "YFBPaymentManager.h"
#import "YFBDiamondVoucherController.h"
#import "YFBPayConfigManager.h"


typedef NS_ENUM(NSInteger,YFBBuyVipSection) {
    YFBBuyVipSectionGold = 0,
    YFBBuyVipSectionSliver,
    YFBBuyVipSectionDesc,
    YFBBuyVipSectionCount
};

#define vipDescArr @[@"与所有女用户聊天",@"VIP用户聊天，享受1钻石/条信息优惠",@"钻石可购买礼物",@"VIP用户购买钻石额外赠送10%",@"VIP用户可查看联系方式",@"VIP用户可查看访问列表",@"查看聊天私密照",@"每天给30个异性打招呼",@"查看个人主页私密照",@"身份标识",@"提升曝光度",@"每天可查看无限异性视频介绍",@"查看喜欢我的人",@"查看访问记录"]

static NSString *const KYFBBuyVipCellReusableIdentifier = @"KYFBBuyVipCellReusableIdentifier";
static NSString *const kYFBBuyVipDescCellReusableIdentifier = @"kYFBBuyVipDescCellReusableIdentifier";

@interface YFBVipViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation YFBVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_needReturn) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"开通VIP";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBBuyVipCell class] forCellReuseIdentifier:KYFBBuyVipCellReusableIdentifier];
    [_tableView registerClass:[YFBBuyVipDescCell class] forCellReuseIdentifier:kYFBBuyVipDescCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//qq客服
- (void)contactCustomerService {
    NSString *contactScheme = @"mqq://im/chat?chat_type=wpa&uin=3057185386&version=1&src_type=web";
    NSString *contactName = @"QQ:3057185386";
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:contactScheme]]) {
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
             }
         }
     }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBBuyVipSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBBuyVipSectionGold || section == YFBBuyVipSectionSliver) {
        return 1;
    } else if (section == YFBBuyVipSectionDesc) {
        return vipDescArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBBuyVipSectionGold || indexPath.section == YFBBuyVipSectionSliver) {
        YFBBuyVipCell * cell = [tableView dequeueReusableCellWithIdentifier:KYFBBuyVipCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.section == YFBBuyVipSectionGold) {
            cell.vipType = YFBBuyVipTypeGold;
        } else if (indexPath.section == YFBBuyVipSectionSliver) {
            cell.vipType = YFBBuyVipTypeSliver;
        }
        @weakify(self);
        cell.payAction = ^{
            @strongify(self);
            CGFloat price = 0.0;
            NSInteger amount = 0;
            switch (indexPath.section) {
                case YFBBuyVipSectionGold:
                    price = [YFBPayConfigManager manager].vipInfo.secondInfo.price;
                    amount = [YFBPayConfigManager manager].vipInfo.secondInfo.amount;
                    break;
                case YFBBuyVipSectionSliver:
                    price = [YFBPayConfigManager manager].vipInfo.firstInfo.price;
                    amount = [YFBPayConfigManager manager].vipInfo.firstInfo.amount;
                    break;
                default:
                    break;
            }
            
            YFBDiamondVoucherController *voucherVC = [[YFBDiamondVoucherController alloc] initWithPrice:price diamond:amount Action:kYFBPaymentActionOpenVipKeyName];
            [self.navigationController pushViewController:voucherVC animated:YES];
        };
        
        return cell;
    } else if (indexPath.section == YFBBuyVipSectionDesc) {
        YFBBuyVipDescCell * cell = [tableView dequeueReusableCellWithIdentifier:kYFBBuyVipDescCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row < vipDescArr.count) {
            cell.descStr = vipDescArr[indexPath.row];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBBuyVipSectionGold || indexPath.section == YFBBuyVipSectionSliver) {
        return kWidth(160);
    } else if (indexPath.section == YFBBuyVipSectionDesc) {
        return kWidth(48);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == YFBBuyVipSectionGold || section == YFBBuyVipSectionSliver) {
        return kWidth(20);
    } else if (section == YFBBuyVipSectionDesc) {
        return kWidth(110);
    }
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == YFBBuyVipSectionGold) {
        return 0.01f;
    } else if (section == YFBBuyVipSectionSliver) {
        return kWidth(20);
    } else if (section == YFBBuyVipSectionDesc) {
        return kWidth(80);
    }
    return 0;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == YFBBuyVipSectionGold || section == YFBBuyVipSectionSliver) {
        headerView.backgroundColor = kColor(@"#efefef");
    } else if (section == YFBBuyVipSectionDesc) {
        headerView.backgroundColor = kColor(@"#ffffff");
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"会员特权";
        label.font = kFont(15);
        label.textColor = kColor(@"#333333");
        [headerView addSubview:label];
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.equalTo(headerView).offset(kWidth(50));
                make.height.mas_equalTo(label.font.lineHeight);
            }];
        }
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    if (section == YFBBuyVipSectionGold || section == YFBBuyVipSectionSliver) {
        footerView.backgroundColor = kColor(@"#efefef");
    } else if (section == YFBBuyVipSectionDesc) {
        footerView.backgroundColor = kColor(@"#ffffff");
        
        UIImageView *lineV = [[UIImageView alloc] init];
        lineV.backgroundColor = kColor(@"#efefef");
        [footerView addSubview:lineV];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"充值咨询" forState:UIControlStateNormal];
        [button setTitleColor:kColor(@"#666666") forState:UIControlStateNormal];
        button.titleLabel.font = kFont(14);
        [button setImage:[UIImage imageNamed:@"check_comment"] forState:UIControlStateNormal];
        [footerView addSubview:button];
        
        
        {
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(footerView);
                make.top.equalTo(footerView);
                make.size.mas_equalTo(CGSizeMake(kWidth(730), 1));
            }];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(footerView);
                make.right.equalTo(footerView.mas_right).offset(-kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(146), kWidth(26)));
            }];
        }
        
        UIEdgeInsets descImgInset = button.imageEdgeInsets;
        UIEdgeInsets descTitleInset = button.titleEdgeInsets;
        button.titleEdgeInsets = UIEdgeInsetsMake(descTitleInset.top, -button.imageView.width , descTitleInset.bottom, button.imageView.width);
        button.imageEdgeInsets = UIEdgeInsetsMake(descImgInset.top, button.titleLabel.width + 3, descImgInset.bottom, - button.titleLabel.width - 3);
        
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self contactCustomerService];
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return footerView;
}


@end
