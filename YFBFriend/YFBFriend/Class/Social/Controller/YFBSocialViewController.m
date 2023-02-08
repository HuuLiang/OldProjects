//
//  YFBSocialViewController.m
//  YFBFriend
//
//  Created by ZF on 2017/6/5.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBSocialViewController.h"
#import "YFBSliderView.h"
#import "YFBSocialModel.h"
#import "YFBSocialCell.h"
#import "YFBTabBarController.h"
#import "YFBShowWXView.h"
#import "YFBShowPaySuccessView.h"

#import "YFBCommentsVC.h"
#import "YFBBuyServerVC.h"

#import "YFBPhotoBrowse.h"

static NSString *const kYFBSocialCellReusableIdentifier = @"kYFBSocialCellReusableIdentifier";

@interface YFBSocialViewController ()
@property (nonatomic) YFBSliderView *sliderView;
@property (nonatomic) YFBShowPaySuccessView *paySuccessView;
@end

@implementation YFBSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同城服务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sliderView = [[YFBSliderView alloc] init];
    NSArray *titles = @[@"全部服务",@"暖心陪聊",@"线上游戏",@"虚拟女朋友"];
    _sliderView.titlesArr = titles;
    [_sliderView setTabbarHeight:49];
    [self.view addSubview:_sliderView];

    YFBSocialContentViewController *allVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeAll];
    YFBSocialContentViewController *chatVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeChat];
    YFBSocialContentViewController *gameVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGame];
    YFBSocialContentViewController *gfVC = [[YFBSocialContentViewController alloc] initWithSocialType:YFBSocialTypeGF];
    [_sliderView addChildViewController:allVC title:_sliderView.titlesArr[0]];
    [_sliderView addChildViewController:chatVC title:_sliderView.titlesArr[1]];
    [_sliderView addChildViewController:gameVC title:_sliderView.titlesArr[2]];
    [_sliderView addChildViewController:gfVC title:_sliderView.titlesArr[3]];
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBShowChargeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:kYFBSocialPaySuccessNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBHideChargeNotification object:nil];
    [(YFBTabBarController *)self.tabBarController hideActivityView];
}


- (void)paySuccess:(NSNotification *)notification {
    NSString *userId = (NSString *)[notification object];
    YFBSocialInfo *socialInfo = [YFBSocialInfo findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (socialInfo) {
        socialInfo.alreadyPay = YES;
    } else {
        socialInfo = [[YFBSocialInfo alloc] init];
        socialInfo.userId = userId;
        socialInfo.alreadyPay = YES;
        [socialInfo saveOrUpdate];
    }
    
    [self.view beginLoading];
    
    self.paySuccessView = [[YFBShowPaySuccessView alloc] init];
    _paySuccessView.alpha = 0;
    [self.view addSubview:_paySuccessView];
    
    [_paySuccessView showWithPopAnimation];
    
    @weakify(self);
    _paySuccessView.confirmAction = ^{
        @strongify(self);
        [self.view endLoading];
        [self.paySuccessView hiddenWithPopAnimation];
        [self.paySuccessView removeFromSuperview];
        self.paySuccessView = nil;
    };
    
    {
        if ([YFBUtil deviceType] > YFBDeviceType_iPhone5) {
            [self.paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(kWidth(530), kWidth(424)));
            }];
        } else {
            _paySuccessView.frame = CGRectMake(kScreenWidth/2-kWidth(530)/2, kScreenHeight/2-kWidth(424)/2-kWidth(150), kWidth(530), kWidth(424));
        }
        
    }
    
}


@end



@interface YFBSocialContentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) YFBSocialType socialType;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray <YFBSocialInfo *> *dataSource;
@property (nonatomic) NSMutableArray *heights;
@property (nonatomic) YFBSocialModel *socialModel;
@property (nonatomic) YFBShowWXView *wxView;
@end

@implementation YFBSocialContentViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBSocialModel, socialModel)
QBDefineLazyPropertyInitialization(NSMutableArray, heights)

