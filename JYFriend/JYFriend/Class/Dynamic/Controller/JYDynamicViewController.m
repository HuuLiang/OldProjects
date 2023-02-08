//
//  JYDynamicViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicViewController.h"
#import "JYDynamicCell.h"
#import "JYDynamicModel.h"
#import "JYUserCreateMessageModel.h"
#import "JYAutoContactManager.h"
#import "JYContactModel.h"
#import "JYCharacterModel.h"
#import "JYMyPhotoBigImageView.h"


#define resetTime   (60*60*6)     //重置缓存时间
#define refreshTime (60*3)        //刷新数据时间

static NSString *const kJYDynamicResetTimeKeyName     = @"kJYDynamicResetTimeKeyName";
static NSString *const kJYDynamicRefreshTimeKeyName   = @"kJYDynamicRefreshTimeKeyName";
static NSString *const kJYDynamicOffsetKeyName        = @"kJYDynamicOffsetKeyName";

static NSString *const kDynamicCellReusableIdentifier = @"DynamicCellReusableIdentifier";

@interface JYDynamicViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSUInteger _offset;
    NSUInteger _limit;
}
@property (nonatomic) NSMutableArray        *dataSource;
@property (nonatomic) NSMutableArray        *cellHeightArray;
@property (nonatomic) JYDynamicModel        *dynamicModel;
@property (nonatomic) JYSendMessageModel    *sendMsgModel;
@end

@implementation JYDynamicViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, cellHeightArray)
QBDefineLazyPropertyInitialization(JYDynamicModel, dynamicModel)
QBDefineLazyPropertyInitialization(JYSendMessageModel, sendMsgModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //预先加载所有缓存数据
    self.dataSource =  [NSMutableArray arrayWithArray:[JYDynamic allDynamics]];
    //如果缓存无数据 就一次加载较多的数据
    if (self.dataSource.count == 0 && [JYUtil shouldRefreshContentWithKey:kJYDynamicRefreshTimeKeyName timeInterval:refreshTime]) {
        [self loadDataWithOffset:0 limit:10 isRefresh:YES];
    }
    
    _offset = [[JYUtil getValueWithKeyName:kJYDynamicOffsetKeyName] unsignedIntegerValue];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JYDynamicCell class] forCellWithReuseIdentifier:kDynamicCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        //刷新数据 时间未到 就结束刷新动画 否则加载2条数据
        if ([JYUtil shouldRefreshContentWithKey:kJYDynamicRefreshTimeKeyName timeInterval:refreshTime]) {
            [self loadDataWithOffset:self.dataSource.count limit:1 isRefresh:YES];
        } else {
            [self->_layoutCollectionView JY_endPullToRefresh];
        }
    }];
    
    [_layoutCollectionView JY_addPagingRefreshWithHandler:^{
        [self loadDataWithOffset:self.dataSource.count limit:3 isRefresh:NO];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //页面出现若到了下拉刷新时限 则加载2条数据
    if ([JYUtil shouldRefreshContentWithKey:kJYDynamicRefreshTimeKeyName timeInterval:refreshTime]) {
        [self loadDataWithOffset:self.dataSource.count limit:1 isRefresh:YES];
    }
}

//isRefresh 判断是刷新数据还是加载数据
- (void)loadDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit isRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.dynamicModel fetchDynamicInfoWithOffset:offset limit:limit completionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            if (isRefresh) {
                //如果是刷新数据
                //如果是初始化数据 重置本地缓存 内存数据
                if ([JYUtil shouldRefreshContentWithKey:kJYDynamicResetTimeKeyName timeInterval:resetTime]) {
                    [JYDynamic clearTable];
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObjectsFromArray:obj];
                    [self setDynamicInfoWithSource:nil atFront:NO isResetDataSource:YES];
                } else {
                    //则就是刷新少量最新的动态数据 插入数组前列
                    [self setDynamicInfoWithSource:obj.count > 0 ? obj : nil atFront:YES isResetDataSource:NO];
                }
            } else {
                //加载数据 放入数组尾部
                [self setDynamicInfoWithSource:obj.count > 0 ? obj : nil  atFront:NO isResetDataSource:NO];
            }
        }
        [JYUtil setValue:@(self.dataSource.count) withKeyName:kJYDynamicOffsetKeyName];
        [_layoutCollectionView reloadData];
        [_layoutCollectionView JY_endPullToRefresh];
    }];
}

