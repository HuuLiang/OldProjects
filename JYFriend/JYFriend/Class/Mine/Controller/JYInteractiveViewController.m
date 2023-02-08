//
//  JYInteractiveViewController.m
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYInteractiveViewController.h"
#import "JYPhotoCollectionViewCell.h"
#import "JYInteractiveModel.h"


static CGFloat const kLineSpace = 15.;
static CGFloat const kitemSpace = 8.;
static NSString *kVisitePhotoCellIdentifier = @"kvisite_photo_cell_identifier";

@interface JYInteractiveViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    JYMineUsersType usersType;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JYInteractiveModel *interactiveModel;
@end

@implementation JYInteractiveViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(JYInteractiveModel, interactiveModel)

- (instancetype)initWithType:(JYMineUsersType)type {
    self = [super init];
    if (self) {
        usersType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = nil;
    if (usersType == JYMineUsersTypeFollow) {
        title = @"关注";
    } else if (usersType == JYMineUsersTypeFans) {
        title = @"粉丝";
    } else if (usersType == JYMineUsersTypeVisitor) {
        title = @"访问我的人";
    }
    self.title = title;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(kLineSpace *2);
    layout.minimumInteritemSpacing = kWidth(kitemSpace *2);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [_layoutCollectionView registerClass:[JYPhotoCollectionViewCell class] forCellWithReuseIdentifier:kVisitePhotoCellIdentifier];
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(kWidth(30), kWidth(30), kWidth(10), kWidth(30));
    [self.view addSubview:_layoutCollectionView];
    
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.interactiveModel fetchInteractiveInfoWithType:usersType CompletionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [JYUtil setInteractiveCount:obj.count WithUserType:usersType];
        }
        [self->_layoutCollectionView reloadData];
        [self->_layoutCollectionView JY_endPullToRefresh];
    }];
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVisitePhotoCellIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        JYInteractiveUser *interactiveUser = self.dataSource[indexPath.item];
        cell.imageUrl = interactiveUser.logoUrl;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - kWidth(kLineSpace *2)*2 - kWidth(kitemSpace *2)*3) /4.;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JYInteractiveUser *user = self.dataSource[indexPath.item];
        [self pushDetailViewControllerWithUserId:user.userId time:nil distance:nil nickName:nil];
    }
}

@end
