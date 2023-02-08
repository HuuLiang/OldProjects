//
//  YFBRankVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBRankVC.h"
#import "YFBSliderView.h"
#import <MJRefresh.h>

@interface YFBRankVC ()
@property (nonatomic,strong) YFBSliderView *sliderView;
@end

@implementation YFBRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sliderView = [[YFBSliderView alloc] init];
    _sliderView.tabbarHeight = 49;
    _sliderView.backgroundColor = kColor(@"#efefef");
    _sliderView.titlesArr = @[@"土豪榜",@"魅力榜"];
    [self.view addSubview:_sliderView];
    
    YFBRankDetailVC *rankSendVC = [[YFBRankDetailVC alloc] initWithRankType:YFBRankTypeSend];
    [_sliderView addChildViewController:rankSendVC title:_sliderView.titlesArr.firstObject];
    
    YFBRankDetailVC *rankReceiveVC = [[YFBRankDetailVC alloc] initWithRankType:YFBRankTypereceived];
    [_sliderView addChildViewController:rankReceiveVC title:_sliderView.titlesArr.lastObject];
    
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    _sliderView.titleScrollView.backgroundColor = kColor(@"#efefef");
}

@end

#pragma mark - ---------------榜单详情------------------

#import "YFBRankDetailCell.h"
#import "YFBRobot.h"
#import "YFBRankModel.h"

static NSString *const kYFBRankDetailCellReusableIdentifier = @"YFBRankDetailCellReusableIdentifier";

@interface YFBRankDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) YFBRankType rankType;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBRankModel * rankModel;
@property (nonatomic,strong) YFBRankFentYunListModel *response;
@property (nonatomic,strong) UIButton       *rankButton;
@end

@implementation YFBRankDetailVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBRankModel, rankModel)
QBDefineLazyPropertyInitialization(YFBRankFentYunListModel, response)

- (instancetype)initWithRankType:(YFBRankType)type
{
    self = [super init];
    if (self) {
        _rankType = type;
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = kColor(@"#ffffff");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YFBRankDetailCell class] forCellReuseIdentifier:kYFBRankDetailCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView.hidden = YES;
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithPageCount:1 refresh:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kYFBRankRefreshKeyName];
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

- (void)loadDataWithPageCount:(NSInteger)pageNum refresh:(BOOL)isRefresh {
    @weakify(self);
    NSString *type = nil;
    if (_rankType == YFBRankTypereceived) {
        type = kYFBFriendRankReceiveCountKeyName;
    } else if (_rankType == YFBRankTypeSend) {
        type = kYFBFriendRankSendCountKeyName;
    }
    self->_tableView.tableHeaderView.hidden = YES;
    [self.rankModel fetchRankListInfoWithType:type pageNum:pageNum CompletionHandler:^(BOOL success, YFBRankFentYunListModel * obj) {
        @strongify(self);
        [self->_tableView YFB_endPullToRefresh];
        if (success) {
            if (!self) {
                return ;
            }
            self->_tableView.tableFooterView.hidden = NO;
            self.response = obj;
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:obj.userList];
        }
        self->_tableView.tableHeaderView.hidden = NO;
        [self->_tableView reloadData];
    }];
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] init];
    self.rankButton = [[UIButton alloc] init];
    [_rankButton setTitle:@"本周排名" forState:UIControlStateNormal];
    [_rankButton setTitleColor:kColor(@"#999999") forState:UIControlStateNormal];
    _rankButton.titleLabel.font = kFont(14);
    [_rankButton setImage:[UIImage imageNamed:@"login_choose"] forState:UIControlStateNormal];
    [headerView addSubview:_rankButton];
    
    NSString *typeStr;
    NSInteger count;
    if (_rankType == YFBRankTypeSend) {
        typeStr = @"送出多少：";
        count = self.response.sendGiftCount;
    } else {
        typeStr = @"收到多少：";
        count = self.response.recvGiftCount;
    }
    NSString *rankStr = [NSString stringWithFormat:@"%@%ld",typeStr,count];
    UILabel *rankTypeLabel = [[UILabel alloc] init];
    rankTypeLabel.font = kFont(12);
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:rankStr attributes:@{NSForegroundColorAttributeName:kColor(@"#97BCF0")}];
    NSRange range = [rankStr rangeOfString:typeStr];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:kColor(@"#999999")} range:range];
    rankTypeLabel.attributedText = attriStr;
    [headerView addSubview:rankTypeLabel];
    
    {
        [_rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView.mas_left).offset(kWidth(40));
            make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(30)));
        }];
        
        [rankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView.mas_right).offset(-kWidth(200));
            make.height.mas_equalTo(kWidth(30));
        }];
    }
    headerView.size = CGSizeMake(kScreenWidth, kWidth(72));
    return headerView;
}

- (void)viewDidLayoutSubviews {
    UIEdgeInsets imageEdge = _rankButton.imageEdgeInsets;
    UIEdgeInsets titleEdge = _rankButton.titleEdgeInsets;
    
    _rankButton.imageEdgeInsets = UIEdgeInsetsMake(imageEdge.top, imageEdge.left + kWidth(120), imageEdge.bottom, imageEdge.right-kWidth(120));
    _rankButton.titleEdgeInsets = UIEdgeInsetsMake(titleEdge.top, titleEdge.left - kWidth(20) , titleEdge.bottom, titleEdge.right + kWidth(20));
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBRankDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBRankDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        cell.index = indexPath.row;
        cell.userImageUrl = robot.portraitUrl;
        cell.nickName = robot.nickName;
        cell.userSex = [robot.gender isEqualToString:@"M"] ? YFBUserSexMale : YFBUserSexFemale;
        cell.age = [NSString stringWithFormat:@"%ld岁",(long)robot.age];
        cell.distance = [NSString stringWithFormat:@"%ldkm",(long)robot.distance];
        cell.rankType = _rankType;
        cell.giftCount = _rankType == YFBRankTypeSend ? robot.sendGiftCount : robot.recvGiftCount;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(138);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSource.count) {
        YFBRobot *robot = self.dataSource[indexPath.row];
        [self pushIntoDetailVC:robot.userId];
    }
}

@end
