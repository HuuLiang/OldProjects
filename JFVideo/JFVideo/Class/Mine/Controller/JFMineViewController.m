//
//  JFMineViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFMineViewController.h"
#import "JFTableViewCell.h"
#import "JFAppSpreadCell.h"
#import "JFWebViewController.h"
#import "JFAppSpreadModel.h"
#import "CRKHudManager.h"
#import "JFSystemConfigModel.h"
#import "JFManualActivationgManager.h"

static NSString *const kMoreCellReusableIdentifier = @"MoreCellReusableIdentifier";

@interface JFMineViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    JFTableViewCell *_bannerCell;
    JFTableViewCell *_vipCell;
    JFTableViewCell *_activateCell;
    JFTableViewCell *_protocolCell;
    JFTableViewCell *_telCell;
    UITableViewCell *_appCell;
    UICollectionView *_appCollectionView;
    
    NSInteger currentSection;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) JFAppSpreadModel *appSpreadModel;
@end

@implementation JFMineViewController
DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(JFAppSpreadModel, appSpreadModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.layoutTableView JF_addPullToRefreshWithHandler:^{
        [self loadAppData];
    }];
    [self.layoutTableView JF_triggerPullToRefresh];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell || cell == self->_bannerCell) {
            [self payWithInfo:nil];
        }else if (cell == self->_activateCell){
            [[JFManualActivationgManager shareManager] doActivate];
        }else if (cell == self->_protocolCell) {
            JFWebViewController *webVC = [[JFWebViewController alloc] initWithURL:[NSURL URLWithString:JF_PROTOCOL_URL] standbyURL:nil];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_telCell) {
//            [UIAlertView bk_showAlertViewWithTitle:nil message:@"4006296682" cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex == 1) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006296682"]];
//                }
//            }];
            [self contactCustomerService];
        }
    };
    
    [self initCells];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPaidNotification:) name:kPaidNotificationName object:nil];
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        NSString *baseURLString = [JF_BASE_URL stringByReplacingCharactersInRange:NSMakeRange(0, JF_BASE_URL.length-6) withString:@"******"];
        [[CRKHudManager manager] showHudWithText:[NSString stringWithFormat:@"Server:%@\nChannelNo:%@\nPackageCertificate:%@\npV:%@/%@", baseURLString, JF_CHANNEL_NO, JF_PACKAGE_CERTIFICATE, JF_REST_PV, JF_PAYMENT_PV]];
    }];
}

- (void)contactCustomerService {
    NSString *contactScheme = [JFSystemConfigModel sharedModel].contactScheme;
    NSString *contactName = [JFSystemConfigModel sharedModel].contactName;
    
    if (contactScheme.length == 0) {
        return ;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:nil
                                   message:[NSString stringWithFormat:@"是否联系客服%@？", contactName ?: @""]
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactScheme]];
         }
     }];
}

- (void)onPaidNotification:(NSNotification *)notification {
    if ([JFUtil isVip]) {
        [self removeAllLayoutCells];
        [self loadAppData];
        [self initCells];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCells {
    NSUInteger section = 0;
    
    _bannerCell = [[JFTableViewCell alloc] init];
    _bannerCell.accessoryType = UITableViewCellAccessoryNone;
    _bannerCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
    _bannerCell.backgroundImageView.image = [UIImage imageNamed:@"setting_banner.jpg"];
    [self setLayoutCell:_bannerCell cellHeight:kScreenWidth*0.4 inRow:0 andSection:section++];
    
    if (![JFUtil isVip]) {
        _vipCell = [[JFTableViewCell alloc] initWithImage:nil title:@"开通VIP"];
        _vipCell.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _vipCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
        [self setLayoutCell:_vipCell cellHeight:44 inRow:0 andSection:section++];
          [self setHeaderHeight:10 inSection:section];
        _activateCell = [[JFTableViewCell alloc] initWithImage:nil title:@"自助激活"];
        _activateCell.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _activateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _activateCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
        [self setLayoutCell:_activateCell cellHeight:44 inRow:0 andSection:section++];
    }
    
    [self setHeaderHeight:10 inSection:section];
    
    _protocolCell = [[JFTableViewCell alloc] initWithImage:nil title:@"用户协议"];
    _protocolCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _protocolCell.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _protocolCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
    [self setLayoutCell:_protocolCell cellHeight:44 inRow:0 andSection:section++];
    
    UITableViewCell *lineCell = [[UITableViewCell alloc] init];
    lineCell.backgroundColor = [UIColor colorWithHexString:@"#575757"];
    [self setLayoutCell:lineCell cellHeight:0.5 inRow:0 andSection:section++];
    
    if ([JFUtil isVip]) {
        _telCell = [[JFTableViewCell alloc] initWithImage:nil title:@"联系客服"];
        _telCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _telCell.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _telCell.backgroundColor = [UIColor colorWithHexString:@"#464646"];
        [self setLayoutCell:_telCell cellHeight:44 inRow:0 andSection:section++];
    }
    currentSection = section;
}

- (void)initAppCell:(NSInteger)section {
    _appCell = [[UITableViewCell alloc] init];
    _appCell.backgroundColor = [UIColor colorWithHexString:@"#303030"];
    _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self createLayout]];
    _appCollectionView.backgroundColor = [UIColor clearColor];
    _appCollectionView.delegate = self;
    _appCollectionView.dataSource = self;
    _appCollectionView.scrollEnabled = NO;
    _appCollectionView.showsVerticalScrollIndicator = NO;
    [_appCollectionView registerClass:[JFAppSpreadCell class] forCellWithReuseIdentifier:kMoreCellReusableIdentifier];
    [_appCell addSubview:_appCollectionView];
    {
        [_appCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_appCell);
        }];
    }
    
    [self setLayoutCell:_appCell cellHeight:((kScreenWidth-50-50)/3+30)*(self.dataSource.count % 3 == 0 ? self.dataSource.count / 3 : self.dataSource.count / 3 + 1 ) +30 inRow:0 andSection:section];

    [self.layoutTableView reloadData];
}

- (void)loadAppData {
    @weakify(self);
    [self.appSpreadModel fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [self.layoutTableView JF_endPullToRefresh];
            if (_dataSource.count > 0) {
                [self initAppCell:currentSection];
            }
        }
    }];
}


- (UICollectionViewLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 25;
    layout.itemSize = CGSizeMake((kScreenWidth-50-50)/3, (kScreenWidth-50-50)/3+30);
    layout.sectionInset = UIEdgeInsetsMake(14, 22.5, 5, 22.5);
    return layout;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFAppSpreadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMoreCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        JFAppSpread *app = self.dataSource[indexPath.item];
        cell.titleStr = app.title;
        cell.imgUrl = app.coverImg;
        cell.isInstall = app.isInstall;
        DLog(@"%@ %@ %i",app.title,app.specialDesc,app.isInstall);
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JFAppSpread *app = self.dataSource[indexPath.item];
        if (app.isInstall) {
            return;
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.videoUrl]];
        }

        JFBaseModel *baseModel = [[JFBaseModel alloc] init];
        baseModel.programId = @(app.programId);
        baseModel.programType = @(app.type);
        baseModel.programLocation = indexPath.item;
        
        [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel programLocation:indexPath.item andTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[JFStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[JFUtil currentSubTabPageIndex] forSlideCount:1];
    
}
@end
