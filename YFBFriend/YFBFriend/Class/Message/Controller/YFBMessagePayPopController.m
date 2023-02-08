//
//  YFBMessagePayPopController.m
//  YFBFriend
//
//  Created by Liang on 2017/4/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessagePayPopController.h"

#import "YFBMessagePayPointCell.h"
#import "YFBMessagePayTypeCell.h"

#import "YFBMessageDiamondCategoryCell.h"
#import "YFBMessageDiamondPayTypeCell.h"
#import "YFBMessageDiamondToPayCell.h"

#import "YFBDiamondManager.h"
#import "YFBPayConfigManager.h"
#import "YFBPaymentManager.h"

typedef NS_ENUM(NSUInteger, YFBPopViewSection) {
    YFBPopViewSectionPayPoint = 0,
    YFBPopViewSectionPayType,
    YFBPopViewSectionCount
};

typedef NS_ENUM(NSUInteger,YFBPopViewDiamondSection) {
    YFBPopViewDiamondSectionCategory,
    YFBPopViewDiamondSectionType,
    YFBPopViewDiamondSectionPay,
    YFBPopViewDiamondSectionCount
};

typedef NS_ENUM(NSUInteger,YFBMessageBuyDiamondSection) {
    YFBMessageBuyDiamondSectionPayPoint = 0,
    YFBMessageBuyDiamondSectionPayType,
    YFBMessageBuyDiamondSectionCount
};

static NSString *const kYFBFriendMessagePopViewPayPointReusableIdentifier = @"kYFBFriendMessagePopViewPayPointReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewPayTypeReusableIdentifier  = @"kYFBFriendMessagePopViewPayTypeReusableIdentifier";

static NSString *const kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier = @"kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier = @"kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier";
static NSString *const kYFBFriendMessagePopViewDiamondToPayReusableIdentifier = @"kYFBFriendMessagePopVIewDiamondToPayReusableIdentifier";

@interface YFBMessagePayPopController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UITableView *diamondTableView;
@property (nonatomic) UITableView *vipTableView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSIndexPath *categoryIndexPath;
@property (nonatomic) NSIndexPath *payTypeIndexPath;
@property (nonatomic) YFBMessagePopViewType popViewType;
@property (nonatomic) NSInteger selectedPrice;
@property (nonatomic) NSInteger selectedCount;
@property (nonatomic) YFBPayType selectedPayType;
@end

@implementation YFBMessagePayPopController
QBDefineLazyPropertyInitialization(NSIndexPath, categoryIndexPath)
QBDefineLazyPropertyInitialization(NSIndexPath, payTypeIndexPath)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    switch (self.popViewType) {
        case YFBMessagePopViewTypeVip:
            [self configVipPopView];
            break;
            
        case YFBMessagePopViewTypeDiamond:
            [self configDiamondPopView];
            break;
            
        case YFBMessagePopViewTypeBuyDiamond:
            [self configDiamondBuyView];
            break;
            
        default:
            break;
    }
}

- (void)configVipPopView {
    self.vipTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _vipTableView.backgroundColor = [UIColor clearColor];
    _vipTableView.delegate = self;
    _vipTableView.dataSource = self;
    [_vipTableView setScrollEnabled:NO];
    [_vipTableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier];
    [_vipTableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier];
    _vipTableView.tableHeaderView = [self configTableHeaderView:YFBMessagePopViewTypeVip];
    [self.view addSubview:_vipTableView];
    
    {
        [_vipTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(828));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
        
    }
    
    self.selectedPayType = YFBPayTypeWeiXin;
    self.selectedPrice = [YFBPayConfigManager manager].vipInfo.secondInfo.price;
    self.selectedCount = [YFBPayConfigManager manager].vipInfo.secondInfo.amount;
}

