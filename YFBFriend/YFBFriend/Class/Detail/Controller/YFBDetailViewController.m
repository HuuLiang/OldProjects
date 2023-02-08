//
//  YFBDetailViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBDetailViewController.h"
#import "YFBDetailCell.h"
#import "YFBDetailHeaderView.h"
#import "YFBDetailFooterView.h"
#import "YFBDetailManager.h"
#import "YFBInteractionManager.h"
#import "YFBRobot.h"

typedef NS_ENUM(NSUInteger, YFBDetailSection) {
    YFBDetailSpace = 0, //个人空间
    YFBDetailBaseInfo, //基本资料
    YFBDetailContactInfo,//联系方式
    YFBDetailDetailInfo,//详细资料
    YFBDetailCount
};

typedef NS_ENUM(NSUInteger, YFBDetailSpaceSection) {
    YFBSpaceSectionTitle = 0, //个人空间
    YFBSpaceSectionRecent,   //最近上线时间
    YFBSpaceSectionPurpose,  //交友目的
    YFBSpaceSectionIdea,   //恋爱观念
    YFBSpaceSectionMeeting,  //首次见面希望
    YFBSpaceSectionSite,  //喜欢约会的地点
    YFBSpaceSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailBaseInfoSection) {
    YFBBaseInfoSectionTitle = 0, //基本资料
    YFBBaseInfoSectionNickName, // 昵称
    YFBBaseInfoSectionSex, // 性别
    YFBBaseInfoSectionAge, //年龄
    YFBBaseInfoSectionLive, //居住地
    YFBBaseInfoSectionTall, //身高
    YFBBaseInfoSectionIncome, //收入
    YFBBaseInfoSectionMarr, //婚姻状况
    YFBBaseInfoSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailContactInfoSection) {
    YFBContactInfoSectionTitle = 0, //联系方式
    YFBContactInfoSectionQQ, //qq
    YFBContactInfoSectionPhone, //手机
    YFBContactInfoSectionWX, //微信
    YFBContactInfoSectionCount
};

typedef NS_ENUM(NSUInteger, YFBDetailDetailInfoSection) {
    YFBDetailInfoSectionTitle = 0, //详细资料
    YFBDetailInfoSectionEdu, //学历
    YFBDetailInfoSectionJob, //职业
    YFBDetailInfoSectionBirth, //生日
    YFBDetailInfoSectionWeight,//体重
    YFBDetailInfoSectionStar, //星座
    YFBDetailInfoSectionCount
};

static NSString *const kYFBDetailCellReusableIdentifier = @"YFBDetailCellReusableIdentifier";

@interface YFBDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *_userId;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YFBDetailHeaderView *headerView;
@property (nonatomic,strong) YFBDetailFooterView *footerView;
@property (nonatomic,strong) YFBUserLoginModel *response;
@end

@implementation YFBDetailViewController
QBDefineLazyPropertyInitialization(YFBUserLoginModel, response)

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[YFBDetailCell class] forCellReuseIdentifier:kYFBDetailCellReusableIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#efefef");
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    
    [_tableView YFB_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configTableHeaderView {
    self.headerView = [[YFBDetailHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(418));
    _headerView.userImageUrl = self.response.portraitUrl;
    _headerView.nickName = self.response.nickName;
    _headerView.userId = self.response.userId;
    _headerView.userLocation = self.response.userBaseInfo.city;
    _headerView.distance = @"3km以内";//self.response.distance;
    _headerView.albumCount = arc4random() % 4 + 2;
    _headerView.followCount = self.response.userBaseInfo.concernNum;
    @weakify(self);
    _headerView.clickAction = ^{
        @strongify(self);
        if (![YFBUtil isVip]) {
            [UIAlertView bk_showAlertViewWithTitle:@"您非VIP用户，不可以查看用户相册！可以先给TA打个招呼，等待TA的回复"
                                           message:@""
                                 cancelButtonTitle:@"再等等" otherButtonTitles:@[@"去开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                     if (buttonIndex == 1) {
                                         [self pushIntoPayVC];
                                     }
                                 }];
        }
    };
    _tableView.tableHeaderView = _headerView;
}

- (void)configFooterView {
    self.footerView = [[YFBDetailFooterView alloc] init];
    @weakify(self);
    _footerView.infoType = ^(YFBFooterFunction infoType) {
        @strongify(self);
        if (infoType == YFBFunctionSendMsg) {
            //发信
            if ([YFBUtil isVip]) {
                [self pushIntoMessageVCWithUserId:self.response.userId nickName:self.response.nickName avatarUrl:self.response.portraitUrl];
            } else {
                [UIAlertView bk_showAlertViewWithTitle:@"您非VIP用户，不可以直接发信！可以先给TA打个招呼，等待TA的回复"
                                               message:@""
                                     cancelButtonTitle:@"再等等" otherButtonTitles:@[@"去开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                         if (buttonIndex == 1) {
                                             [self pushIntoPayVC];
                                         }
                }];
            }
        } else if (infoType == YFBFunctionSendGreet) {
            //打招呼
            YFBRobot *robot = [[YFBRobot alloc] init];
            robot.userId = self.response.userId;
            [[YFBInteractionManager manager] greetWithUserInfoList:@[robot] toAllUsers:NO handler:^(BOOL success) {
                if (success) {
                    if (!self) {
                        return ;
                    }
                    [[YFBHudManager manager] showHudWithText:@"打招呼成功"];
                }
            }];
        } else if (infoType == YFBFunctionSendFollow) {
            //关注
            [[YFBInteractionManager manager] concernUserWithUserId:self.response.userId handler:^(BOOL success) {
                if (success) {
                    if (!self) {
                        return ;
                    }
                }
            }];
        }
    };
    [self.view addSubview:_footerView];
    
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(50));
            make.height.mas_equalTo(kWidth(120));
        }];
    }
}

