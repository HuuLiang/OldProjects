//
//  YFBNearVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBNearVC.h"
#import "YFBRecommendCell.h"
#import "YFBDiscoverModel.h"
#import "YFBGreetingInfoModel.h"
#import "YFBRobot.h"
#import "YFBInteractionManager.h"
#import "YFBExampleManager.h"
#import <MJRefresh.h>

static NSString *const kYFBNearCellReusableIdentifier = @"kYFBNearCellReusableIdentifier";

@interface YFBNearVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBDiscoverModel *discoverModel;
@property (nonatomic,strong) YFBRmdNearByDtoModel *response;
@property (nonatomic,strong) UIButton   *greetAllButton;
@end

@implementation YFBNearVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBDiscoverModel, discoverModel)
QBDefineLazyPropertyInitialization(YFBRmdNearByDtoModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#ffffff");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:kColor(@"#E6E6E6")];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.rowHeight = kWidth(200);
    [_tableView registerClass:[YFBRecommendCell class] forCellReuseIdentifier:kYFBNearCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(108));
        }];
    }
    
    [self configFooterView];
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithPageCount:1 refresh:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kYFBNearRefreshKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
        
    NSString *vipNotice = nil;
    BOOL loadOver = [[[NSUserDefaults standardUserDefaults] objectForKey:kYFBRecommendRefreshKeyName] boolValue];
    if (loadOver) {
        vipNotice = @"—————— 我是有底线的 ——————";
    } else {
        vipNotice = @"上拉加载更多";
    }
    
    __block MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.response.pageNum < self.response.pageCount) {
            self.response.pageNum++;
        } else {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:kYFBRecommendRefreshKeyName] boolValue]) {
                [[YFBHudManager manager] showHudWithText:@"所有数据加载完成"];
                [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kYFBRecommendRefreshKeyName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [refreshFooter setTitle:@"—————— 我是有底线的 ——————" forState:MJRefreshStateIdle];
            }
            [self->_tableView YFB_endPullToRefresh];
            return ;
        }
        [self loadDataWithPageCount:self.response.pageNum refresh:NO];
    }];
    [refreshFooter setTitle:vipNotice forState:MJRefreshStateIdle];
    
    
    _tableView.footer = refreshFooter;
    
    [_tableView YFB_triggerPullToRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithPageCount:(NSInteger)pageNum refresh:(BOOL)isRefresh {
    @weakify(self);
    [self.discoverModel fetchUserInfoWithType:kYFBFriendDiscoverNearbyKeyName pageNum:pageNum CompletionHandler:^(BOOL success, NSArray<YFBRobot *> *realEvalUserList, YFBRmdNearByDtoModel *rmdNearbyDto) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            if (!self) {
                return ;
            }
            self.response = rmdNearbyDto;
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            [realEvalUserList enumerateObjectsUsingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.greeted = [YFBRobot checkUserIsGreetedWithUserId:obj.userId];
                [self.dataSource addObject:obj];
            }];
            
            [rmdNearbyDto.userList enumerateObjectsUsingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.greeted = [YFBRobot checkUserIsGreetedWithUserId:obj.userId];
                [self.dataSource addObject:obj];
            }];
        }
        [self setAutoDistance];
        [self->_tableView reloadData];
    }];
}

- (void)setAutoDistance {
    __block CGFloat distance = 1.1f;
    [self.dataSource enumerateObjectsUsingBlock:^(YFBRobot *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        QBLog(@"%f",distance);
        distance = distance + (float)(arc4random() % 10)/100 + 0.02;
        obj.distance = distance;
    }];
}

- (void)configFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = kColor(@"#efefef");
    self.greetAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_greetAllButton setTitle:@"群打招呼" forState:UIControlStateNormal];
    [_greetAllButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    [_greetAllButton setImage:[UIImage imageNamed:@"discover_allgreet"] forState:UIControlStateNormal];
    [_greetAllButton setBackgroundColor:kColor(@"#8458D0")];
    _greetAllButton.titleLabel.font = kFont(17);
    _greetAllButton.layer.cornerRadius = 4;
    _greetAllButton.layer.masksToBounds = YES;
    [footerView addSubview:_greetAllButton];
    @weakify(self);
    [_greetAllButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        //批量打招呼
        [[YFBInteractionManager manager] greetWithUserInfoList:self.dataSource toAllUsers:YES handler:^(BOOL success) {
            if (success) {
                [self->_tableView reloadData];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_greetAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(kWidth(263*2), kWidth(72)));
    }];
    
    footerView.size = CGSizeMake(kScreenWidth, kWidth(108));
    
    UIEdgeInsets imageEdge = _greetAllButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = _greetAllButton.titleEdgeInsets;
    
    _greetAllButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left - 5, imageEdge.bottom, imageEdge.right + 5);
    _greetAllButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left + 5 , titleEdge.bottom, titleEdge.right - 5);

    [self.view addSubview:footerView];
    
    {
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_tableView.mas_bottom);
        }];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBNearCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *info = self.dataSource[indexPath.row];
        cell.userNameStr = info.nickName;
        cell.userImgUrl = info.portraitUrl;
        cell.userAge  = [NSString stringWithFormat:@"%ld岁",(long)info.age];
        cell.userHeight = info.height;
        cell.distance = info.distance;
        cell.userSex = [info.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
        cell.cityStr = info.city;
        cell.greeted = info.greeted;
        @weakify(self);
        cell.greeting = ^(id sender) {
            @strongify(self);
            UIButton *thisButton = (UIButton *)sender;
            if (!thisButton.isSelected) {
                thisButton.selected = YES;
                //打招呼
                [[YFBInteractionManager manager] greetWithUserInfoList:@[info] toAllUsers:NO handler:^(BOOL success) {
                    if (success) {
                        info.greeted = YES;
                        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:info];
                        [self->_tableView reloadData];
                    }
                }];
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        [self pushIntoDetailVC:robot.userId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(198);
}

@end
