//
//  JYSystemHelperViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSystemHelperViewController.h"
#import "JYSystemHelperCell.h"
#import "JYCharacterModel.h"

static NSInteger const kDefaultItemSizes = 6;
static NSString *const kSystemHelperCellIdentifier = @"jy_system_helper_cell_identifier";
static NSString *const kSystemHelperHeaderCellIdentifier = @"jy_system_helper_header_cell_identifier";
static NSString *const kSystemHelperFooterCellIdentifier = @"jy_system_helper_footer_cell_identifier";
static NSString *const kSystemHelperYesterdayKeyName   = @"kSystemHelperYesterdayKeyName";

@interface JYSystemHelperViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_layoutCollectiongView;
}
@property (nonatomic) JYCharacterModel *characterModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation JYSystemHelperViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(JYCharacterModel, characterModel)


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#efefef");
    self.navigationItem.title = @"红娘助手";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kWidth(40);
    layout.minimumLineSpacing = kWidth(28);
    _layoutCollectiongView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectiongView.backgroundColor = kColor(@"#ffffff");
    _layoutCollectiongView.delegate = self;
    _layoutCollectiongView.dataSource = self;
    [_layoutCollectiongView registerClass:[JYSystemHelperCell class] forCellWithReuseIdentifier:kSystemHelperCellIdentifier];
    [_layoutCollectiongView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSystemHelperHeaderCellIdentifier];
    [_layoutCollectiongView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSystemHelperFooterCellIdentifier];
    [self.view addSubview:_layoutCollectiongView];
    {
        [_layoutCollectiongView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(1);
        }];
    }
    
    //不是今天  网络请求数据
    //是今天  读取缓存
    if (![JYUtil isTodayWithKeyName:kSystemHelperYesterdayKeyName]) {
        [self loadData];
    } else {
        [self.dataSource addObjectsFromArray:[JYCharacter findAll]];
        [_layoutCollectiongView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    @weakify(self);
    [self.characterModel fetchChararctersInfoWithRobotsCount:6 CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [obj enumerateObjectsUsingBlock:^(JYCharacter *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.matchCount = arc4random() % 30 + 71;
                [obj saveOrUpdate];
                [self.dataSource addObject:obj];
            }];
            [self->_layoutCollectiongView reloadData];
        }
        [self->_layoutCollectiongView JY_endPullToRefresh];
    }];
}


#pragma mark UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView  {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return kDefaultItemSizes;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JYSystemHelperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSystemHelperCellIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.dataSource.count) {
            JYCharacter *character = self.dataSource[indexPath.item];
            cell.imageUrl = character.logoUrl;
            cell.matchRate = character.matchCount;
        }
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat width = (kScreenWidth - kWidth(40)*2 - kWidth(90)*2)/3.;
        return CGSizeMake((long)width, (long)(width+kWidth(50)));
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSystemHelperHeaderCellIdentifier forIndexPath:indexPath];
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (indexPath.section == 0) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
            titleLabel.text = @"红娘今日配对";
            titleLabel.textColor = kColor(@"#333333");
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:titleLabel];
            {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view);
                    make.left.right.mas_equalTo(view);
                    make.height.mas_equalTo(kWidth(30));
                }];
            }
            return view;
        } else if (indexPath.section == 1) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
            titleLabel.text = @"系统消息";
            titleLabel.textColor = kColor(@"#333333");
            titleLabel.textAlignment = NSTextAlignmentLeft;;
            [view addSubview:titleLabel];
            {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view);
                    make.left.equalTo(view).offset(kWidth(30));
                    make.height.mas_equalTo(kWidth(30));
                }];
            }
            return view;
        }
    } else if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSystemHelperFooterCellIdentifier forIndexPath:indexPath];
            view.backgroundColor = kColor(@"#efefef");
            return view;
        }
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, kWidth(90), kWidth(10), kWidth(90));
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(kScreenWidth, kWidth(80.));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, kWidth(20));
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.item < self.dataSource.count) {
            JYCharacter *character = self.dataSource[indexPath.item];
            [self pushDetailViewControllerWithUserId:character.userId time:nil distance:nil nickName:character.nickName];
        }
    }
}

@end