- (instancetype)initWithSocialType:(YFBSocialType)socialType {
    self = [super init];
    if (self) {
        _socialType = socialType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[YFBSocialCell class] forCellReuseIdentifier:kYFBSocialCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self getSocialContent];
    }];
    
    [_tableView YFB_addPagingRefreshWithNotice:@"—————— 我是有底线的 ——————" Handler:^{
        @strongify(self);
        [self.tableView YFB_endPullToRefresh];
    }];
    
    [_tableView YFB_triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:kYFBSocialPaySuccessNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getSocialContent {
    @weakify(self);
    [self.socialModel fetchSocialContentWithType:_socialType CompletionHandler:^(BOOL success, NSArray <YFBSocialInfo *> * cityServices) {
        @strongify(self);
        [self.tableView YFB_endPullToRefresh];
        if (success) {
            [self calculateContentHeightWithSource:cityServices];
            [self.tableView reloadData];
        }
    }];
}

- (void)calculateContentHeightWithSource:(NSArray <YFBSocialInfo *> *)cityLists {
    [self.dataSource removeAllObjects];
    [self.heights removeAllObjects];
    
    __block NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];

    [cityLists enumerateObjectsUsingBlock:^(YFBSocialInfo * _Nonnull socialInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat cellHeight = 0;
        cellHeight = cellHeight + kWidth(34) + kWidth(80); // 头像高度
        //文字动态高度
        CGFloat descHeight = [socialInfo.describe sizeWithFont:kFont(14) maxWidth:kWidth(560)].height;
        if (descHeight / kFont(14).lineHeight > 3) {
            socialInfo.needShowButton = YES;
            
            //如果文字行数大于3行  则需要隐藏多余的文字 加入查看全文按钮
            cellHeight = cellHeight + kWidth(10) + kFont(14).lineHeight * 3;
            
            // + 按钮高度
            cellHeight = cellHeight + kWidth(10) + kWidth(28);

        } else {
            cellHeight  = cellHeight + kWidth(10) + descHeight;
        }
        
        cellHeight = cellHeight + kWidth(26)+ (kScreenWidth - kWidth(210))/3; //图片高度
        cellHeight = cellHeight + kWidth(56) + kWidth(28) + kWidth(24); //服务评价高度
        
        NSTimeInterval randomTimeInterval = 60 * 60 * (arc4random() % 3 + 3);//每个机器人的第一条评论依次随机减3-5小时
        currentTimeInterval -= randomTimeInterval;
        
        NSTimeInterval commentTimeInterval = currentTimeInterval;
        
        NSMutableArray *commentsArr = [NSMutableArray array];
        for (NSInteger i = 0; i < socialInfo.comments.count; i ++) {
            YFBCommentModel *commentModel = socialInfo.comments[i];
            if (i <= 1) {
                CGFloat commentContentHeight = [commentModel.content sizeWithFont:kFont(12) maxWidth:kWidth(560)].height;
                CGFloat commentHeight = kWidth(24) + kFont(12).lineHeight + kWidth(4) + kFont(11).lineHeight + kWidth(20) + commentContentHeight + kWidth(40);
                cellHeight = cellHeight + commentHeight ;//第一条评价高度
            }
            //同一个机器人的后面的评论依次减0.5-2.5小时
            if (i == 0) {
                commentTimeInterval = commentTimeInterval;
            } else {
                commentTimeInterval = commentTimeInterval -  60 * 60 * (arc4random() % 3 + 0.5);
            }
            commentModel.timeinterval = commentTimeInterval;
            [commentsArr addObject:commentModel];
        }
        socialInfo.comments = commentsArr;
        
        cellHeight = cellHeight + kWidth(80) ; //查看全部评价高度
        [self.heights addObject:@(cellHeight)];

        [self.dataSource addObject:socialInfo];
    }];
}

