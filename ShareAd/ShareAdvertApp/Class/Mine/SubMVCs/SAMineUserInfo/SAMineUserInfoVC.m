//
//  SAMineUserInfoVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineUserInfoVC.h"
#import "SAMineUserInfoHeaderView.h"
#import "SAMineUserInfoCell.h"
#import "QBPhotoManager.h"
#import "QBImageUploadManager.h"

#import "SAReqManager.h"
#import "SAUserInfoModel.h"
#import "SAShareManager.h"

static NSString *const kSAMineUserInfoCellReusableIdentifier = @"kSAMineUserInfoCellReusableIdentifier";

//static NSString *const kSAUserInfoWeixinKeyName              = @"Weixin";
//static NSString *const kSAuserInfoAliPayKeyName              = @"aliPay";
//static NSString *const kSAUserInfoNameKeyName                = @"name";
//static NSString *const kSAUserInfoNickNameKeyName            = @"nickName";
//static NSString *const kSAUserInfoPhoneKeyName               = @"phone";
//static NSString *const kSAUserInfoSexKeyName                 = @"sex";
//static NSString *const kSAUserInfoCityKeyName                = @"city";
//static NSString *const kSAUserInfoMasterKeyName              = @"masterId";

typedef NS_ENUM(NSInteger,SAMineUserInfoRow) {
    SAMineUserInfoRowWX = 0,
    SAMineUserInfoRowAli,
    SAMineUserInfoRowName,
    SAMineUserInfoRowNick,
    SAMineUserInfoRowPhone,
    SAMineUserInfoRowSex,
    SAMineUserInfoRowCity,
    SAMineUserInfoRowMaster,
    SAMineUserInfoRowCount
};


@interface SAMineUserInfoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SAMineUserInfoHeaderView *headerView;
@property (nonatomic) CGFloat selectedTextFieldHeight;
@property (nonatomic) NSArray *userInfoKeys;
@end

@implementation SAMineUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    [_tableView registerClass:[SAMineUserInfoCell class] forCellReuseIdentifier:kSAMineUserInfoCellReusableIdentifier];
    _tableView.tableHeaderView = [self configHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    self.userInfoKeys = @[@"weixin",@"aliPay",@"name",@"nickName",@"phone",@"sex",@"city",@"masterId"];
    
    if (_type == SAPushUserInfoVCTypeWx) {
        //登录微信获取成功 刷新界面
        if ([SAUser user].openId.length == 0) {
            [self.view beginLoading];
            [[SAShareManager manager] fetchUserInfoWithWx:^(BOOL success, id obj) {
                [self.view endLoading];
                if (success) {
                    [self updateOpenId];
                }
            }];
        } else {
            if ([SAUser user].weixin.length == 0) {
                [[SAHudManager manager] showHudWithText:@"请输入微信号完成绑定"];
            }
        }
    } else {
        [self fetchUserInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchUserInfo {
    @weakify(self);
    [[SAReqManager manager] fetchUserInfoWithUserId:[SAUser user].userId class:[SAUserInfoModel class] handler:^(BOOL success, SAUserInfoModel * userInfoModel) {
        @strongify(self);
        if (success) {
            [[SAUser user] setValueWithObj:userInfoModel.user];
            [[SAUser user] update];
            [self.tableView reloadData];
        }
    }];
}

- (UIView *)configHeaderView {
    self.headerView = [[SAMineUserInfoHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(220));
    _headerView.portraitUrl = [SAUser user].portraitUrl;
    _headerView.userId = [SAUser user].userId;
    @weakify(self);
    _headerView.changeImgAction = ^{
        @strongify(self);
        [[QBPhotoManager manager] getImageInCurrentViewController:self handler:^(UIImage *pickerImage, NSString *keyName) {
            NSString *name = [NSString stringWithFormat:@"%@_avatar.jpg", [[NSDate date] stringWithFormat:KDateFormatLong]];
            [QBImageUploadManager uploadImage:pickerImage withName:name completionHandler:^(BOOL success, id obj) {
                if (success) {
                    [SAUser user].portraitUrl = name;
                    [[SAUser user] update];
                    self.headerView.portraitUrl = name;
                }
            }];
        }];
    };
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self updateUserInfoAll:YES indexPath:nil];
}

- (void)updateUserInfoAll:(BOOL)allInfo indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId":[SAUser user].userId}];
    __block NSMutableDictionary *userInfoDics = [[NSMutableDictionary alloc] init];
    
    __block SAUser *user = [SAUser user];
    NSArray *allUserProperties = user.allProperties;
    
    //获取cell里的更新内容
    if (allInfo) {
        for (NSInteger cellRow = 0; cellRow < SAMineUserInfoRowCount; cellRow++) {
            [userInfoDics addEntriesFromDictionary:[self updateUserInfoAtIndexPath:[NSIndexPath indexPathForRow:cellRow inSection:0]]];
        }
    } else {
        [userInfoDics addEntriesFromDictionary:[self updateUserInfoAtIndexPath:indexPath]];
    }
    
    [userInfoDics enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull userInfokey, id  _Nonnull userInfoValue, BOOL * _Nonnull stop) {
        [allUserProperties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //如果在修改内容的字典里找到用户的属性key
            if ([obj isEqualToString:userInfokey]) {
                //判断值是否相等 不相等才提交更新  相等就从userInfoDics里移除
                if ([userInfoValue isEqualToString:[user valueForKey:userInfokey]]) {
                    [userInfoDics removeObjectForKey:userInfokey];
                }
            }
        }];
    }];
    
    if (userInfoDics.allKeys.count == 0) {
        return;
    }
    
    [params addEntriesFromDictionary:userInfoDics];
    
    [[SAReqManager manager] updateUserInfoWithInfo:params class:[SAUserInfoModel class] handler:^(BOOL success, id obj) {
        if (success) {
            [userInfoDics enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull userInfokey, id  _Nonnull userInfoValue, BOOL * _Nonnull stop) {
                [allUserProperties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:userInfokey]) {
                        [user setValue:userInfoValue forKey:userInfokey];
                    }
                }];
            }];
            [user update];
        }
    }];
}

