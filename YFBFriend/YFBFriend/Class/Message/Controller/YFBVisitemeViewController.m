//
//  YFBVisitemeViewController.m
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVisitemeViewController.h"
#import "YFBVisiteModel.h"
#import "YFBVipViewController.h"
#import "YFBDetailViewController.h"

static NSString *const kYFBFriendVisiteCellReusableIdentifier = @"kYFBFriendVisiteCellReusableIdentifier";
static NSString *const kYFBFriendVisiteContentFooterReusableIdentifier = @"kYFBFriendVisiteContentFooterReusableIdentifier";
static NSString *const kYFBFriendVisiteFooterViewReusableIdentifier = @"kYFBFriendVisiteFooterViewReusableIdentifier";

typedef NS_ENUM(NSInteger,YFBVisitemeSection) {
    YFBVisitemeSectionContent = 0,
    YFBVisitemeSectionVip,
    YFBVisitemeSectionCount
};


@interface YFBVisitemeCell ()
@property (nonatomic) UIImageView *userImgV;
@end

@implementation YFBVisitemeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImgV];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
@end


@interface YFBVisitemeFooterView ()
@property (nonatomic) UILabel *label;
@property (nonatomic) UIButton *payButton;
@end

@implementation YFBVisitemeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"开通VIP" forState:UIControlStateNormal];
        [_payButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFont(15);
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.masksToBounds = YES;
        _payButton.backgroundColor = kColor(@"#8458D0");
        [self addSubview:_payButton];
        
        @weakify(self);
        [_payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        self.label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = kFont(13);
        _label.textColor = kColor(@"#666666");
        _label.text = @"开通VIP后，可以查看所有查看您的人详细资料";
        [self addSubview:_label];
        
        {
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kWidth(624), kWidth(84)));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(_payButton.mas_top).offset(-kWidth(22));
                make.height.mas_equalTo(kWidth(26));
            }];
        }
        
    }
    return self;
}
@end



@interface YFBVisiteMeCountFooterView ()
@property (nonatomic) UIImageView *lineImgV;
@property (nonatomic) UILabel *label;
@end

@implementation YFBVisiteMeCountFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineImgV = [[UIImageView alloc] init];
        _lineImgV.backgroundColor = kColor(@"#E6E6E6");
        [self addSubview:_lineImgV];
        
        self.label = [[UILabel alloc] init];
        _label.font = kFont(13);
        _label.textColor = kColor(@"#666666");
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        {
            [_lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(5));
                make.size.mas_equalTo(CGSizeMake(kWidth(710), 1));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom);
                make.height.mas_equalTo(kWidth(26));
            }];
        }

    }
    return self;
}

- (void)setVisiteMeCount:(NSInteger)visiteMeCount {
    _label.text = [NSString stringWithFormat:@"当前有%ld个人查看了你",visiteMeCount];
}

@end


@interface YFBVisitemeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) YFBVisiteModel *visiteModel;
@property (nonatomic) YFBVisiteResponse *response;
@end

@implementation YFBVisitemeViewController
QBDefineLazyPropertyInitialization(YFBVisiteModel, visiteModel)
QBDefineLazyPropertyInitialization(YFBVisiteResponse, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#ffffff");

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(10);
    layout.minimumInteritemSpacing = kWidth(10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kColor(@"#ffffff");
    [_collectionView registerClass:[YFBVisitemeCell class] forCellWithReuseIdentifier:kYFBFriendVisiteCellReusableIdentifier];
    [_collectionView registerClass:[YFBVisiteMeCountFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kYFBFriendVisiteContentFooterReusableIdentifier];
    [_collectionView registerClass:[YFBVisitemeFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kYFBFriendVisiteFooterViewReusableIdentifier];
    [self.view addSubview:_collectionView];
    
    {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_collectionView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadVisitemeData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView YFB_triggerPullToRefresh];
}

- (void)loadVisitemeData {
    @weakify(self);
    [self.visiteModel fetchVisitemeInfoWithCompletionHandler:^(BOOL success, YFBVisiteResponse * obj) {
        @strongify(self);
        [self->_collectionView YFB_endPullToRefresh];
        if (success) {
            self.response = obj;
        }
        [self->_collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([YFBUtil isVip]) {
        return YFBVisitemeSectionVip;
    }
    return YFBVisitemeSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == YFBVisitemeSectionContent) {
        if ([YFBUtil isVip]) {
            return self.response.userList.count;
        } else {
            return self.response.userList.count > 5 ? 5 : self.response.userList.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFBVisitemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYFBFriendVisiteCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.response.userList.count) {
        YFBVisiteRobotModel *robot = self.response.userList[indexPath.item];
        cell.imageUrl = robot.portraitUrl;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.response.userList.count) {
        YFBVisiteRobotModel *robot = self.response.userList[indexPath.item];
        [self pushIntoDetailVC:robot.userId];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == YFBVisitemeSectionContent) {
        return UIEdgeInsetsMake(kWidth(24), kWidth(30), kWidth(24), kWidth(30));
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    CGFloat cellWidth = (fullWidth - insets.left - insets.right - flowLayout.minimumInteritemSpacing * 4)/5;
    return CGSizeMake((long)cellWidth, (long)cellWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == YFBVisitemeSectionContent) {
        return CGSizeMake(kScreenWidth, kWidth(50));
    } else if (section == YFBVisitemeSectionVip) {
        return CGSizeMake(kScreenWidth, kWidth(200));
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == YFBVisitemeSectionContent) {
        YFBVisiteMeCountFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kYFBFriendVisiteContentFooterReusableIdentifier forIndexPath:indexPath];
        footerView.visiteMeCount = self.response.userList.count;
        return footerView;
    } else if (indexPath.section == YFBVisitemeSectionVip) {
        YFBVisitemeFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kYFBFriendVisiteFooterViewReusableIdentifier forIndexPath:indexPath];
        @weakify(self);
        footerView.payAction = ^{
            @strongify(self);
            [self pushIntoPayVC];
        };
        return footerView;
    }
    return nil;
}

@end