- (void)setDynamicInfoWithSource:(NSArray *)array atFront:(BOOL)isFront isResetDataSource:(BOOL)isReset {
    if (isReset) {
        //重置的新数据 设置内容类型和高度
        [self.dataSource enumerateObjectsUsingBlock:^(JYDynamic *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger randomTime = random() % 360 + 60; //随机1到7分钟
            if (idx == 0) {
                //初始时间
                obj.timeInterval = [[JYUtil currentDate] timeIntervalSince1970] - randomTime;
            } else {
                JYDynamic *lastObj = self.dataSource[idx-1];
                obj.timeInterval = lastObj.timeInterval - randomTime;
            }
            obj = [self getDynamicContentHeightWithDynamic:obj];
            [obj saveOneDynamic];
            [self.dataSource replaceObjectAtIndex:idx withObject:obj];
        }];
    } else {
        //从头或者尾部插入新的数据
        if (array != nil) {
            [array enumerateObjectsUsingBlock:^(JYDynamic *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj = [self getDynamicContentHeightWithDynamic:obj];
                NSInteger randomTime = random() % 360 + 60; //随机1到7分钟
                if (self.dataSource == 0) {
                    if (idx == 0) {
                        obj.timeInterval = [[JYUtil currentDate] timeIntervalSince1970] - randomTime;
                    } else {
                        JYDynamic *lastObj = array[idx-1];
                        obj.timeInterval = lastObj.timeInterval - randomTime;
                    }
                    [obj saveOneDynamic];
                    [self.dataSource addObject:obj];
                } else {
                    if (isFront) {
                        randomTime = random() % 150 + 30;
                        JYDynamic *firstObj = [self.dataSource firstObject];
                        obj.timeInterval = firstObj.timeInterval + randomTime;
                        [self.dataSource insertObject:obj atIndex:0];
                    } else {
                        JYDynamic *lastObj = [self.dataSource lastObject];
                        obj.timeInterval = lastObj.timeInterval - randomTime;
                        [self.dataSource addObject:obj];
                    }
                }
                [obj saveOneDynamic];
            }];
        }
    }
}

