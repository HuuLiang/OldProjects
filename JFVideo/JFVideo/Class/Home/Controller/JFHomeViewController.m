//
//  JFHomeViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFHomeViewController.h"
#import <SDCycleScrollView.h>
#import "iCarousel.h"

#import "JFHomeModel.h"
#import "JFHomeColumnModel.h"
#import "JFHomeProgramModel.h"

#import "JFHomeSectionHeaderView.h"
#import "JFHomeCell.h"
#import "JFHomeHotCell.h"

#import "JFDetailViewController.h"
#import "JFVersionUpdateModel.h"
#import "JFVersionUpdateViewController.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";
static NSString *const kHomeHotCellReusableIdentifier = @"HomeHotCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kHomeSectionHeaderReusableIdentifier = @"HomeSectionHeaderReusableIdentifier";

@interface JFHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    UICollectionViewCell *_bannerCell;
    
    SDCycleScrollView *_bannerView;
//    iCarousel *_bannerView;
    
//    NSTimer *_timer;
//    NSInteger _index;
    BOOL _userTouch;
    
    NSInteger _page;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableArray *titlesGroup;
@property (nonatomic) NSMutableArray *imageUrlGroup;

@property (nonatomic ,retain) JFHomeModel *homeModel;
@property (nonatomic,retain)JFHomeColumnModel *bannerColumn;
@end

@implementation JFHomeViewController
DefineLazyPropertyInitialization(JFHomeModel, homeModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(NSMutableArray, titlesGroup)
DefineLazyPropertyInitialization(NSMutableArray, imageUrlGroup)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self examineUpdate];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    _bannerView.pageDotImage = [UIImage imageNamed:@"home_current_page"];
//    _bannerView.currentPageDotImage = [UIImage imageNamed:@"home_other_page"];
//    _bannerView.currentPageDotColor = [UIColor colorWithHexString:@"#ffffff"];
    
    
//    _bannerView = [[iCarousel alloc] init];
//    _bannerView.delegate = self;
//    _bannerView.dataSource = self;
//    _bannerView.scrollSpeed = 0.8;
//    _bannerView.type = iCarouselTypeRotary;
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeIcarouselIndex) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate distantFuture]];
    
    [_bannerView aspect_hookSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIScrollView *scrollView, BOOL decelerate){
        [[JFStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forBanner:self.bannerColumn.columnId == 0 ? nil : @(self.bannerColumn.columnId) withSlideCount:1];
    
    } error:nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JFHomeCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JFHomeHotCell class] forCellWithReuseIdentifier:kHomeHotCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JFHomeSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeSectionHeaderReusableIdentifier];
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
    });
    
}

- (void)examineUpdate {
    [[JFVersionUpdateModel sharedModel] fetchLatestVersionWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            JFVersionUpdateInfo *info = obj;
            if (info.up.boolValue) {
                JFVersionUpdateViewController *updateVC = [[JFVersionUpdateViewController alloc] init];
                updateVC.linkUrl = info.linkUrl;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:updateVC animated:YES completion:nil];
            }
        }
    }];

}

- (void)loadMoreDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.homeModel fetchHomeInfoWithPage:1 /*isRefresh ? _page = 1 : ++_page*/  CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            [self removeCurrentRefreshBtn];
            [self.dataSource removeAllObjects];
            for (JFHomeColumnModel *model in obj) {
                if (model.type == 4 || model.programList.count > 0) {
                    [self.dataSource addObject:model];
                }
            }
//            [self.dataSource addObjectsFromArray:obj];
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
//            [_bannerView reloadData];
//            [self startScrollBannerView];
        }
//        else {
//            if (self.dataSource.count == 0) {
//                
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self->_layoutCollectionView JF_triggerPullToRefresh];
//                }];
//                
//            }
//        }
        [_layoutCollectionView JF_endPullToRefresh];
    
    }];
}

- (void)refreshBannerView {
    [self.imageUrlGroup removeAllObjects];
    [self.titlesGroup removeAllObjects];
    for (JFHomeColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            self.bannerColumn = column;
            for (JFHomeProgramModel *program in column.programList) {
                [self.imageUrlGroup addObject:program.coverImg];
                [self.titlesGroup addObject:program.title.length > 10 ? [NSString stringWithFormat:@"%@...",[program.title substringToIndex:10]] : program.title];
            }
        }
    }
    
    _bannerView.imageURLStringsGroup = _imageUrlGroup;
    _bannerView.titlesGroup = _titlesGroup;
