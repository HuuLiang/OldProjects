//
//  LSJHomeAppVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeAppVC.h"
#import "LSJAppCell.h"
#import "LSJColumnConfigModel.h"
#import "SDCycleScrollView.h"
#import "JQKApplicationManager.h"

static NSString *const kAppCellReusableIdentifier = @"AppCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";

@interface LSJHomeAppVC () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    UITableViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJColumnConfigModel *programModel;
@property (nonatomic) NSNumber *bannerColumId;
@end

@implementation LSJHomeAppVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(LSJColumnConfigModel, programModel)

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[LSJStatsManager sharedManager] statsStopDurationAtTabIndex:self.tabBarController.selectedIndex subTabIndex:4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor whiteColor];
    [_bannerView aspect_hookSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIScrollView *scrollView, BOOL decelerate){
        [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:1 forBanner:self.bannerColumId withSlideCount:1];
    } error:nil];
    
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[LSJAppCell class] forCellReuseIdentifier:kAppCellReusableIdentifier];
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBannerCellReusableIdentifier];
    
    
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    
    [_layoutTableView LSJ_triggerPullToRefresh];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutTableView LSJ_triggerPullToRefresh];
            }];
        }
    });
}

- (void)loadData {
    @weakify(self);
    [self.programModel fetchColumnsInfoWithColumnId:0 IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutTableView LSJ_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            [self.dataSource addObjectsFromArray:obj];
            [self refreshBannerView];
            [_layoutTableView reloadData];
        }
//        else {
//            if (self.dataSource.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self->_layoutTableView LSJ_triggerPullToRefresh];
//                }];
//            }
//        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (LSJColumnModel *column in _dataSource) {
        if (column.type == 4) {
            self.bannerColumId = @(column.columnId);
            for (LSJProgramModel *program in column.programList) {
                [imageUrlGroup addObject:program.coverImg];
                [titlesGroup addObject:program.title];
            }
            _bannerView.imageURLStringsGroup = imageUrlGroup;
            _bannerView.titlesGroup = titlesGroup;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        LSJColumnModel *column = _dataSource[section];
        return column.programList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_bannerCell) {
            _bannerCell = [tableView dequeueReusableCellWithIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell);
                }];
            }
        }
        return _bannerCell;
    } else {
        LSJAppCell *appCell = [tableView dequeueReusableCellWithIdentifier:kAppCellReusableIdentifier forIndexPath:indexPath];
        LSJColumnModel *column = _dataSource[indexPath.section];
        LSJProgramModel *program = column.programList[indexPath.row];
        appCell.imgUrlStr = program.coverImg;
        appCell.titleStr = program.title;
        NSArray *array = [program.spare componentsSeparatedByString:@"|"];
        appCell.sizeStr = array[0];
        appCell.countStr = array[1];
        appCell.detailStr = array[2];
        
        [LSJUtil checkAppInstalledWithBundleId:program.specialDesc completionHandler:^(BOOL isInstalled) {
            appCell.installed = isInstalled;
        }];
        
        return appCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kScreenWidth/2.;
    } else {
        return kScreenWidth * 0.4;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _dataSource.count) {
        LSJColumnModel *column = _dataSource[indexPath.section];
        if (indexPath.row < column.programList.count) {
            LSJProgramModel * program = column.programList[indexPath.item];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.row Spec:NSNotFound subTab:4];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:4];
        }
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    for (LSJColumnModel *column in _dataSource) {
        if (column.type == 4 && index < column.programList.count) {
            LSJProgramModel *program = column.programList[index];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:program.videoUrl]];
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:index Spec:NSNotFound subTab:4];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:4];
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:4 forSlideCount:1];
}

@end