- (JYDynamic *)getDynamicContentHeightWithDynamic:(JYDynamic *)dynamic {
    CGFloat originHeight = kWidth(30) + kWidth(88) + kWidth(32) + kWidth(30) + kWidth(30);
    CGFloat contentHeight = [dynamic.text boundingRectWithSize:CGSizeMake(kScreenWidth - kWidth(62), MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(32)]}
                                                          context:nil].size.height;
    CGFloat typeHeight = 0;

    if ([dynamic.text isEqualToString:@"111111111111"]) {
        
    }
    
    if (dynamic.moodUrl.count == 1) {
        JYDynamicUrl *dynamicUrl = [dynamic.moodUrl firstObject];
        if ([dynamicUrl.type integerValue] == 1) {
            dynamic.dynamicType = JYDynamicTypeVideo;
            typeHeight = (kScreenWidth - kWidth(60))*207/345;
        } else if ([dynamicUrl.type integerValue] == 2) {
            dynamic.dynamicType = JYDynamicTypeOnePhoto;
            typeHeight = kScreenWidth - kWidth(60);
        }
    } else if (dynamic.moodUrl.count == 2) {
        dynamic.dynamicType = JYDynamicTypeTwoPhotos;
        typeHeight = (kScreenWidth - kWidth(70))/2;
    } else if (dynamic.moodUrl.count == 3) {
        dynamic.dynamicType = JYDynamicTypeThreePhotos;
        typeHeight = (kScreenWidth - kWidth(72))/3;
    }
    
    dynamic.contentHeight = originHeight+contentHeight+typeHeight;
    
    return dynamic;
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYDynamicCell *dynamicCell = [collectionView dequeueReusableCellWithReuseIdentifier:kDynamicCellReusableIdentifier forIndexPath:indexPath];
    
    @weakify(self);
    if (indexPath.item < self.dataSource.count) {
        JYDynamic *dynamic = self.dataSource[indexPath.item];
        dynamicCell.logoUrl = dynamic.logoUrl;
        dynamicCell.nickName = dynamic.nickName;
        dynamicCell.age = dynamic.age;
        dynamicCell.userSex = [JYUserSexStringGet indexOfObject:dynamic.sex];
        dynamicCell.timeInterval = dynamic.timeInterval;
        dynamicCell.content = dynamic.text;
        dynamicCell.isFocus = dynamic.follow;
        dynamicCell.isGreet = dynamic.greet;
        dynamicCell.dynamicType = dynamic.dynamicType;
        dynamicCell.moodUrl = dynamic.moodUrl;
        dynamicCell.buttonAction = ^(NSNumber *type) {
            @strongify(self);
            [self.sendMsgModel fetchRebotReplyMessagesWithRobotId:dynamic.userId msg:nil ContentType:@"Text" msgType:[type integerValue] CompletionHandler:^(BOOL success, id obj) {
                if (success) {
                    
                    JYDynamicCell *cell = (JYDynamicCell *)[self->_layoutCollectionView cellForItemAtIndexPath:indexPath];
                    
                    if ([type integerValue] == JYUserCreateMessageTypeGreet) {
                        [JYContactModel insertGreetContact:obj];
                        cell.isGreet = YES;
                        dynamic.greet = YES;
                        [[JYHudManager manager] showHudWithText:@"招呼成功"];
                        
                        JYCharacter *character = [[JYCharacter alloc] init];
                        character.nickName = dynamic.nickName;
                        character.logoUrl = dynamic.logoUrl;
                        character.userId = dynamic.userId;
                        [JYContactModel insertGreetContact:@[character]];
                        
                    } else if ([type integerValue] == JYUserCreateMessageTypeFollow) {
                        cell.isFocus = YES;
                        dynamic.follow = YES;
                        [[JYHudManager manager] showHudWithText:@"关注成功"];
                    }
                    [dynamic saveOneDynamic];
                    //打招呼或者关注成功 //把返回的机器人及其回复信息放入缓存 定时取出并且推送给用户
                    [[JYAutoContactManager manager] saveReplyRobots:obj];
                }
            }];
        };
        dynamicCell.userImgAction = ^(id obj) {
            @strongify(self);
            JYDynamic *dynamic = self.dataSource[indexPath.item];
            [self pushDetailViewControllerWithUserId:dynamic.userId time:[JYUtil timeStringFromDate:[NSDate dateWithTimeIntervalSince1970:dynamic.timeInterval] WithDateFormat:KDateFormatLong] distance:nil nickName:dynamic.nickName];
        };
        dynamicCell.photoBrowser = ^(BOOL isVideo,NSInteger index) {
            @strongify(self);
            if (isVideo) {
                //播放视频链接
                JYDynamicUrl *dynamicUrl = [dynamic.moodUrl firstObject];
                [self playerVCWithVideo:dynamicUrl.url];
                
            } else {
                NSMutableArray *imgUrls = [NSMutableArray array];
                [dynamic.moodUrl enumerateObjectsUsingBlock:^(JYDynamicUrl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [imgUrls addObject:obj.url];
                }];
                [self photoBrowseWithImageGroup:imgUrls currentIndex:index isNeedBlur:NO];
            }
        };
    }
    return dynamicCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < self.dataSource.count) {
        JYDynamic *dynamic = self.dataSource[indexPath.item];
        CGFloat width = fullWidth;
        CGFloat height = dynamic.contentHeight;
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), 0, kWidth(20), 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

//图片浏览
- (void)photoBrowseWithImageGroup:(NSArray *)imageGroup currentIndex:(NSInteger)currentIndex isNeedBlur:(BOOL)isNeedBlur{
    JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:imageGroup frame:self.view.window.frame isLocalImage:NO isNeedBlur:isNeedBlur userId:nil];
    bigImageView.backgroundColor = [UIColor whiteColor];
    bigImageView.shouldAutoScroll = NO;
    bigImageView.shouldInfiniteScroll = NO;
    bigImageView.pageControlYAspect = 0.8;
    bigImageView.currentIndex = currentIndex;
    
    @weakify(bigImageView);
    bigImageView.action = ^(id sender){
        @strongify(bigImageView);
        [UIView animateWithDuration:0.5 animations:^{
            bigImageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [bigImageView removeFromSuperview];
        }];
    };
    [self.view.window addSubview:bigImageView];
    bigImageView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        bigImageView.alpha = 1;
    }];
}

@end
