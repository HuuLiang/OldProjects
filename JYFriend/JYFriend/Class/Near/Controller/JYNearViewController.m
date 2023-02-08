//
//  JYNearViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearViewController.h"
#import "JYNearPersonCell.h"
#import "JYNearBottomView.h"
#import <CoreLocation/CoreLocation.h>
#import "JYNotFetchUserlocalView.h"
#import "JYDetailViewController.h"
#import "JYNearPesonModel.h"
#import "JYLocalVideoUtils.h"
#import "JYContactModel.h"
#import "JYUserCreateMessageModel.h"
#import "JYAutoContactManager.h"


static NSString *const kNearPersonCellIdentifier = @"knearpersoncell_identifier";
static NSString *const kSexTypeLocalCacheKey = @"kjysextype_local_cache_key";
static NSString *const kRefreshTimeInterval = @"krefreshTimeInterval_key";
static NSUInteger const kPageSize = 10;//每次上拉加载的条数
static NSUInteger const kDefaultSize = 20;

@interface JYNearViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    UITableView *_layoutTableView;
    
}

@property (nonatomic,retain) JYNearBottomView *bottomView;//批量打招呼
@property (nonatomic,retain) NSMutableArray  <NSIndexPath *>*allSelectCells;//所有选中的cell的indexPath
@property (nonatomic,retain) UIActionSheet *actionSheetView;
@property (nonatomic,retain) CLLocationManager  *locationManager;//定位
@property (nonatomic,retain) JYNotFetchUserlocalView *notLocalView;//没有登录时的view

@property (nonatomic) JYUserSex sexType;//性别筛选

@property (nonatomic,retain) JYNearPesonModel *personModel;
@property (nonatomic,retain) NSArray <JYUserInfoModel *>*allPersons;
@property (nonatomic,retain) NSMutableArray <JYUserInfoModel *>*dataSource;
@property (nonatomic,retain) NSArray <JYUserInfoModel *>*currentSexPersons;
@property (nonatomic) JYUserGreetModel *userGreetModel;

@end

@implementation JYNearViewController
QBDefineLazyPropertyInitialization(NSMutableArray, allSelectCells)
QBDefineLazyPropertyInitialization(CLLocationManager, locationManager)
QBDefineLazyPropertyInitialization(JYNearPesonModel, personModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(JYUserGreetModel, userGreetModel)
/**
 未获定位权限时的界面
 */
- (JYNotFetchUserlocalView *)notLocalView {
    if (_notLocalView) {
        return _notLocalView;
    }
    _notLocalView = [[JYNotFetchUserlocalView alloc] init];
    [self.view addSubview:_notLocalView];
    {
    [_notLocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
    _notLocalView.settingAction = ^(id sender){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    };
    
    return _notLocalView;
}
/**
 批量打招呼
 */
- (JYNearBottomView *)bottomView {

    if (_bottomView) {
        return _bottomView;
    }
    _bottomView = [[JYNearBottomView alloc] init];
    @weakify(self);
    _bottomView.action = ^(id sender) {
        @strongify(self);
//        [self tableViewEditing];
        [self batchGreetUsers];//批量打招呼
    };
    [self.view addSubview:_bottomView];
    {
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kWidth(88.));
    }];
    }
    
    return _bottomView;
}
//批量打招呼
- (void)batchGreetUsers {
    @weakify(self);
     NSMutableArray *selectedUsers = [[NSMutableArray alloc] init];
    NSMutableArray *userIds = [NSMutableArray array];
    [self.allSelectCells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        JYUserInfoModel *userInfoModel = self.currentSexPersons[obj.item];
        [selectedUsers addObject:userInfoModel];
        [userIds addObject:userInfoModel.userId];
    }];
    //先向消息列表中加入选中的机器人的打招呼语言
    [JYContactModel insertGreetContact:selectedUsers];
    [self.userGreetModel fetchRobotsReplyMessagesWithBatchRobotId:userIds CompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
        if (success) {
            //把返回的机器人及其回复信息放入缓存 定时取出并且推送给用户
            [[JYAutoContactManager manager] saveReplyRobots:obj];
        }
        //关闭推荐
    }];

       [self tableViewEditing];
}