- (void)loadData {
    @weakify(self);
    [[YFBDetailManager manager] fetchDetailInfoWithUserId:self->_userId CompletionHandler:^(BOOL success, YFBUserLoginModel *obj) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            if (!self) {
                return ;
            }
            self.response = obj;
            [self configTableHeaderView];
            [self configFooterView];
            [self->_tableView reloadData];
        }
    }];
}

- (void)configRightBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain handler:^(id sender) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YFBDetailCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == YFBDetailSpace) {
        return YFBSpaceSectionCount;
    } else if (section == YFBDetailBaseInfo) {
        return YFBBaseInfoSectionCount;
    } else if (section == YFBDetailContactInfo) {
        return YFBContactInfoSectionCount;
    } else if (section == YFBDetailDetailInfo) {
        return YFBDetailInfoSectionCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section == YFBDetailSpace) {
        if (indexPath.row == YFBSpaceSectionTitle) {
            cell.title = @"个人空间";
            cell.isTitle = YES;
        } else if (indexPath.row == YFBSpaceSectionRecent) {
            cell.title = @"最近上线时间";
            cell.content = self.response.lastLoginTime;
        } else if (indexPath.row == YFBSpaceSectionPurpose) {
            cell.title = @"交友目的";
            cell.content = self.response.userBaseInfo.friendDestination;
        } else if (indexPath.row == YFBSpaceSectionIdea) {
            cell.title = @"恋爱观念";
            cell.content = self.response.userBaseInfo.loveConcept;
        } else if (indexPath.row == YFBSpaceSectionMeeting) {
            cell.title = @"首次见面希望";
            cell.content = self.response.userBaseInfo.firstMeetHope;
        } else if (indexPath.row == YFBSpaceSectionSite) {
            cell.title = @"喜欢约会的地点";
            cell.content = self.response.userBaseInfo.datePlace;
        }
    } else if (indexPath.section == YFBDetailBaseInfo) {
        if (indexPath.row == YFBBaseInfoSectionTitle) {
            cell.title = @"基本资料";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBBaseInfoSectionNickName) {
            cell.title = @"昵称";
            cell.content = self.response.nickName;
        } else if (indexPath.row == YFBBaseInfoSectionSex) {
            cell.title = @"性别";
            cell.content = [self.response.userBaseInfo.gender isEqualToString:@"M"] ? @"男" : @"女";
        } else if (indexPath.row == YFBBaseInfoSectionAge) {
            cell.title = @"年龄";
            cell.content = [NSString stringWithFormat:@"%ld岁",self.response.userBaseInfo.age];
        } else if (indexPath.row == YFBBaseInfoSectionLive) {
            cell.title = @"居住市";
            cell.content = self.response.userBaseInfo.city;
        } else if (indexPath.row == YFBBaseInfoSectionTall) {
            cell.title = @"身高";
            cell.content = [NSString stringWithFormat:@"%ldcm",self.response.userBaseInfo.height];
        } else if (indexPath.row == YFBBaseInfoSectionIncome) {
            cell.title = @"月收入";
            cell.content = self.response.userBaseInfo.monthlyIncome;
        } else if (indexPath.row == YFBBaseInfoSectionMarr) {
            cell.title = @"婚姻状况";
            cell.content = self.response.userBaseInfo.marriageStatus == YFBUserfiance ? @"未婚" : @"已婚";
        }
    } else if (indexPath.section == YFBDetailContactInfo) {
        if (indexPath.row == YFBContactInfoSectionTitle) {
            cell.title = @"联系方式";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBContactInfoSectionQQ) {
            cell.title = @"QQ";
            cell.content = self.response.userBaseInfo.qq;//@"仅对钻石VIP开放";
        } else if (indexPath.row == YFBContactInfoSectionPhone) {
            cell.title = @"手机号";
            cell.content = self.response.userBaseInfo.mobilePhone;//@"仅对钻石VIP开放";
        } else if (indexPath.row == YFBContactInfoSectionWX) {
            cell.title = @"微信";
            cell.content = self.response.userBaseInfo.weixin;//@"仅对钻石VIP开放";
        }
    } else if (indexPath.section == YFBDetailDetailInfo) {
        if (indexPath.row == YFBDetailInfoSectionTitle) {
            cell.title = @"详细资料";
            cell.isTitle = kColor(@"#999999");
        } else if (indexPath.row == YFBDetailInfoSectionEdu) {
            cell.title = @"学历";
            cell.content = self.response.userBaseInfo.education;
        } else if (indexPath.row == YFBDetailInfoSectionJob) {
            cell.title = @"职业";
            cell.content = self.response.userBaseInfo.vocation;
        } else if (indexPath.row == YFBDetailInfoSectionBirth) {
            cell.title = @"生日";
            cell.content = self.response.userBaseInfo.birthday;
        } else if (indexPath.row == YFBDetailInfoSectionWeight) {
            cell.title = @"体重";
            cell.content = [NSString stringWithFormat:@"%ldkg",self.response.userBaseInfo.weight];
        } else if (indexPath.row == YFBDetailInfoSectionStar) {
            cell.title = @"星座";
            cell.content = self.response.userBaseInfo.constellation;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(24);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == YFBDetailDetailInfo ? kWidth(24) : 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *shadowView = (UITableViewHeaderFooterView *)view;
    shadowView.backgroundView.backgroundColor = kColor(@"#efefef");
}

@end
