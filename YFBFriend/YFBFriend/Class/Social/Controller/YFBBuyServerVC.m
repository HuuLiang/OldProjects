//
//  YFBBuyServerVC.m
//  YFBFriend
//
//  Created by ZF on 2017/6/6.
//  Copyright © 2017年 ZF. All rights reserved.
//

#import "YFBBuyServerVC.h"
#import "YFBSocialModel.h"
#import "YFBBuyServerCell.h"
#import "YFBPaymentManager.h"

static NSString *const kYFBSocialBuyServerCellReusableIdentifier = @"kYFBSocialBuyServerCellReusableIdentifier";

@interface YFBBuyServerVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) UIButton *closeButton;
@end

@implementation YFBBuyServerVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (instancetype)initWithPaymentInfo:(NSArray <YFBSocialServiceModel * > *)paymentInfo  userId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        [self.dataSource addObjectsFromArray:paymentInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

    self.tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[YFBBuyServerCell class] forCellReuseIdentifier:kYFBSocialBuyServerCellReusableIdentifier];
    [_tableView setSeparatorColor:kColor(@"#F0F0F0")];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(44), 0, kWidth(36))];
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [self tableFooterView];
    [self.view addSubview:_tableView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"social_close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    
    @weakify(self);
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        CGFloat height = kWidth(120) + kWidth(106) * self.dataSource.count + kWidth(234);

        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(590), height));
        }];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableView.mas_right).offset(-kWidth(28));
            make.bottom.equalTo(_tableView.mas_top);
            make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(84)));
        }];
    }
    [_tableView reloadData];
    
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (UIView *)tableHeaderView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.size = CGSizeMake(kWidth(590), kWidth(120));
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"server_header"]];
    [headerView addSubview:imageV];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"服务选项";
    titleLabel.textColor = kColor(@"#ffffff");
    titleLabel.font = kFont(20);
    [headerView addSubview:titleLabel];
    
    {
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView);
            make.height.mas_equalTo(kFont(20).lineHeight);
        }];
    }
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = kColor(@"#ffffff");
    footerView.size = CGSizeMake(kWidth(590), kWidth(234));
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxButton setTitle:@"微信" forState:UIControlStateNormal];
    [wxButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    wxButton.titleLabel.font = kFont(14);
    wxButton.layer.cornerRadius = 3;
    [wxButton setImage:[UIImage imageNamed:@"server_wx"] forState:UIControlStateNormal];
    wxButton.backgroundColor = kColor(@"#00AC0A");
    [footerView addSubview:wxButton];
    
    UIButton *aliButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aliButton setTitle:@"支付宝" forState:UIControlStateNormal];
    [aliButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    aliButton.titleLabel.font = kFont(14);
    aliButton.layer.cornerRadius = 3;
    [aliButton setImage:[UIImage imageNamed:@"server_ali"] forState:UIControlStateNormal];
    aliButton.backgroundColor = kColor(@"#49ABF5");
    [footerView addSubview:aliButton];
    
    @weakify(self);
    [wxButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self startToPayWithPayType:YFBPayTypeWeiXin atIndexPath:self.selectedIndexPath];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [aliButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self startToPayWithPayType:YFBPayTypeAliPay atIndexPath:self.selectedIndexPath];
    } forControlEvents:UIControlEventTouchUpInside];
    
    {
        [aliButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView);
            make.bottom.equalTo(footerView.mas_bottom).offset(-kWidth(42));
            make.size.mas_equalTo(CGSizeMake(kWidth(450), kWidth(70)));
        }];
        
        [wxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView);
            make.bottom.equalTo(aliButton.mas_top).offset(-kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(450), kWidth(70)));
        }];
    }
    
    return footerView;
}

- (void)startToPayWithPayType:(YFBPayType)payType atIndexPath:(NSIndexPath *)indexPath {
    YFBSocialServiceModel *serviceModel = self.dataSource[indexPath.row];
    [[YFBPaymentManager manager] payForAction:kYFBPaymentActionCityServiceKeyName
                                  WithPayType:payType
                                        price:serviceModel.price
                                        count:serviceModel.servId
                                 extraContent:self.userId handler:^(BOOL success)
    {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kYFBSocialPaySuccessNotification object:self.userId];
            [self hide];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void)showSocialPaymentViewControllerWithInfo:(NSArray <YFBSocialServiceModel *> *)paymentInfo userId:(NSString *)userId InCurrentVC:(UIViewController *)currentViewController {
    YFBBuyServerVC *buyVC = [[YFBBuyServerVC alloc] initWithPaymentInfo:paymentInfo userId:userId];
    [buyVC showInCurrentViewController:currentViewController];
}

- (void)showInCurrentViewController:(UIViewController *)currentViewController {
    
    BOOL anySpreadBanner = [currentViewController.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentViewController.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentViewController addChildViewController:self];
    self.view.frame = currentViewController.view.bounds;
    self.view.alpha = 0;
    [currentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:currentViewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFBBuyServerCell *cell = [tableView dequeueReusableCellWithIdentifier:kYFBSocialBuyServerCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        YFBSocialServiceModel *serviceModel = self.dataSource[indexPath.row];
        cell.imgUrl = serviceModel.iconUrl;
        cell.option = serviceModel.servName;
        cell.desc = [NSString stringWithFormat:@"%@",serviceModel.servDesc];;
        cell.price = serviceModel.price;
        cell.originalPrice = serviceModel.orig;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(106);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
}


@end
