//
//  JYCharacterViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYCharacterViewController.h"
#import "JYCharacterCell.h"
#import "JYDetailViewController.h"
#import "JYCharacterModel.h"
#import "JYLocalVideoUtils.h"

static NSString *const kCharacterCellReusableIdentifier = @"CharacterCellReusableIdentifier";
static NSInteger kPageSize = 12;
static NSInteger kRefreshTimeInterval = 60;//两次下拉刷新的时间间隔60s

@interface JYCharacterViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSInteger currentPage;
}
@property (nonatomic) JYCharacterModel *characterModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) BOOL isFirstRefresh;//是否是每次启动第一次加载
@property (nonatomic) NSString *refreshTime;//刷新时间控制

@end

@implementation JYCharacterViewController
QBDefineLazyPropertyInitialization(JYCharacterModel, characterModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstRefresh = YES;
    currentPage = 1;
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(10);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JYCharacterCell class] forCellWithReuseIdentifier:kCharacterCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        if (self.isFirstRefresh) {
            [self loadModelWithIsRefresh:YES];
        }else {
            NSInteger timeInterval = [JYLocalVideoUtils dateTimeDifferenceWithStartTime:self.refreshTime endTime:[JYLocalVideoUtils currentTime]];
            if (timeInterval > kRefreshTimeInterval) {
                [self loadDataWithRefresh:YES];
            }else {
                [self->_layoutCollectionView JY_triggerPullToRefresh];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self->_layoutCollectionView JY_endPullToRefresh];
                });
            }
        }
    }];
    
    [_layoutCollectionView JY_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadModelWithIsRefresh:NO];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.characterModel fetchChararctersInfoWithRobotsCount:12 CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            self.refreshTime = [JYLocalVideoUtils currentTime];
            [self refreshFetchReplaceModelWithModels:obj needCounts:3];//随机去三个模型替换
            [self->_layoutCollectionView reloadData];
        }
        [self->_layoutCollectionView JY_endPullToRefresh];
    }];
}

- (void)loadModelWithIsRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.characterModel fetchFiguresWithPage:currentPage++ pageSize:kPageSize completeHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            self.isFirstRefresh = NO;
            self.refreshTime = [JYLocalVideoUtils currentTime];
            if (isRefresh) {
                [self.dataSource removeAllObjects];
            }
            if (obj.count == 0) {
                currentPage = 1;
            }
            [self.dataSource addObjectsFromArray:obj];
            [self->_layoutCollectionView reloadData];
        }
        [self->_layoutCollectionView JY_endPullToRefresh];
    }];
}
/**
 随机取三个模型替换
 */
- (void)refreshFetchReplaceModelWithModels:(NSArray *)model needCounts:(NSInteger)needCounts {
    
    NSMutableArray *userIds = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self.dataSource enumerateObjectsUsingBlock:^(JYCharacter *character, NSUInteger idx, BOOL * _Nonnull stop) {
        if (character.userId) {
            [userIds addObject:character.userId];
        }
    }];
    NSMutableArray *needModes = [NSMutableArray arrayWithCapacity:needCounts];
    while (needModes.count <needCounts) {
          int random = arc4random_uniform((int)model.count);
        JYCharacter *character = model[random];
        if (![userIds containsObject:character.userId]) {
            [needModes addObject:character];
            [userIds addObject:character.userId];
        }
    }
    
    for (int i = 0; i< needCounts; i++) {
        int key = self.dataSource.count < 15 ? (int)self.dataSource.count : 15;
        int random = arc4random_uniform(key);
        [self.dataSource replaceObjectAtIndex:random withObject:needModes[i]];
    }
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYCharacterCell *characterCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCharacterCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        JYCharacter *character = self.dataSource[indexPath.item];
        characterCell.userImgStr = character.logoUrl;
        characterCell.nickNameStr = character.nickName;
        characterCell.ageStr = [NSString stringWithFormat:@"%@",character.age];
    }
    return characterCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < self.dataSource.count) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        CGFloat height = width * 13 / 11;
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(15), kWidth(20), kWidth(15));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JYCharacter *character = self.dataSource[indexPath.item];
        [self pushDetailViewControllerWithUserId:character.userId time:nil distance:nil nickName:character.nickName];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
