//
//  YFBMyGiftDetailController.m
//  YFBFriend
//
//  Created by Liang on 2017/3/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMyGiftDetailController.h"
#import "YFBMineGiftCell.h"
#import "YFBMineGiftHeaderView.h"
#import "YFBMyGiftModel.h"
#import "YFBInteractionManager.h"

static NSString *const YFBMineGiftCellIdentifier = @"yfb_mine_gift_cell_identifier";

@interface YFBMyGiftDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isSendGift;
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) NSMutableArray <YFBMineGiftHeaderView *>*headerViews;
@property (nonatomic,retain) NSMutableArray <NSNumber *>*rowCounts;
@property (nonatomic,retain) YFBMyGiftModel *giftModel;
@property (nonatomic,retain) NSArray <YFBGiftListModel *>*giftList;
@end

@implementation YFBMyGiftDetailController
QBDefineLazyPropertyInitialization(NSMutableArray,headerViews)
QBDefineLazyPropertyInitialization(NSMutableArray, rowCounts)
QBDefineLazyPropertyInitialization(YFBMyGiftModel, giftModel)

- (instancetype)initWithIsSendGift:(BOOL)isSendGift
{
    self = [super init];
    if (self) {
        _isSendGift = isSendGift;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView setSeparatorStyle:0];
    [_layoutTableView registerClass:[YFBMineGiftCell class] forCellReuseIdentifier:YFBMineGiftCellIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    @weakify(self);
    [_layoutTableView YFB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadModel];
    }];
    [_layoutTableView YFB_triggerPullToRefresh];
}

- (void)loadModel {
    @weakify(self);
    [self.giftModel fetchMyGiftModelWithType:_isSendGift ? @"send":@"recv" CompleteHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            if (!self) {
                return ;
            }
            self.giftList = obj;
            [self setRowCount];
            [self->_layoutTableView reloadData];
        }
        [self reloadSectionHeaderView];
        [self->_layoutTableView YFB_endPullToRefresh];
    }];
}

- (void)setRowCount{
    for (int i= 0; i<self.giftList.count; i++) {
        [self.rowCounts addObject:@(1)];
    }
    self->_layoutTableView.tableHeaderView = [self getTabelHeaderView];
}

- (void)reloadSectionHeaderView {
    [self.giftList enumerateObjectsUsingBlock:^(YFBGiftListModel * _Nonnull giftModel, NSUInteger idx, BOOL * _Nonnull stop) {
        YFBMineGiftHeaderView *headerView = (YFBMineGiftHeaderView *)[self tableView:_layoutTableView viewForHeaderInSection:idx];
        if (_isSendGift) {
            headerView.title = [self getAttributeStrWithName:giftModel.nickName title:@"收到您送的礼物"];
        }else{
            headerView.title = [self getAttributeStrWithName:giftModel.nickName title:@"送给你礼物"];
        }
        headerView.imageUrl = giftModel.portraitUrl;
        headerView.allGift = giftModel.giftList.count;
        @weakify(self);
        headerView.action = ^(UIButton *btn) {
            @strongify(self);
            [self.rowCounts replaceObjectAtIndex:idx withObject:btn.selected ? @(giftModel.giftList.count) : @1];
            [self->_layoutTableView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)getTabelHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kWidth(72))];
    headerView.backgroundColor = kColor(@"#eeeeee");
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFont(14);
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.right.mas_equalTo(headerView);
            make.height.mas_equalTo(kWidth(40));
        }];
    }
    NSString *titleStr = _isSendGift ? @"当前送出的礼物：" : @"当前收到的礼物：";
    NSInteger allGiftCount = 0;
    for (YFBGiftListModel *model in self.giftList) {
        allGiftCount += model.giftList.count;
    }
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%zd件",titleStr,allGiftCount]];
    [attribute setAttributes:@{NSForegroundColorAttributeName : kColor(@"#8458d0")} range:NSMakeRange(titleStr.length, attribute.length-titleStr.length)];
    titleLabel.attributedText = attribute.copy;
    return headerView;
}

- (NSAttributedString *)getAttributeStrWithName:(NSString *)name title:(NSString *)title {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",name,title]];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName : kColor(@"#333333")} range:NSMakeRange(0, name.length)];
    return attributeStr.copy;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.giftList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.rowCounts.count) {
        return [self.rowCounts[section] integerValue];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.giftList.count) {
        YFBMineGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:YFBMineGiftCellIdentifier forIndexPath:indexPath];
        YFBGiftListModel *giftModel = self.giftList[indexPath.section];
        YFBGift *gift = giftModel.giftList[indexPath.row];
        cell.name = gift.name;
        cell.diamond = [NSString stringWithFormat:@"%@颗钻石",gift.diamondCount];
        cell.time = gift.recvOrSendTime;
        cell.giftUrl = gift.giftUrl;
        if (_isSendGift) {
            cell.giveStr = @"再送一个";
        }else{
            cell.giveStr = @"回赠";
        }
        @weakify(self);
        cell.giveAction = ^{
            @strongify(self);
            if ([gift.diamondCount integerValue] > [YFBUser currentUser].diamondCount) {
                [[YFBHudManager manager] showHudWithText:@"钻石不足，请充值"];
                return ;
            }
            [[YFBInteractionManager manager] sendMessageInfoToUserId:giftModel.userId content:gift.giftId type:YFBMessageTypeGift deductDiamonds:-[gift.diamondCount integerValue] handler:^(BOOL success) {
                if (success) {
                    if (_isSendGift) {
                        [[YFBHudManager manager] showHudWithText:@"赠送成功"];
                    } else {
                        [[YFBHudManager manager] showHudWithText:@"回赠成功"];
                    }
                }
                [self->_layoutTableView YFB_triggerPullToRefresh];
            }];
        };
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < self.headerViews.count) {
        return self.headerViews[section];
    }
    YFBMineGiftHeaderView *headerView = [[YFBMineGiftHeaderView alloc] init];
    YFBGiftListModel *giftModel = self.giftList[section];
    if (_isSendGift) {
        headerView.title = [self getAttributeStrWithName:giftModel.nickName title:@"收到您送的礼物"];
    }else{
        headerView.title = [self getAttributeStrWithName:giftModel.nickName title:@"送给你礼物"];
    }
    headerView.imageUrl = giftModel.portraitUrl;
    headerView.allGift = giftModel.giftList.count;
    @weakify(self);
    headerView.action = ^(UIButton *btn) {
        @strongify(self);
        [self.rowCounts replaceObjectAtIndex:section withObject:btn.selected ? @(giftModel.giftList.count) : @1];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.headerViews addObject:headerView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kWidth(142);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(82);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kWidth(20);
}
@end
