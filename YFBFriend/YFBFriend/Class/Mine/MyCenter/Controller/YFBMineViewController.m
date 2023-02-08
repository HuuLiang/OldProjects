//
//  YFBMineViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMineViewController.h"
#import "YFBMineHeaderCell.h"
#import "YFBMineCell.h"
#import "YFBVerifyViewController.h"
#import "YFBAttentionController.h"
#import "YFBMyGiftController.h"
#import "YFBVipViewController.h"
#import "YFBMyDiamondController.h"
#import "YFBMineDataInfoViewController.h"
#import "YFBSettingViewController.h"
#import "YFBMinePhotosViewController.h"
#import "YFBSystemConfigModel.h"

static NSString *const YFBMineHeaderCellIdentifier = @"yfb_mine_header_cell_identifier";
static NSString *const YFBMineCellIdentifier = @"yfb_mine_cell_identifier";

typedef NS_ENUM(NSUInteger, YFBMineSectionType) {
    YFBMineSectionTypeHeader,
    YFBMineSectionTypeRecord,
    YFBMineSectionTypeWallet,
    YFBMineSectionTypeInfo,
    YFBMineSectionTypeSetting,
    YFBMineSectionTypeCount
};

typedef NS_ENUM(NSUInteger, YFBRecordRowType) {
    YFBRecordRowTypeAttention,//谁关注我
    YFBRecordRowTypeCount,
};

typedef NS_ENUM(NSUInteger, YFBWlletRowType) {
    YFBWlletRowTypeDiamond,//我的钻石
    YFBWlletRowTypeGift,//我的礼物
    YFBWlletRowTypeCount
};

typedef NS_ENUM(NSUInteger, YFBMineInfoType) {
    YFBMineInfoTypeInfo,//个人资料
    YFBMineInfoTypePhoto,//我的相册
    YFBMineInfoTypeQQ,
    YFBMineInfoTypeCount,
};

@interface YFBMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    
}
@end

@implementation YFBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = kColor(@"#efeff4");
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[YFBMineHeaderCell class] forCellReuseIdentifier:YFBMineHeaderCellIdentifier];
    [_layoutTableView registerClass:[YFBMineCell class] forCellReuseIdentifier:YFBMineCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_layoutTableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return YFBMineSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBMineSectionTypeHeader) {
        return 1;
    }else if (section == YFBMineSectionTypeRecord){
        return YFBRecordRowTypeCount;
    }else if (section == YFBMineSectionTypeWallet){
        return YFBWlletRowTypeCount;
    }else if (section == YFBMineSectionTypeInfo){
        if ([YFBUtil isVip] || [YFBUser currentUser].diamondCount > 0) {
            return YFBMineInfoTypeCount;
        }
        return YFBMineInfoTypeQQ;
    }else if (section == YFBMineSectionTypeSetting){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMineSectionTypeHeader) {
        YFBMineHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:YFBMineHeaderCellIdentifier forIndexPath:indexPath];
        headerCell.headerImage = [YFBUser currentUser].userImage;
        headerCell.name = [YFBUser currentUser].nickName;
        headerCell.idNumber = [YFBUser currentUser].userId;
        headerCell.invite = @"RC456";
        @weakify(self);
        headerCell.ktVipAction = ^(id sender){
            @strongify(self);
            YFBVipViewController *vipVC = [[YFBVipViewController alloc] initWithTitle:@"开通VIP"];
            [self.navigationController pushViewController:vipVC animated:YES];
        };
        headerCell.attestationAction = ^(id sender){
            @strongify(self);
            YFBVerifyViewController *verifyVC = [[YFBVerifyViewController alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        };
        
        return headerCell;
    }else if (indexPath.section == YFBMineSectionTypeRecord){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == YFBRecordRowTypeAttention){
            cell.subTitle = nil;
            cell.title = @"谁关注我";
            cell.iconImage = @"mine_attention_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeWallet){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        if (indexPath.row == YFBWlletRowTypeDiamond){
            cell.title = @"我的钻石";
            cell.subTitle = [NSString stringWithFormat:@"%ld",[YFBUser currentUser].diamondCount];
            cell.iconImage = @"mine_my_diamond_icon";
        } else if (indexPath.row == YFBWlletRowTypeGift){
            cell.title = @"我的礼物";
            cell.iconImage = @"mine_my_gift_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeInfo){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        if (indexPath.row == YFBMineInfoTypeInfo) {
            cell.title = @"个人资料";
            cell.iconImage = @"mine_my_info_icon";
        } else if (indexPath.row == YFBMineInfoTypePhoto){
            cell.title = @"我的相册";
            cell.iconImage = @"mine_my_photo_icon";
        } else if (indexPath.row == YFBMineInfoTypeQQ) {
            cell.title= @"QQ客服";
            cell.iconImage = @"mine_my_qq_icon";
        }
        return cell;
    }else if (indexPath.section == YFBMineSectionTypeSetting){
        YFBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineCellIdentifier forIndexPath:indexPath];
        cell.subTitle = nil;
        cell.title = @"设置";
        cell.iconImage = @"mine_setting_icon";
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMineSectionTypeHeader) {
        return kWidth(286);
    }
    else if (indexPath.section == YFBMineSectionTypeRecord){
        if (indexPath.row == YFBRecordRowTypeAttention) {
            return kWidth(120);
        }
    }
    return kWidth(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(24);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = kColor(@"#efeff4");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBMineSectionTypeRecord){
        if (indexPath.row == YFBRecordRowTypeAttention){
            YFBAttentionController *attentionVC = [[YFBAttentionController alloc] init];
            [self.navigationController pushViewController:attentionVC animated:YES];
        }
    } else if (indexPath.section == YFBMineSectionTypeWallet){
        if (indexPath.row == YFBWlletRowTypeDiamond){
            YFBMyDiamondController *diamondVC = [[YFBMyDiamondController alloc] init];
            [self.navigationController pushViewController:diamondVC animated:YES];
        } else if (indexPath.row == YFBWlletRowTypeGift){
            YFBMyGiftController *giftVC = [[YFBMyGiftController alloc] init];
            [self.navigationController pushViewController:giftVC animated:YES];
        }
    } else if (indexPath.section == YFBMineSectionTypeInfo){
        if (indexPath.row == YFBMineInfoTypeInfo) {
            YFBMineDataInfoViewController *dataInfoVC = [[YFBMineDataInfoViewController alloc] initWithTitle:@"更新个人资料"];
            [self.navigationController pushViewController:dataInfoVC animated:YES];
        } else if (indexPath.row == YFBMineInfoTypePhoto){
            YFBMinePhotosViewController *photoVC = [[YFBMinePhotosViewController alloc] initWithTitle:@"我的照片"];
            [self.navigationController pushViewController:photoVC animated:YES];
        } else if (indexPath.row == YFBMineInfoTypeQQ) {
            [self contactCustomerService];
        }
    } else if (indexPath.section == YFBMineSectionTypeSetting){
        YFBSettingViewController *settingVC = [[YFBSettingViewController alloc] initWithTitle:@"设置"];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

//qq客服
- (void)contactCustomerService {
    NSString *contactScheme = [YFBSystemConfigModel defaultConfig].config.CONTACT_SCHEME;
    NSString *contactName = [YFBSystemConfigModel defaultConfig].config.CONTACT_NAME;
    
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


@end
