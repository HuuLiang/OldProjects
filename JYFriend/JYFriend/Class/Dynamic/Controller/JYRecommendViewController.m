//
//  JYRecommendViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRecommendViewController.h"
#import "JYRecommendCell.h"
#import "JYRecommendHeaderView.h"
#import "JYRecommendFooterView.h"
#import "JYCharacterModel.h"
#import "JYUserCreateMessageModel.h"
#import "JYContactModel.h"
#import "JYAutoContactManager.h"
#import "JYUserCreateMessageModel.h"

static NSString *const kRecommendCellReusableIdentifier = @"RecommendCellReusableIdentifier";
static NSString *const kRecommendHeaderViewReusableIdentifier = @"RecommendHeaderViewReusableIdentifier";
static NSString *const kRecommendFooterViewReusableIdentifier = @"RecommendFooterViewReusableIdentifier";


@interface JYRecommendViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    UIButton         *_closeBtn;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JYCharacterModel *characterModel;
@property (nonatomic) JYUserGreetModel *userGreetModel;
@end

@implementation JYRecommendViewController
QBDefineLazyPropertyInitialization(JYCharacterModel, characterModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(JYUserGreetModel, userGreetModel)


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kScreenWidth*0.8 * 2 / 30;
    mainLayout.minimumInteritemSpacing = kScreenWidth*0.8 * 1 / 30;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = kColor(@"#ffffff");
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    _layoutCollectionView.scrollEnabled = NO;
    [_layoutCollectionView registerClass:[JYRecommendCell class] forCellWithReuseIdentifier:kRecommendCellReusableIdentifier];
    [_layoutCollectionView registerClass:[JYRecommendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRecommendHeaderViewReusableIdentifier];
        [_layoutCollectionView registerClass:[JYRecommendFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kRecommendFooterViewReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"dynamic_close_icon"] forState:UIControlStateNormal];
    [self.view addSubview:_closeBtn];
    
    @weakify(self);
    [_closeBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kScreenWidth*0.8 * 18 / 30 + kWidth(300)));
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_layoutCollectionView.mas_right).offset(-kWidth(14));
            make.bottom.equalTo(_layoutCollectionView.mas_top);
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(82)));
        }];
    }
    
    
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadData {
    @weakify(self);
    [self.characterModel fetchChararctersInfoWithRobotsCount:6 CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self->_layoutCollectionView reloadData];
        }
        [self->_layoutCollectionView JY_endPullToRefresh];
    }];
}


- (void)showInViewController:(UIViewController *)viewController {
    BOOL anyRecommendView = [viewController.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anyRecommendView) {
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


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYRecommendCell *recommendCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        JYCharacter *character = self.dataSource[indexPath.item];
        recommendCell.selected = YES;
        recommendCell.userImgStr = character.logoUrl;
        recommendCell.isSelected = YES;
    }
    return recommendCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JYRecommendHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRecommendHeaderViewReusableIdentifier forIndexPath:indexPath];
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        JYRecommendFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kRecommendFooterViewReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        footerView.refreshAction = ^(id obj) {
            @strongify(self);
            //刷新数据
            [self reloadData];
        };
        footerView.recommendAction = ^(id obj) {
            @strongify(self);
            //批量打招呼 完成之后关闭弹窗
            NSMutableArray *userIdList = [[NSMutableArray alloc] init];
            NSMutableArray *selectedUsers = [[NSMutableArray alloc] init];
            [self.dataSource enumerateObjectsUsingBlock:^(JYCharacter *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < 6) {
                    if (obj.isSelected) {
                        [userIdList addObject:obj.userId];
                        [selectedUsers addObject:obj];
                    }
                }
            }];
            
            //如果用户没有选择任何招呼机器人 那么立即关闭推荐
            if (userIdList.count == 0) {
                [self hide];
                return ;
            }
            //先向消息列表中加入选中的机器人的打招呼语言
            [JYContactModel insertGreetContact:selectedUsers];
            //向服务器请求打招呼机器人的回复信息
            [self.userGreetModel fetchRobotsReplyMessagesWithBatchRobotId:userIdList CompletionHandler:^(BOOL success, id obj) {
                @strongify(self);
                if (success) {
                    //把返回的机器人及其回复信息放入缓存 定时取出并且推送给用户
                    [[JYAutoContactManager manager] saveReplyRobots:obj];
                }
                //关闭推荐
                [self hide];
            }];
        };
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth * 0.8, kWidth(100));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth * 0.8, kWidth(200));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < 6) {
        return CGSizeMake(kScreenWidth*0.8 * 8 / 30, kScreenWidth*0.8 * 8 / 30);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(0), kScreenWidth*0.8 * 2 / 30, kWidth(0), kScreenWidth*0.8 * 2 / 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JYRecommendCell *recommendCell = (JYRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
        recommendCell.isSelected = !recommendCell.isSelected;
        
        JYCharacter *character = self.dataSource[indexPath.item];
        character.isSelected = recommendCell.isSelected;
        [self.dataSource replaceObjectAtIndex:indexPath.item withObject:character];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}


@end