- (UIActionSheet *)actionSheetView {
    if (_actionSheetView) {
        return _actionSheetView;
    }
    _actionSheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"只看女生",@"只看男生",@"查看全部",@"批量打招呼", nil];

    return _actionSheetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附近的人";
    //上次的筛选type
    self.sexType = [[NSUserDefaults standardUserDefaults] objectForKey:kSexTypeLocalCacheKey] ? [[[NSUserDefaults standardUserDefaults] objectForKey:kSexTypeLocalCacheKey] integerValue] : JYUserSexALL;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRefreshTimeInterval];//移除本地缓存的时间,重新请求数据
    BOOL locationEnable = [CLLocationManager locationServicesEnabled];
    int locationStatus = [CLLocationManager authorizationStatus];
    self.locationManager.delegate  = self;
    [self.locationManager startUpdatingLocation];
    if (!locationEnable || (locationStatus != kCLAuthorizationStatusAuthorizedAlways && locationStatus != kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self requestLocationAuthority];
    }
    if(locationEnable && (locationStatus == kCLAuthorizationStatusAuthorizedAlways || locationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)){
        
        [self creartTableViewAndRightBarButtonItem];
        
    }
    if (locationEnable && locationStatus == kCLAuthorizationStatusDenied) {
        
        self.notLocalView.backgroundColor = self.view.backgroundColor;
        
    }
}

/**
 创建tableView
 */
- (void)creartTableViewAndRightBarButtonItem {
    
    if (_notLocalView) {
       _notLocalView.hidden = YES;
        [_notLocalView removeFromSuperview];
    }
    
    if (_layoutTableView) {
        return ;
    }
    @weakify(self);
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.allowsMultipleSelectionDuringEditing = YES;
    _layoutTableView.tintColor = [UIColor colorWithHexString:@"#e147a5"];
    _layoutTableView.tableFooterView = [UIView new];
    _layoutTableView.separatorInset = UIEdgeInsetsMake(0, kWidth(30), 0, 0);
    _layoutTableView.rowHeight = kWidth(180);
    [_layoutTableView registerClass:[JYNearPersonCell class] forCellReuseIdentifier:kNearPersonCellIdentifier];
    [self.view  addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"near_ filtrate_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self ->_layoutTableView.editing) {
            [self tableViewEditing];
        }else {
            [self.actionSheetView showFromTabBar:self.tabBarController.tabBar];
        }
            }];
    
    [_layoutTableView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadModels];
    }];
    
    [_layoutTableView JY_triggerPullToRefresh];
    
    [_layoutTableView JY_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self pageLoadModelWithPersonSex:self.sexType isPullDown:NO];
    }];
    
}
/**
 加载全部模型
 */
- (void)loadModels {
    @weakify(self);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kRefreshTimeInterval] && [JYLocalVideoUtils dateTimeDifferenceWithStartTime:[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshTimeInterval] endTime:[JYLocalVideoUtils currentTime]] <= 180 && self.currentSexPersons.count!= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self->_layoutTableView reloadData];
            [self pageLoadModelWithPersonSex:self.sexType isPullDown:YES];
            [self->_layoutTableView JY_endPullToRefresh];
            
        });
        return;
    }
    [self.personModel fetchNearPersonModelWithPage:0 pageSize:10 completeHandler:^(BOOL success, JYNearPerson *nearPersons) {
        @strongify(self);
        self.allPersons = nearPersons.programList;
        self.currentSexPersons = [self fetchPersonListWithSexType:self.sexType];
        [self pageLoadModelWithPersonSex:self.sexType isPullDown:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[JYLocalVideoUtils currentTime] forKey:kRefreshTimeInterval];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}
/**
 模拟上拉加载
 */
- (void)pageLoadModelWithPersonSex:(JYUserSex)sex isPullDown:(BOOL)isPullDown{
    static BOOL isLoading = NO;
    if (isLoading == YES) {
        return;
    }
        isLoading = YES;
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self->_layoutTableView JY_endPullToRefresh];
        [self->_layoutTableView reloadData];
        isLoading = NO;
    });
    
    if (self.currentSexPersons.count == 0) {
        [self.dataSource removeAllObjects];
        return;
    }
    if (isPullDown) {//下拉
        if (self.dataSource.count)  [self.dataSource removeAllObjects];
        [self.currentSexPersons enumerateObjectsUsingBlock:^(JYUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < kDefaultSize) {
                [self.dataSource addObject:obj];
            }
        }];
        
    }else {//上拉
        if (self.dataSource.count >= self.currentSexPersons.count) {
            [_layoutTableView JY_pagingRefreshNoMoreData];
            return;
        }
        NSMutableArray *arrM = [NSMutableArray array];
        [self.currentSexPersons enumerateObjectsUsingBlock:^(JYUserInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= self.dataSource.count && idx < self.dataSource.count + kPageSize-1) {
                [arrM addObject:obj];
            }
            if (idx == self.dataSource.count + kPageSize - 1){
                *stop = YES;
            }
        }];
        [self.dataSource addObjectsFromArray:arrM];
    }
    
}

