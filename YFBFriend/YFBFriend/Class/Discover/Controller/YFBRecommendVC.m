//
//  YFBRecommendVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRecommendVC.h"
#import "YFBRecommendCell.h"
#import "YFBDiscoverModel.h"
#import "YFBGreetingInfoModel.h"
#import "YFBRobot.h"
#import "YFBInteractionManager.h"
#import <MJRefresh.h>

static NSString *const kYFBRecommendCellReusableIdentifier = @"kYFBRecommendCellReusableIdentifier";

@interface YFBRecommendVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBDiscoverModel *discoverModel;
@property (nonatomic,strong) YFBRmdNearByDtoModel *response;
@end

@implementation YFBRecommendVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBDiscoverModel, discoverModel)
QBDefineLazyPropertyInitialization(YFBRmdNearByDtoModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:kColor(@"#E6E6E6")];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.rowHeight = kWidth(200);
    [_tableView registerClass:[YFBRecommendCell class] forCellReuseIdentifier:kYFBRecommendCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithPageCount:1 refresh:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kYFBRecommendRefreshKeyName];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataSource.count > 0) {
        [self checkDataSource];
        [_tableView reloadData];
    }
}

- (void)checkDataSource {
    [self.dataSource enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.greeted = [YFBRobot checkUserIsGreetedWithUserId:obj.userId];
        [self.dataSource replaceObjectAtIndex:idx withObject:obj];
    }];
}

- (void)loadDataWithPageCount:(NSInteger)pageNum refresh:(BOOL)isRefresh {
    @weakify(self);
    [self.discoverModel fetchUserInfoWithType:kYFBFriendDiscoverRecommendKeyName pageNum:pageNum CompletionHandler:^(BOOL success, NSArray<YFBRobot *> *realEvalUserList, YFBRmdNearByDtoModel *rmdNearbyDto) {
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
            [rmdNearbyDto.userList enumerateObjectsUsingBlock:^(YFBRobot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.greeted = [YFBRobot checkUserIsGreetedWithUserId:obj.userId];
                [self.dataSource addObject:obj];
            }];
        }
        [self->_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRecommendCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *info = self.dataSource[indexPath.row];
        cell.userNameStr = info.nickName;
        cell.userImgUrl = info.portraitUrl;
        cell.userAge  = [NSString stringWithFormat:@"%ld岁",(long)info.age];
        cell.userHeight = info.height;
        cell.userSex = [info.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
        cell.cityStr = info.city;
        cell.greeted = info.greeted;
        @weakify(self);
        cell.greeting = ^(id sender) {
            @strongify(self);
            UIButton *thisButton = (UIButton *)sender;
            //打招呼
            [[YFBInteractionManager manager] greetWithUserInfoList:@[info] toAllUsers:NO handler:^(BOOL success) {
                if (success) {
                    if (!self) {
                        return ;
                    }
                    info.greeted = YES;
                    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:info];
                    [self->_tableView reloadData];
                }
            }];
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