- (NSDictionary *)updateUserInfoAtIndexPath:(NSIndexPath *)indexPath {
    SAMineUserInfoCell *cell = (SAMineUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *cellContent = nil;
    if (!cell.content) {
        cellContent = @"";
    } else {
        cellContent = cell.content;
    }
    return @{_userInfoKeys[indexPath.row]:cellContent};
}

- (void)updateOpenId {
    @weakify(self);
    [self.view beginLoading];
    [[SAReqManager manager] updateUserInfoWithInfo:@{@"userId":[SAUser user].userId , @"openid":[SAUser user].openId} class:[SAUserInfoModel class] handler:^(BOOL success, id obj) {
        @strongify(self);
        [self.view endLoading];
        if (success) {
            [self.tableView reloadData];
            if ([SAUser user].weixin.length == 0) {
                [[SAHudManager manager] showHudWithText:@"请输入微信号完成最后绑定"];
            } else if ([SAUser user].weixin.length > 0) {
                [[SAHudManager manager] showHudWithText:@"绑定成功"];
            }
        } else {
            [SAUser user].openId = @"";
        }
        [[SAUser user] update];
    }];

}

- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    [self.tableView setContentOffset:CGPointMake(0, - 64) animated:YES];
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (endFrame.origin.y - 64 - 70.0 > _selectedTextFieldHeight) {
        return;
    }
    CGFloat offsetY = _selectedTextFieldHeight - (endFrame.origin.y - 70.0) - 64;
    QBLog(@"keyBoardOriginY:%f \n selectedTextFieldHeight:%f \n offsetY:%f",endFrame.origin.y,_selectedTextFieldHeight,offsetY);
    [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SAMineUserInfoRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMineUserInfoCell *cell  = [tableView dequeueReusableCellWithIdentifier:kSAMineUserInfoCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row == SAMineUserInfoRowWX) {
        cell.title = @"绑定微信";
        cell.content = [SAUser user].weixin;
    } else if (indexPath.row == SAMineUserInfoRowAli) {
        cell.title = @"绑定支付宝";
        cell.content = [SAUser user].aliPay;
    } else if (indexPath.row == SAMineUserInfoRowName) {
        cell.title = @"真实姓名";
        cell.content = [SAUser user].name;
    } else if (indexPath.row == SAMineUserInfoRowNick) {
        cell.title = @"昵称";
        cell.content = [SAUser user].nickName;
    } else if (indexPath.row == SAMineUserInfoRowPhone) {
        cell.title = @"手机";
        cell.content = [SAUser user].phone;
    } else if (indexPath.row == SAMineUserInfoRowSex) {
        cell.title = @"性别";
        cell.content = [SAUser user].sex;
    } else if (indexPath.row == SAMineUserInfoRowCity) {
        cell.title = @"城市";
        cell.content = [SAUser user].city;
    } else if (indexPath.row == SAMineUserInfoRowMaster) {
        cell.title = @"师傅ID";
        cell.content = [NSString stringWithFormat:@"%ld",(long)[SAUser user].masterId];
    }
    
    @weakify(self);
    cell.action = ^{
        @strongify(self);
        [self updateUserInfoAll:NO indexPath:indexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAMineUserInfoCell *cell = (SAMineUserInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        _selectedTextFieldHeight = kWidth(220) + (indexPath.row + 1)*kWidth(90);
        cell.textFieldResponder = YES;
    }
}

@end