/**
 根据性别把所有附近的人进行筛选
 */

- (NSArray <JYUserInfoModel *>*)fetchPersonListWithSexType:(JYUserSex)sexType {
    NSString *gender = nil;
    switch (sexType) {
        case 1:
            gender = @"M";//男
            break;
        case 2:
            gender = @"F";//女
            break;
            
        default:
            break;
    }
    if (sexType == JYUserSexALL) {
        return self.allPersons;
    }
   return  [self.allPersons bk_select:^BOOL(JYUserInfoModel *obj) {
        if ([obj.sex isEqualToString:gender]) {
            return YES;
        }
      return NO;
    }];

}



/**
 请求定位权限
 */
- (void)requestLocationAuthority {
    
        if ([UIDevice currentDevice].systemVersion.floatValue >=8) {
            [self.locationManager requestWhenInUseAuthorization];
    }

}
/**
 tableView的编辑模式
 */
- (void)tableViewEditing{
    [_layoutTableView JY_endPullToRefresh];
    [self.allSelectCells removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.hidden = YES;
        
        [self->_layoutTableView setEditing:!self ->_layoutTableView.editing animated:NO];
        
        if (self->_layoutTableView.editing) {
            self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
            
        }else {
            self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, kWidth(30), 0, 0);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}


#pragma UITableViewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYNearPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearPersonCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        JYUserInfoModel *person = self.dataSource[indexPath.row];
        cell.headerImageUrl = person.logoUrl;
        cell.age = [NSString stringWithFormat:@"%@",person.age];
        cell.name = person.nickName;
        cell.sex = [person.sex isEqualToString:@"F"] ? JYUserSexFemale : JYUserSexMale;
        cell.distance = person.km;
        cell.height = person.height.integerValue;
        cell.vip = person.isVip.integerValue;
        cell.detaiTitle = person.note;
        return cell;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    
    view.backgroundColor = [UIColor redColor];
////    view.alpha = 0;
//    
    cell.multipleSelectionBackgroundView = view;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

 return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.editing) {
        if (![self.allSelectCells containsObject:indexPath]) [self.allSelectCells addObject:indexPath];
        self.bottomView.hidden = NO;
        self.bottomView.personNumber = self.allSelectCells.count;
        
    }else {
        if (indexPath.row < self.dataSource.count) {
            JYUserInfoModel *user = self.dataSource[indexPath.row];
            [self pushDetailViewControllerWithUserId:user.userId time:nil distance:user.km nickName:user.nickName];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.allSelectCells containsObject:indexPath]) [self.allSelectCells removeObject:indexPath];
    self.bottomView.personNumber = self.allSelectCells.count;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            self.sexType = JYUserSexFemale;
            break;
        case 1:
            self.sexType = JYUserSexMale;
            break;
        case 2:
            self.sexType = JYUserSexALL;
            break;
        case 3:
             [self tableViewEditing];
            break;
        default:
            break;
    }
    if (buttonIndex <3) {//保存筛选性别
         self.currentSexPersons = [self fetchPersonListWithSexType:self.sexType];
        [_layoutTableView JY_triggerPullToRefresh];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.sexType] forKey:kSexTypeLocalCacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self creartTableViewAndRightBarButtonItem];
    }else if (status == kCLAuthorizationStatusDenied){
        self.notLocalView.backgroundColor = self.view.backgroundColor;
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        QBLog(@"%@",placemarks.lastObject.name);
    }];
    
    [manager stopUpdatingLocation];

}




@end