- (void)paySuccess:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSocialCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section < self.dataSource.count) {
        YFBSocialInfo *socialInfo = self.dataSource[indexPath.section];
        cell.userImgUrl = socialInfo.portraitUrl;
        cell.nickName = socialInfo.nickName;
        cell.serverCount = socialInfo.servNum;
        cell.showAllDesc = socialInfo.showAllDesc;
        cell.descStr = socialInfo.describe;
        cell.imgUrlA = socialInfo.imgUrl1;
        cell.imgUrlB = socialInfo.imgUrl2;
        cell.imgUrlC = socialInfo.imgUrl3;
        if (socialInfo.comments.count > 0) {
            cell.firstCommentModel = socialInfo.comments[0];
        }
        if (socialInfo.comments.count > 1) {
            cell.secondCommentModel = socialInfo.comments[1];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSource.count) {
        YFBSocialInfo *socialInfo = self.dataSource[indexPath.section];
        YFBSocialCell *socialCell = (YFBSocialCell *)cell;
        socialCell.serverRate = socialInfo.star;
        socialCell.needShowButton = socialInfo.needShowButton;
        
        YFBSocialInfo *cacheInfo = [YFBSocialInfo findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",socialInfo.userId]];
        if (cacheInfo) {
            socialCell.alreadyPay = cacheInfo.alreadyPay;
        } else {
            socialCell.alreadyPay = NO;
        }
        
        @weakify(self);
        socialCell.detailAction = ^{
            @strongify(self);
            [self pushIntoDetailVC:socialInfo.userId];
        };
        socialCell.descAction = ^{
            @strongify(self);
            //是否展示全文  如果需要展示 先判断按钮是否存在
            if (!socialInfo.needShowButton) {
                return ;
            }
            //重新计算文字的高度
            if (!socialInfo.showAllDesc) {
                CGFloat descHeight = [socialInfo.describe sizeWithFont:kFont(14) maxWidth:kWidth(560)].height;
                CGFloat originalHeight = [self.heights[indexPath.section] floatValue];
                CGFloat newHeight = originalHeight - kFont(14).lineHeight * 3 + descHeight;
                socialInfo.showAllDesc = YES;
                [self.dataSource replaceObjectAtIndex:indexPath.section withObject:socialInfo];
                [self.heights replaceObjectAtIndex:indexPath.section withObject:@(newHeight)];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                CGFloat descHeight = [socialInfo.describe sizeWithFont:kFont(14) maxWidth:kWidth(560)].height;
                CGFloat originalHeight = [self.heights[indexPath.section] floatValue];
                CGFloat newHeight = originalHeight - descHeight + kFont(14).lineHeight * 3;
                socialInfo.showAllDesc = NO;
                [self.dataSource replaceObjectAtIndex:indexPath.section withObject:socialInfo];
                [self.heights replaceObjectAtIndex:indexPath.section withObject:@(newHeight)];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        
        socialCell.clickImgAction = ^(NSNumber * selectedNum) {
            @strongify(self);
            [[YFBPhotoBrowse browse] showPhotoBrowseWithImageUrl:@[socialInfo.imgUrl1,socialInfo.imgUrl2,socialInfo.imgUrl3] atIndex:[selectedNum integerValue]onSuperView:self.view];
        };
        
        socialCell.wxAction = ^{
            @strongify(self);
            [self.view beginLoading];
            self.wxView  = [[YFBShowWXView alloc] init];
            self.wxView.userImgUrl = socialInfo.portraitUrl;
            self.wxView.nickName = socialInfo.nickName;
            self.wxView.weixin = socialInfo.weixin;
            self.wxView.alpha = 0;
            [self.view addSubview:self.wxView];
            
            if ([YFBUtil deviceType] > YFBDeviceType_iPhone5) {
                [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.size.mas_equalTo(CGSizeMake(kWidth(484), kWidth(286)));
                }];
            } else {
                _wxView.frame = CGRectMake((kScreenWidth - kWidth(484))/2, (kScreenHeight - kWidth(286))/2- kWidth(150), kWidth(484), kWidth(286));
            }
            
            [self.wxView showWithPopAnimation];
            
            @weakify(self);
            _wxView.hideAction = ^{
                @strongify(self);
                [self.view endLoading];
                [self.wxView hiddenWithPopAnimation];
                [self.wxView removeFromSuperview];
                self.wxView = nil;
            };
        };
        
        socialCell.payAction = ^{
            @strongify(self);
            [YFBBuyServerVC showSocialPaymentViewControllerWithInfo:socialInfo.serviceLists userId:socialInfo.userId InCurrentVC:self];
        };
        socialCell.commentAction = ^{
            @strongify(self);
            YFBCommentsVC *commentsVC = [[YFBCommentsVC alloc] initWithComments:socialInfo.comments allServNum:socialInfo.servNum];
            [self.navigationController pushViewController:commentsVC animated:YES];
        };

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.heights.count) {
        return [self.heights[indexPath.section] floatValue];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01f : kWidth(20);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = kColor(@"#efefef");
    return sectionHeaderView;
}

@end