- (void)configDiamondBuyView {
    self.diamondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _diamondTableView.backgroundColor = [UIColor clearColor];
    _diamondTableView.delegate = self;
    _diamondTableView.dataSource = self;
    [_diamondTableView setScrollEnabled:NO];
    [_diamondTableView registerClass:[YFBMessagePayPointCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier];
    [_diamondTableView registerClass:[YFBMessagePayTypeCell class] forCellReuseIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier];
    _diamondTableView.tableHeaderView = [self configTableHeaderView:YFBMessagePopViewTypeBuyDiamond];
    [self.view addSubview:_diamondTableView];
    
    {
        [_diamondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view).mas_offset(-kScreenWidth*0.11);
            make.height.mas_equalTo(kWidth(906));
            make.left.mas_equalTo(self.view).mas_offset(kWidth(72));
            make.right.mas_equalTo(self.view).mas_offset(kWidth(-72));
        }];
    }
    
    self.selectedPayType = YFBPayTypeWeiXin;
    self.selectedPrice = [YFBPayConfigManager manager].diamondInfo.secondInfo.price;
    self.selectedCount = [YFBPayConfigManager manager].diamondInfo.secondInfo.amount;
}

- (void)configDiamondPopView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[YFBMessageDiamondCategoryCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondPayTypeCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier];
    [_collectionView registerClass:[YFBMessageDiamondToPayCell class] forCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(590));
        }];
    }
    [self setDefaultSelectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)configTableHeaderView:(YFBMessagePopViewType)type {
    UIView *headerView = [[UIView alloc] init];
    
    UIImageView *backImgV = [[UIImageView alloc] init];
    backImgV.userInteractionEnabled = YES;
    [headerView addSubview:backImgV];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"social_close"] forState:UIControlStateNormal];
    @weakify(self);
    [closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeButton];
    
    switch (type) {
        case YFBMessagePopViewTypeVip:
            headerView.size = CGSizeMake(kWidth(560), kWidth(398));
            backImgV.image = [UIImage imageNamed:@"message_pay_pop_view"];
        {
            [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headerView);
            }];
            
            [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headerView.mas_bottom).offset(-kWidth(295));
                make.right.equalTo(headerView.mas_right).offset(-kWidth(14));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(84)));
            }];
        }
            break;
        case YFBMessagePopViewTypeBuyDiamond:
            headerView.size = CGSizeMake(kWidth(560), kWidth(476));
            backImgV.image = [UIImage imageNamed:@"message_diamond_pop_view"];
        {
            [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(headerView);
                make.height.mas_equalTo(kWidth(444));
            }];
            
            [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top);
                make.right.equalTo(headerView.mas_right).offset(-kWidth(14));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(84)));
            }];
        }
            break;
        default:
            break;
    }
    
    return headerView;
}

