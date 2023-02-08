//
//  YFBGiftPopView.m
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGiftPopView.h"
#import "YFBGiftPopCell.h"
#import "YFBGiftFooterView.h"
#import "YFBGiftManager.h"

static NSString *const YFBGiftPopCellIdentifier = @"yfb_gift_pop_cell_identifier";

@interface YFBGiftPopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSIndexPath *_selectedIndexPath;
}
@property (nonatomic) YFBGiftFooterView *footerView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) YFBGiftPopViewType type;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation YFBGiftPopView
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithGiftInfos:(NSArray *)giftInfos WithGiftViewType:(YFBGiftPopViewType)type {
    self = [super init];
    
    if (self) {
        
        self.type = type;
        _selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        switch (type) {
            case YFBGiftPopViewTypeList:
                self.backgroundColor = [kColor(@"#A1A1A1") colorWithAlphaComponent:1];
                self.layer.borderColor = [kColor(@"#000000") colorWithAlphaComponent:0.8].CGColor;
                self.layer.borderWidth = 0.5f;
                break;
            case YFBGiftPopViewTypeBlag:
                self.backgroundColor = kColor(@"#ffffff");
                self.layer.borderColor = [kColor(@"#F3B050") colorWithAlphaComponent:1].CGColor;
                self.layer.borderWidth = 2.0f;
                break;
            default:
                break;
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat footerHeight ;
        CGFloat spacing;
        switch (type) {
            case YFBGiftPopViewTypeList:
                flowLayout.minimumInteritemSpacing = 0.5;
                flowLayout.minimumLineSpacing = 0.5;
                footerHeight = kWidth(88);
                spacing = 1;
                break;
                
            case YFBGiftPopViewTypeBlag:
                flowLayout.minimumInteritemSpacing = 1;
                flowLayout.minimumLineSpacing = 1;
                footerHeight = kWidth(40);
                spacing = 3;
                break;
                
            default:
                break;
        }
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YFBGiftPopCell class] forCellWithReuseIdentifier:YFBGiftPopCellIdentifier];
        [self addSubview:_collectionView];
        
        [self.dataSource addObjectsFromArray:[YFBGiftManager manager].giftList];
        
        _footerView = [[YFBGiftFooterView alloc] initWithGiftType:type];
        _footerView.pageNumbers = 2;
        _footerView.diamondCount = [YFBUser currentUser].diamondCount;
        @weakify(self);
        _footerView.sendAction = ^{
            @strongify(self);
            YFBGiftInfo *giftInfo = self.dataSource[self->_selectedIndexPath.item];
            if (self.sendGiftAction) {
                self.sendGiftAction(giftInfo);
            }
        };
        _footerView.payAction = ^{
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        };
        [self addSubview:_footerView];
        {
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(spacing);
                make.top.equalTo(self).offset(spacing);
                make.right.equalTo(self.mas_right).offset(-spacing);
                make.bottom.equalTo(self.mas_bottom).offset(-footerHeight-spacing);
            }];
            
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.top.equalTo(_collectionView.mas_bottom).offset(1);
            }];
        }
    }
    return self;
}

- (void)startSelectedDefaultIndexPath {
    [_collectionView selectItemAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBGiftPopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YFBGiftPopCellIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        YFBGiftInfo *giftInfo = self.dataSource[indexPath.item];
        
        if (_type == YFBGiftPopViewTypeList) {
            cell.defaultColor = [kColor(@"#000000") colorWithAlphaComponent:0.8];
        } else if (_type == YFBGiftPopViewTypeBlag) {
            cell.defaultColor = kColor(@"#EF5F73");
        }
        cell.title = giftInfo.name;
        cell.diamondCount = giftInfo.diamondCount;
        cell.imageUrl = giftInfo.giftUrl;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    if (self.type == YFBGiftPopViewTypeBlag) {
        YFBGiftInfo *giftInfo = self.dataSource[indexPath.item];
        if (giftInfo && self.sendGiftAction) {
            self.sendGiftAction(giftInfo);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat fullHeight = CGRectGetHeight(collectionView.bounds);
    CGFloat itemWidth = ((long)fullWidth - flowLayout.minimumInteritemSpacing * 3) / 4;
    CGFloat itemHeight = ((long)fullHeight - flowLayout.minimumLineSpacing)/2;
    return CGSizeMake((long)itemWidth, (long)itemHeight);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    QBLog(@"%f %f",scrollView.contentOffset.x,CGRectGetWidth(self.bounds));
    if (_footerView) {
        _footerView.currentPage = scrollView.contentOffset.x + 10 / (CGRectGetWidth(self.bounds));
    }
}

- (void)setDiamondCount:(NSInteger)diamondCount {
    _footerView.diamondCount = diamondCount;
}

@end