//    _index = 0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JFHomeColumnModel *column = self.dataSource[section];
    if (column.type == 4) {
        return 1;
    } else {
        return column.programList.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    JFHomeHotCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeHotCellReusableIdentifier forIndexPath:indexPath];
    
    JFHomeColumnModel *column = _dataSource[indexPath.section];
    JFHomeProgramModel *program = column.programList[indexPath.item];
    
    if (column.type == 4) {
        if (!_bannerCell) {
            _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell.contentView);
                }];
            }
        }
        return _bannerCell;
    } else {
        if (indexPath.item < column.programList.count) {
            if (column.type == 5) {
                cell.imgUrl = program.coverImg;
                cell.title = program.title;
                cell.isFree = [program.spec isEqual:@(4)];
                return cell;
            } else if (column.type == 1) {
                hotCell.imgUrl = program.coverImg;
                hotCell.title = program.title;
                hotCell.isFree = [program.spec isEqual:@(4)];
                return hotCell;
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JFHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
    JFHomeColumnModel *column = self.dataSource[indexPath.section];
    if (indexPath.section != 0 || column.type != 5) {
        headerView.titleStr = column.name;
        headerView.section = indexPath.section;
    }    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        [_timer setFireDate:[NSDate distantFuture]];
//    }
    JFHomeColumnModel *column = _dataSource[indexPath.section];
    JFHomeProgramModel *program = column.programList[indexPath.item];
    
    JFBaseModel *baseModel = [[JFBaseModel alloc] init];
    baseModel.realColumnId = @(column.realColumnId);
    baseModel.channelType = @(column.type);
    baseModel.programId = @(program.programId);
    baseModel.programType = @(program.type);
    baseModel.programLocation = indexPath.item;
    baseModel.spec = [program.spec integerValue];
//    [self playVideoWithInfo:baseModel videoUrl:program.videoUrl];
    JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:column.columnId ProgramId:program.programId];
    detailVC.baseModel = baseModel;
    [self.navigationController pushViewController:detailVC animated:YES];

    [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel programLocation:indexPath.item andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFHomeColumnModel *column = self.dataSource[indexPath.section];
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    if (column.type == 4) {
        return CGSizeMake(fullWidth, fullWidth/2);
    } else if (column.type == 5) {
        const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
        const CGFloat height = width*0.8;
        return CGSizeMake(width, height);
    } else {
        const CGFloat width = (fullWidth - 2*layout.minimumLineSpacing - insets.left - insets.right)/3;
        const CGFloat height = width * 300 / 227.+30;
        return CGSizeMake(width , height);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JFHomeColumnModel *column = self.dataSource[section];
    if (column.type == 4) {
        return UIEdgeInsetsMake(0, 0, 5, 0);
    } else if (column.type == 5) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else if (column.type == 1) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, kScreenHeight * 86 / 1334.);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    for (JFHomeColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            JFHomeProgramModel * program = column.programList[index];

       
            JFBaseModel *baseModel = [[JFBaseModel alloc] init];
            baseModel.realColumnId = @(column.realColumnId);
            baseModel.channelType = @(column.type);
            baseModel.programId = @(program.programId);
            baseModel.programType = @(program.type);
            baseModel.programLocation = index;
            baseModel.spec = [program.spec integerValue];
//            [self playVideoWithInfo:baseModel videoUrl:program.videoUrl];
            JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:column.columnId ProgramId:program.programId];
            detailVC.baseModel = baseModel;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel programLocation:index andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JFStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forSlideCount:1];

}

//#pragma mark - iCarouselDelegate iCarouselDataSource
//
//- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
//    return self.imageUrlGroup.count;
//}
//
//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
//    UIView *itemView = [[UIView alloc] init];
//    itemView.backgroundColor = [UIColor redColor];
//    itemView.frame = CGRectMake(0, 0, kScreenWidth - 20, (kScreenWidth - 20)/2.);
//    itemView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
//    itemView.layer.borderWidth = kScreenWidth * 4 /750.;
//    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlGroup[index]]];
//    [itemView addSubview:imageView];
//    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = self.titlesGroup[index];
//    titleLabel.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.45];;
//    titleLabel.font = [UIFont systemFontOfSize:kScreenWidth * 32 / 750.];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
//    [itemView addSubview:titleLabel];
//    
//    {
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(itemView);
//        }];
//        
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(itemView);
//            make.height.mas_equalTo(kScreenHeight * 60 /1334.);
//        }];
//    }
//    return itemView;
//}

//- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset{
//    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
//    
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = ica.perspective;
//    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
//    return CATransform3DTranslate(transform, 0.0, 0.0, offset * ica.itemWidth);
//}

//- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
//    return kScreenWidth* 1.35;
//}
//
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
//    DLog(@"_index = %ld",index);
//
//    for (JFHomeColumnModel *column in self.dataSource) {
//        if (column.type == 4) {
//            JFHomeProgramModel * program = column.programList[index];
//            
//            JFBaseModel *baseModel = [[JFBaseModel alloc] init];
//            baseModel.realColumnId = @(column.realColumnId);
//            baseModel.channelType = @(column.type);
//            baseModel.programId = @(program.programId);
//            baseModel.programType = @(program.type);
//            baseModel.programLocation = index;
//            
//            JFDetailViewController *detailVC = [[JFDetailViewController alloc] initWithColumnId:column.columnId ProgramId:program.programId];
//            detailVC.baseModel = baseModel;
//            [self.navigationController pushViewController:detailVC animated:YES];
//            
//            [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel programLocation:index andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
//        }
//    }
//}
//
//- (void)startScrollBannerView {
//    [_timer setFireDate:[NSDate distantPast]];
//}
//
//
//- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
//    DLog(@"currentIndex:%ld",[_bannerView currentItemIndex]);
//    _index = [_bannerView currentItemIndex];
//    _index++;
//}
//
//- (void)sendIsUserGesture:(BOOL)isGesture {
//    if (isGesture) {
//        [_timer setFireDate:[NSDate distantFuture]];
//    } else {
//        [self performSelector:@selector(startScrollBannerView) withObject:self afterDelay:2];
//    }
//}
//
//- (void)changeIcarouselIndex {
//    if (_index == self.imageUrlGroup.count) {
//        _index = 0;
//        [_bannerView scrollToItemAtIndex:_index++ duration:1.];
//    } else {
//        [_bannerView scrollToItemAtIndex:_index++ duration:1.];
//    }
//    DLog(@"%ld",_index);
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    UITouch * touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    if (touchPoint.y < kScreenWidth / 2.) {
//        _userTouch = YES;
//    }
//}
@end
