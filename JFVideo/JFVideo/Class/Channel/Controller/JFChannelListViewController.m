//
//  JFChannelListViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelListViewController.h"
#import "JFChannelViewController.h"

#import "JFChannelModel.h"
#import "JFChannelColumnModel.h"
#import "JFChannelCell.h"

#define edgeInsets UIEdgeInsetsMake(kScreenHeight * 30 /1334., kScreenWidth * 18 /750., kScreenHeight * 30 /1334., kScreenWidth * 18 /750.)

static NSString *const kChannelCellReusableIdentifier = @"ChannelCellReusableIdentifier";

@interface JFChannelListViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    NSInteger _page;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JFChannelModel *channelModel;
@end

@implementation JFChannelListViewController

DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(JFChannelModel, channelModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kScreenHeight * 45 / 1334.;
    layout.minimumInteritemSpacing = kScreenWidth * 45 / 750.;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JFChannelCell class] forCellWithReuseIdentifier:kChannelCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_layoutCollectionView JF_addPullToRefreshWithHandler:^{
        [self loadMoreDataWithRefresh:YES];
    }];
    
    
    [_layoutCollectionView JF_addVIPNotiRefreshWithHandler:^{
        if (![JFUtil isVip]) {
            [self payWithInfo:nil];
            [_layoutCollectionView JF_endPullToRefresh];
        } else {
            [_layoutCollectionView JF_pagingRefreshNoMoreData];
        }
    }];
    
    [_layoutCollectionView JF_triggerPullToRefresh];
    @weakify(self);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView JF_triggerPullToRefresh];
            }];
        }
    });;
    
}

- (void)loadMoreDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.channelModel fetchChannelInfoWithPage:_page CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        [_layoutCollectionView JF_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView reloadData];
        }
//        else {
//            if (self.dataSource.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self->_layoutCollectionView JF_triggerPullToRefresh];
//                }];
//            }
//        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellReusableIdentifier forIndexPath:indexPath];
    
    JFChannelColumnModel *column = self.dataSource[indexPath.item];
    if (indexPath.item < self.dataSource.count) {
        cell.title = column.name;
        cell.imgUrl = column.columnImg;
        cell.rankCount = indexPath.item;
        cell.hotCount = column.columnDesc;
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JFChannelColumnModel *column = self.dataSource[indexPath.item];
        JFChannelViewController *channelVC = [[JFChannelViewController alloc] initWithColumnId:column.columnId ColumnName:column.name];
        channelVC.column = column;
        [self.navigationController pushViewController:channelVC animated:YES];
        
        JFBaseModel *baseModel = [[JFBaseModel alloc] init];
        baseModel.realColumnId = @(column.realColumnId);
        baseModel.channelType = @(column.type);
        baseModel.programLocation = indexPath.item;
        [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - edgeInsets.left - edgeInsets.right)/2;
    const CGFloat height = width * 432 / 336.;
    return CGSizeMake((long)width , (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return edgeInsets;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JFStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forSlideCount:1];
    
}
@end
