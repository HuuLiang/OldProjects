//
//  YFBGreetingVC.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBGreetingVC.h"
#import "YFBGreetingCell.h"
#import "YFBGreetingHeaderView.h"
#import "YFBRobot.h"
#import "YFBGreetingInfoModel.h"
#import "YFBInteractionManager.h"

static NSString *const kYFBGreetingCellReusableIdentifier = @"kYFBGreetingCellReusableIdentifier";
static NSString *const kYFBGreetingHeaderReusableIdentifier = @"kYFBGreetingHeaderReusableIdentifier";


@interface YFBGreetingVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *layoutCollectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) YFBGreetingInfoModel *greetInfoModel;
@end

@implementation YFBGreetingVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(YFBGreetingInfoModel, greetInfoModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [kColor(@"#000000") colorWithAlphaComponent:0.4];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = kWidth(10);
    self.layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = kColor(@"#ffffff");
    [_layoutCollectionView registerClass:[YFBGreetingCell class] forCellWithReuseIdentifier:kYFBGreetingCellReusableIdentifier];
    [_layoutCollectionView registerClass:[YFBGreetingHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kYFBGreetingHeaderReusableIdentifier];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [self.view addSubview:_layoutCollectionView];
    
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(345*2), kWidth(414*2)));
        }];
    }
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)loadData {
    @weakify(self);
    [self.greetInfoModel fetchGreetingInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            if (!self) {
                return ;
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self->_layoutCollectionView reloadData];
        }
    }];
}

- (void)showInViewController:(UIViewController *)viewController {
    BOOL anySpreadBanner = [viewController.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([viewController.view.subviews containsObject:self.view]) {
        return ;
    }
    

    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    self.view.alpha = 0;
    [viewController.view addSubview:self.view];
    [self didMoveToParentViewController:viewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)hide {
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count < 3 ? self.dataSource.count : 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBGreetingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBGreetingCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count - 1) {
        YFBRobot *info = self.dataSource[indexPath.item + 1];
        cell.imageUrl = info.portraitUrl;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        YFBGreetingHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kYFBGreetingHeaderReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        headerView.greeingBlock = ^{
            @strongify(self);
            //批量打招呼 并退出推荐弹窗
            [[YFBInteractionManager manager] greetWithUserInfoList:self.dataSource toAllUsers:YES handler:^(BOOL success) {
               
            }];
            [self hide];
        };
        YFBRobot *info = [self.dataSource firstObject];
        if (info) {
            headerView.backImageUrl = info.onKeyGreetImgUrl;
            headerView.frontImageUrl = info.portraitUrl;
        }
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kWidth(345*2), kWidth(292*2));
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(kWidth(16), kWidth(8), kWidth(10), kWidth(8));
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < self.dataSource.count) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        return CGSizeMake((long)width, (long)width);
    }
    return CGSizeZero;
}

@end
