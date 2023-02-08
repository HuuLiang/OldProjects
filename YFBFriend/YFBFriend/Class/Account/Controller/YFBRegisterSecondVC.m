//
//  YFBRegisterSecondVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRegisterSecondVC.h"
#import "YFBSetAvatarView.h"
#import "YFBRegisterDetailCell.h"
#import "ActionSheetPicker.h"
#import "YFBTabBarController.h"
#import "YFBPhotoManager.h"
#import "YFBImageUploadManager.h"
#import "YFBAccountManager.h"
#import "AppDelegate.h"

static NSString *const kYFBRegisterDetailCellReusableIdentifier = @"kYFBRegisterDetailCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, YFBRegisterDetailRow) {
    YFBRegisterDetailJobRow, //职业
    YFBRegisterDetailEduRow, //学历
    YFBRegisterDetailIncomeRow, //收入
    YFBRegisterDetailTallRow, //身高
    YFBRegisterDetailMarrRow, //婚姻
    YFBRegisterDetailCount
};

@interface YFBRegisterSecondVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton    *registerButton;
@property (nonatomic,strong) YFBSetAvatarView *avatarView;
@end

@implementation YFBRegisterSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setSeparatorColor:kColor(@"#D7D7D7")];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setRowHeight:kWidth(88)];
    [_tableView registerClass:[YFBRegisterDetailCell class] forCellReuseIdentifier:kYFBRegisterDetailCellReusableIdentifier];
    _tableView.backgroundColor = kColor(@"#efefef");
    
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self configUserDetailHeaderViewAndFooterView];
}

- (void)configUserDetailHeaderViewAndFooterView {
    @weakify(self);
    _avatarView = [[YFBSetAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(420))
                                                   action:^{
                                                       @strongify(self);
                                                       [[YFBPhotoManager manager] getImageInCurrentViewController:self handler:^(UIImage *pickerImage, NSString *keyName) {
                                                           [self->_avatarView setUserImg:pickerImage];
                                                           NSString *name = [NSString stringWithFormat:@"%@_avatar.jpg", [[NSDate date] stringWithFormat:KDateFormatLong]];
                                                           [YFBImageUploadManager uploadImage:pickerImage withName:name completionHandler:^(BOOL success, id obj) {
                                                               if (success) {
                                                                   [YFBUser currentUser].userImage = obj;
                                                                   [[YFBHudManager manager] showHudWithText:@"头像上传成功"];
                                                               } else {
                                                                   [[YFBHudManager manager] showHudWithText:@"头像上传失败"];
                                                               }
                                                           }];
                                                       }];
                                                   }];
    
    self->_tableView.tableHeaderView = _avatarView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(842), kScreenWidth, kWidth(88))];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
    [_registerButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    [_registerButton setBackgroundColor:kColor(@"#8558D0")];
    _registerButton.layer.cornerRadius = kWidth(6);
    _registerButton.layer.masksToBounds = YES;
    [footerView addSubview:_registerButton];
    
    [_registerButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self registerUser];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(kWidth(670), kWidth(88)));
        }];
    }
    
    self->_tableView.tableFooterView = footerView;
}

- (void)registerUser {
    @weakify(self);
    
    [[YFBAccountManager manager] registerUserWithUserInfo:[YFBUser currentUser] handler:^(BOOL success) {
        @strongify(self);
        if (success) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self presentViewController:appDelegate.contentViewController animated:YES completion:^ {
                [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.contentViewController;
                [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            }];
        } else {
            [[YFBHudManager manager] showHudWithText:@"注册失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([YFBUser currentUser].userImage.length > 0) {
        self->_avatarView.imageUrl = [YFBUser currentUser].userImage;
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return YFBRegisterDetailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRegisterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRegisterDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row == YFBRegisterDetailJobRow) {
        cell.title = @"职业";
    } else if (indexPath.row == YFBRegisterDetailEduRow) {
        cell.title = @"学历";
    } else if (indexPath.row == YFBRegisterDetailIncomeRow) {
        cell.title = @"收入";
    } else if (indexPath.row == YFBRegisterDetailTallRow) {
        cell.title = @"身高";
    } else if (indexPath.row == YFBRegisterDetailMarrRow) {
        cell.title = @"婚姻";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.row == YFBRegisterDetailJobRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"职业"
                                                rows:[YFBUser allUserJob]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                               [YFBUser currentUser].job = selectedValue;
                                           } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == YFBRegisterDetailEduRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"学历"
                                                rows:[YFBUser allUserEdu]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                               [YFBUser currentUser].education = selectedValue;
                                           } cancelBlock:nil origin:self.view];

    } else if (indexPath.row == YFBRegisterDetailIncomeRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"收入"
                                                rows:[YFBUser allUserIncome]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                               [YFBUser currentUser].income = selectedValue;
                                           } cancelBlock:nil origin:self.view];

    } else if (indexPath.row == YFBRegisterDetailTallRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"身高(:cm)"
                                                rows:[YFBUser allUserHeight]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                               [YFBUser currentUser].height = [selectedValue integerValue];
                                           } cancelBlock:nil origin:self.view];
    } else if (indexPath.row == YFBRegisterDetailMarrRow) {
        [ActionSheetStringPicker showPickerWithTitle:@"婚姻"
                                                rows:[YFBUser allUserMarr]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [self configRegisterDetailCellWithSelectedValue:selectedValue indexPath:indexPath];
                                               [YFBUser currentUser].marriageStatus = selectedIndex;
                                           } cancelBlock:nil origin:self.view];
    }
}

- (void)configRegisterDetailCellWithSelectedValue:(id)selectedValue indexPath:(NSIndexPath *)indexPath {
    YFBRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
    cell.content = selectedValue;
}

@end
