//
//  YFBSettingViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSettingViewController.h"
#import "YFBSettingCell.h"
#import "YFBPasswordVC.h"
#import "YFBActivityVC.h"
#import "YFBAboutVC.h"
#import "YFBAdviseVC.h"
#import "YFBNavigationController.h"
#import "YFBLaunchViewController.h"
#import "AppDelegate.h"

static NSString *const kYFBSettingCellReusableIdentifier = @"YFBSettingCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, YFBSettingSectionType) {
    YFBSettingSectionTypeNotice = 0,
    YFBSettingSectionTypeFunction,
    YFBSettingSectionTypeCache,
    YFBSettingSectionTypeCount
};

typedef NS_ENUM(NSUInteger, YFBSettingNoticeType) {
    YFBSettingNoticeTypeNew = 0,
    YFBSettingNoticeTypeShake,
    YFBSettingNoticeTypeVoice,
    YFBSettingNoticeTypeBack,
    YFBSettingNoticeTypeCount
};

typedef NS_ENUM(NSUInteger, YFBSettingFunctionType) {
    YFBSettingFunctionTypeChange = 0,
    YFBSettingFunctionTypeAdvise,
    YFBSettingFunctionTypeActivity,
    YFBSettingFunctionTypeAbout,
    YFBSettingFunctionTypeCount
};


@interface YFBSettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation YFBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBSettingCell class] forCellReuseIdentifier:kYFBSettingCellReusableIdentifier];
    _tableView.tableHeaderView = [self configSettingTableHeaderView];
    _tableView.tableFooterView = [self configSettingTableFooterView];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [YFB_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, YFB_BASE_URL.length-6) withString:@"******"];
        [[YFBHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@\nBundleId:%@\nVersion:%@\nUserID:%@\nexpireTimeDate:%@", baseURLString, YFB_CHANNEL_NO, YFB_PACKAGE_CERTIFICATE, YFB_REST_PV,YFB_BUNDLE_IDENTIFIER,YFB_REST_APP_VERSION, [YFBUser currentUser].userId,[YFBUser currentUser].expireTime]];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)configSettingTableHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.size = CGSizeMake(kScreenWidth, kWidth(90));
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.textColor = kColor(@"#333333");
    idLabel.font = kFont(15);
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.text = [NSString stringWithFormat:@"当前帐号%@",[YFBUser currentUser].userId];
    [headerView addSubview:idLabel];
    
    {
        [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView);
            make.height.mas_equalTo(kWidth(30));
        }];
    }
    
    return headerView;
}

- (UIView *)configSettingTableFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.size = CGSizeMake(kScreenWidth, kWidth(90));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button setTintColor:kColor(@"#ffffff")];
    button.titleLabel.font = kFont(17);
    [button setBackgroundColor:kColor(@"#8458D0")];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [footerView addSubview:button];
    
    @weakify(self);
    [button bk_addEventHandler:^(id sender) {
        @strongify(self);
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kYFBFriendCurrentUserKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.launchViewController;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kWidth(670), kWidth(88)));
    }];
    return footerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBSettingSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBSettingSectionTypeNotice) {
        return YFBSettingNoticeTypeCount;
    } else if (section == YFBSettingSectionTypeFunction) {
        return YFBSettingFunctionTypeCount;
    } else if (section == YFBSettingSectionTypeCache) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSettingCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section == YFBSettingSectionTypeNotice) {
        if (indexPath.row == YFBSettingNoticeTypeNew) {
            cell.title = @"新消息提醒";
            cell.settingType = YFBSettingCellTypeSwitch;
            cell.functionOpen = YES;
        } else if (indexPath.row == YFBSettingNoticeTypeShake) {
            cell.title = @"震动提醒";
            cell.settingType = YFBSettingCellTypeSwitch;
            cell.functionOpen = YES;
        } else if (indexPath.row == YFBSettingNoticeTypeVoice) {
            cell.title = @"声音提醒";
            cell.settingType = YFBSettingCellTypeSwitch;
            cell.functionOpen = YES;
        } else if (indexPath.row == YFBSettingNoticeTypeBack) {
            cell.title = @"退出消息提醒";
            cell.settingType = YFBSettingCellTypeNotice;
            cell.functionOpen = YES;
        }
    } else if (indexPath.section == YFBSettingSectionTypeFunction) {
        if (indexPath.row == YFBSettingFunctionTypeChange)  {
            cell.title = @"修改密码";
            cell.settingType = YFBSettingCellTypeNone;
        } else if (indexPath.row == YFBSettingFunctionTypeAdvise) {
            cell.title = @"意见反馈";
            cell.settingType = YFBSettingCellTypeNone;
        } else if (indexPath.row == YFBSettingFunctionTypeActivity) {
            cell.title = @"活动相关";
            cell.settingType = YFBSettingCellTypeNone;
        } else if (indexPath.row == YFBSettingFunctionTypeAbout) {
            cell.title = @"关于";
            cell.settingType = YFBSettingCellTypeNone;
        }
    } else if (indexPath.section == YFBSettingSectionTypeCache) {
        cell.title = @"清除缓存";
        cell.settingType = YFBSettingCellTypeNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kWidth(20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBSettingSectionTypeNotice && indexPath.row == YFBSettingNoticeTypeBack) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (indexPath.section == YFBSettingSectionTypeFunction) {
        if (indexPath.row == YFBSettingFunctionTypeChange) {
            YFBPasswordVC *passwordVC = [[YFBPasswordVC alloc] initWithTitle:@"修改密码"];
            [self.navigationController pushViewController:passwordVC animated:YES];
        } else if (indexPath.row == YFBSettingFunctionTypeAdvise) {
            YFBAdviseVC *adviseVC = [[YFBAdviseVC alloc] initWithTitle:@"意见反馈"];
            [self.navigationController pushViewController:adviseVC animated:YES];
        } else if (indexPath.row == YFBSettingFunctionTypeActivity) {
            YFBActivityVC *activityVC = [[YFBActivityVC alloc] initWithTitle:@"活动相关"];
            [self.navigationController pushViewController:activityVC animated:YES];
        } else if (indexPath.row == YFBSettingFunctionTypeAbout) {
            YFBAboutVC *aboutVC = [[YFBAboutVC alloc] initWithTitle:@"关于"];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    } else if (indexPath.section == YFBSettingSectionTypeCache) {
        [[SDImageCache sharedImageCache] clearMemory];
    }
}

@end