- (void)setDefaultSelectedIndex {
    if (_collectionView) {
        if (!_categoryIndexPath) {
            self.categoryIndexPath = [NSIndexPath indexPathForItem:0 inSection:YFBPopViewDiamondSectionCategory];
        }
        [_collectionView selectItemAtIndexPath:self.categoryIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
        if (!_payTypeIndexPath) {
            self.payTypeIndexPath = [NSIndexPath indexPathForItem:0 inSection:YFBPopViewDiamondSectionType];
        }
        [_collectionView selectItemAtIndexPath:self.payTypeIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    if (_vipTableView) {
        [_vipTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:YFBPopViewSectionPayPoint] animated:NO scrollPosition:UITableViewScrollPositionNone];

    }
    if (_diamondTableView) {
        [_diamondTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:YFBPopViewSectionPayPoint] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDefaultSelectedIndex];
}

+ (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC {
    YFBMessagePayPopController *payPopView = [[YFBMessagePayPopController alloc] init];
    [payPopView showMessageTopUpPopViewWithType:type onCurrentVC:currentVC];
}

- (void)showMessageTopUpPopViewWithType:(YFBMessagePopViewType)type onCurrentVC:(UIViewController *)currentVC {
    self.popViewType = type;
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)dealloc {
    
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

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        return YFBPopViewSectionCount;
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        return YFBMessageBuyDiamondSectionCount;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return 2;
        }
        return 1;
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return 2;
        }
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.price = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.secondInfo.price/100)];
                cell.titleStr = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].diamondInfo.secondInfo.title];
                cell.descStr = [YFBPayConfigManager manager].diamondInfo.secondInfo.popDesc;
            } else if (indexPath.row == 1) {
                cell.price = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].diamondInfo.firstInfo.price/100)];
                cell.titleStr = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].diamondInfo.firstInfo.title];
                cell.descStr = [YFBPayConfigManager manager].diamondInfo.firstInfo.popDesc;
            }
            return cell;
        } else if (indexPath.section == YFBPopViewSectionPayType) {
            YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payTypeAction = ^(NSNumber * selectedPayTypeNumber) {
                @strongify(self);
                if ([selectedPayTypeNumber integerValue] == YFBPayTypeWeiXin) {
                    self.selectedPayType = YFBPayTypeWeiXin;
                } else if ([selectedPayTypeNumber integerValue] == YFBPayTypeAliPay) {
                    self.selectedPayType = YFBPayTypeAliPay;
                }
                [[YFBPaymentManager manager] payForAction:kYFBPaymentActionPURCHASEDIAMONDKeyName WithPayType:self.selectedPayType price:self.selectedPrice count:self.selectedCount handler:^(BOOL success) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                    [self hide];
                }];
                
            };
            return cell;
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBMessageBuyDiamondSectionPayPoint) {
            YFBMessagePayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayPointReusableIdentifier forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.price = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.secondInfo.price/100)];
                cell.titleStr = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].vipInfo.secondInfo.title];
                cell.descStr = [YFBPayConfigManager manager].vipInfo.secondInfo.popDesc;
            } else if (indexPath.row == 1) {
                cell.price = [NSString stringWithFormat:@"¥%ld",(long)([YFBPayConfigManager manager].vipInfo.firstInfo.price/100)];
                cell.titleStr = [NSString stringWithFormat:@"%@",[YFBPayConfigManager manager].vipInfo.firstInfo.title];
                cell.descStr = [YFBPayConfigManager manager].vipInfo.firstInfo.popDesc;
            }
            return cell;
        } else if (indexPath.section == YFBMessageBuyDiamondSectionPayType) {
            YFBMessagePayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBFriendMessagePopViewPayTypeReusableIdentifier forIndexPath:indexPath];
            @weakify(self);
            cell.payTypeAction = ^(NSNumber * selectedPayTypeNumber) {
                @strongify(self);
                if ([selectedPayTypeNumber integerValue] == YFBPayTypeWeiXin) {
                    self.selectedPayType = YFBPayTypeWeiXin;
                } else if ([selectedPayTypeNumber integerValue] == YFBPayTypeAliPay) {
                    self.selectedPayType = YFBPayTypeAliPay;
                }
                [[YFBPaymentManager manager] payForAction:kYFBPaymentActionOpenVipKeyName WithPayType:self.selectedPayType price:self.selectedPrice count:self.selectedCount handler:^(BOOL success) {
                    if (success) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                        [self hide];
                    }
                }];
            };
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            return kWidth(105);
        } else if (indexPath.section == YFBPopViewSectionPayType) {
            return kWidth(220);
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBMessageBuyDiamondSectionPayPoint) {
            return kWidth(105);
        } else if (indexPath.section == YFBMessageBuyDiamondSectionPayType) {
            return kWidth(220);
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return 0.01f;
        }else if (section == YFBPopViewSectionPayType) {
            return 0.01f;
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (section == YFBMessageBuyDiamondSectionPayPoint) {
            return 0.01f;
        } else if (section == YFBMessageBuyDiamondSectionPayType) {
            return 0.01f;
        }    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (section == YFBPopViewSectionPayPoint) {
            return 0.01f;
        }else if (section == YFBPopViewSectionPayType) {
            return 0.01f;
        }
    } else if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (section == YFBMessageBuyDiamondSectionPayPoint) {
            return 0.01f;
        } else if (section == YFBMessageBuyDiamondSectionPayType) {
            return 0.01f;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            cell.separatorInset = UIEdgeInsetsMake(0, kWidth(40), 0, kWidth(40));
        }
    } else if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            cell.separatorInset = UIEdgeInsetsMake(0, kWidth(40), 0, kWidth(40));
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[_vipTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            if (indexPath.row == 0) {
                self.selectedPrice = [YFBPayConfigManager manager].vipInfo.secondInfo.price;
                self.selectedCount = [YFBPayConfigManager manager].vipInfo.secondInfo.amount;
            } else if (indexPath.row == 1) {
                self.selectedPrice = [YFBPayConfigManager manager].vipInfo.firstInfo.price;
                self.selectedCount = [YFBPayConfigManager manager].vipInfo.firstInfo.amount;
            }
        }
    } else if ([tableView isKindOfClass:[_diamondTableView class]]) {
        if (indexPath.section == YFBPopViewSectionPayPoint) {
            if (indexPath.row == 0) {
                self.selectedPrice = [YFBPayConfigManager manager].diamondInfo.secondInfo.price;
                self.selectedCount = [YFBPayConfigManager manager].diamondInfo.secondInfo.amount;
            } else if (indexPath.row == 1) {
                self.selectedPrice = [YFBPayConfigManager manager].diamondInfo.firstInfo.price;
                self.selectedCount = [YFBPayConfigManager manager].diamondInfo.firstInfo.amount;
            }
        }
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return YFBPopViewDiamondSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return [YFBDiamondManager manager].diamonList.count;
    } else if (section == YFBPopViewDiamondSectionType) {
        return 2;
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        YFBMessageDiamondCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondCategoryReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < [YFBDiamondManager manager].diamonList.count) {
            YFBDiamondInfo *diamondInfo = [YFBDiamondManager manager].diamonList[indexPath.item];
            cell.diamondCount = [NSString stringWithFormat:@"%ld",(long)diamondInfo.diamondAmount];
            cell.price = [NSString stringWithFormat:@"%ld",(long)(diamondInfo.price/100)];
        }
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        YFBMessageDiamondPayTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondPayTypeReusableIdentifier forIndexPath:indexPath];
        cell.payType = indexPath.item;
        return cell;
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        YFBMessageDiamondToPayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendMessagePopViewDiamondToPayReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        cell.payAction = ^(id obj) {
            @strongify(self);
            YFBDiamondInfo *diamondInfo = [YFBDiamondManager manager].diamonList[self.categoryIndexPath.item];
            //支付
            [[YFBPaymentManager manager] payForAction:kYFBPaymentActionPURCHASEDIAMONDKeyName WithPayType:self.payTypeIndexPath.item price:diamondInfo.price count:diamondInfo.diamondAmount handler:^(BOOL success) {
                if (success) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                    [self hide];
                }
            }];
        };
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat itemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets edgeInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    
    CGFloat width;
    
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right - itemSpacing) / 2;
        return CGSizeMake((long)width, kWidth(88));
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right - itemSpacing) / 2;
        return CGSizeMake((long)width, kWidth(76));
    } else if (indexPath.section == YFBPopViewDiamondSectionPay) {
        width = (fullWidth - edgeInsets.left - edgeInsets.right);
        return CGSizeMake((long)width, kWidth(72));
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return kWidth(22);
    } else if (section == YFBPopViewDiamondSectionType) {
        return kWidth(22);
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 0;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return kWidth(24);
    } else if (section == YFBPopViewDiamondSectionType) {
        return 0;
    } else if (section == YFBPopViewDiamondSectionPay) {
        return 0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == YFBPopViewDiamondSectionCategory) {
        return UIEdgeInsetsMake(kWidth(30), kWidth(40), kWidth(42), kWidth(40));
    } else if (section == YFBPopViewDiamondSectionType) {
        return UIEdgeInsetsMake(kWidth(0), kWidth(40), kWidth(30), kWidth(40));
    } else if (section == YFBPopViewDiamondSectionPay) {
        return UIEdgeInsetsMake(kWidth(0), kWidth(40), kWidth(28), kWidth(40));
    }
    return UIEdgeInsetsZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == YFBPopViewDiamondSectionCategory) {
        if (![self.categoryIndexPath isEqual:indexPath]) {
            [_collectionView deselectItemAtIndexPath:self.categoryIndexPath animated:YES];
            self.categoryIndexPath = indexPath;
        }
    } else if (indexPath.section == YFBPopViewDiamondSectionType) {
        if (![self.payTypeIndexPath isEqual:indexPath]) {
            [_collectionView deselectItemAtIndexPath:self.payTypeIndexPath animated:YES];
            self.payTypeIndexPath = indexPath;
        }
    }

    return YES;
}
@end
