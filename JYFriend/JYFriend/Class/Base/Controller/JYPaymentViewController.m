//
//  JYPaymentViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPaymentViewController.h"
#import "JYPayHeaderCell.h"
#import "JYPayNewDynamicCell.h"
#import "JYPayPointCell.h"
#import "JYPayTypeCell.h"
#import <QBPaymentManager.h>
#import "JYSystemConfigModel.h"
#import "JYUpdateUserVipModel.h"

static NSString *const kPayNewDynamicCellIdentifier = @"jy_new_dynamic_cell_identifier";
static NSString *const kPayHeaderCellIdentifier = @"jy_pay_header_cell_indetifier";
static NSString *const kPayPointCellIdentifier = @"jy_pay_point_cell_identifier";
static NSString *const kPayTypeCellIdentifier = @"jy_pay_type_cell_identifier";

typedef NS_ENUM(NSUInteger , JYPayCellSection) {
    JYPayCellSectionNewDynamicCell,//最新动态
    JYPayCellSectionTitleCell,//标题
    JYPayCellSectionPayPointCell,//计费点
    JYPayCellSectionPayTypeCell,//支付方式
    JYPayCellSectionCount
};

typedef NS_ENUM(NSUInteger , JYPayPointRow) {
    JYPayPointRowYear,
    JYPayPointRowQuarter,
    JYPayPointRowMonth,
    JYPayPointRowCount
};

typedef NS_ENUM(NSUInteger , JYPayTypeRow) {
    JYPayTypeRowWechat,
    JYPayTypeRowAlipay,
    JYPayTypeRowCount
};

@interface JYPaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
    NSIndexPath *_defaultIndexPath;
    NSNumber    *_redPackPrice;
}
@property (nonatomic) QBBaseModel *baseModel;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) JYUpdateUserVipModel *updateVipModel;
@end

@implementation JYPaymentViewController
QBDefineLazyPropertyInitialization(QBBaseModel, baseModel)
QBDefineLazyPropertyInitialization(JYUpdateUserVipModel, updateVipModel)

#pragma mark - PayFunctions

- (void)payForWithBaseModel:(QBBaseModel *)baseModel vipLevel:(JYVipType)vipType price:(NSInteger)price;
{
    self.baseModel = baseModel;
    
    _redPackPrice = [NSNumber numberWithInteger:price];
    [self payForPaymentType:QBOrderPayTypeWeChatPay vipLevel:vipType];//默认支付宝支付

}

- (void)payForPaymentType:(QBOrderPayType)orderPayType vipLevel:(JYVipType)vipType {
    @weakify(self);
    [[QBPaymentManager sharedManager] startPaymentWithOrderInfo:[self createOrderInfoWithPaymentType:orderPayType vipLevel:vipType]
                                                    contentInfo:[self createContentInfo]
                                                    beginAction:^(QBPaymentInfo * paymentInfo) {
                                                        if (paymentInfo) {
 
                                                        }
                                                    } completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
                                                        @strongify(self);
                                                        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                                    }];
}

- (QBOrderInfo *)createOrderInfoWithPaymentType:(QBOrderPayType)payType vipLevel:(JYVipType)vipType {
    QBOrderInfo *orderInfo = [[QBOrderInfo alloc] init];
    
    NSString *channelNo = JY_CHANNEL_NO;
    if (channelNo.length > 14) {
        channelNo = [channelNo substringFromIndex:channelNo.length-14];
    }
    
    channelNo = [channelNo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    orderInfo.orderId = orderNo;
    
    NSUInteger price = 0;
    if (vipType == JYVipTypeMonth) {
        price = [JYSystemConfigModel sharedModel].vipPriceA;
    } else if (vipType == JYVipTypeQuarter) {
        price = [JYSystemConfigModel sharedModel].vipPriceB;
    } else if (vipType == JYVipTypeYear) {
        price = [JYSystemConfigModel sharedModel].vipPriceC;
    }
    
    if (_redPackPrice) {
        price = [_redPackPrice integerValue];
    }
    
//    price = 200;
    orderInfo.orderPrice = price;
    
    NSString *orderDescription = @"VIP";
    
    orderInfo.orderDescription = orderDescription;
    orderInfo.payType = payType;
    orderInfo.reservedData = [NSString stringWithFormat:@"%@$%@", JY_REST_APPID, JY_CHANNEL_NO];
    orderInfo.createTime = [JYUtil timeStringFromDate:[NSDate date] WithDateFormat:KDateFormatLong];
    orderInfo.payPointType = vipType;
    orderInfo.userId = [JYUtil UUID];
    
    return orderInfo;
}

- (QBContentInfo *)createContentInfo {
    QBContentInfo *contenInfo = [[QBContentInfo alloc] init];
    contenInfo.contentId = self.baseModel.programId;
    contenInfo.contentType = self.baseModel.programType;
    contenInfo.contentLocation = self.baseModel.programLocation;
    contenInfo.columnId = self.baseModel.realColumnId;
    contenInfo.columnType = self.baseModel.channelType;
    return contenInfo;
}

- (void)hidePayment {
//    [[QBStatsManager sharedManager] statsPayWithOrderNo:nil payAction:QBStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel andTabIndex:[JYUtil currentTabPageIndex] subTabIndex:[JYUtil currentSubTabPageIndex]];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
//    result = QBPayResultSuccess;
    if (result == QBPayResultSuccess) {
        [self hidePayment];
        [[JYHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        NSInteger months = 0;
        if (paymentInfo.payPointType == JYVipTypeYear) {
            months = 12;
        } else if (paymentInfo.payPointType == JYVipTypeQuarter) {
            months = 3;
        } else if (paymentInfo.payPointType == JYVipTypeMonth) {
            months = 1;
        }
        
        NSDate *expireDate = [[JYUtil expireDateTime] dateByAddingMonths:months];
        [JYUtil setVipExpireTime:[JYUtil timeStringFromDate:expireDate WithDateFormat:kDateFormatShort]];
        
        [self.updateVipModel updateUserVipInfo:paymentInfo.payPointType CompletionHandler:nil];
        
    } else if (result == QBPayResultCancelled) {
        [[JYHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[JYHudManager manager] showHudWithText:@"支付失败"];
    }
    
//    if (paymentInfo.orderId != nil) {
//        [[QBStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:QBStatsPayActionPayBack andTabIndex:[PPUtil currentTabPageIndex] subTabIndex:[PPUtil currentSubTabPageIndex]];
//    }
}


#pragma mark - UIFunctions

- (instancetype)initWithBaseModel:(QBBaseModel *)baseModel
{
    self = [super init];
    if (self) {
        self.baseModel = baseModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"充值成为会员"
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(36)],
                                                                    NSForegroundColorAttributeName:kColor(@"#333333")} forState:UIControlStateNormal];
    
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[JYPayHeaderCell class] forCellReuseIdentifier:kPayHeaderCellIdentifier];
    [_layoutTableView registerClass:[JYPayNewDynamicCell class] forCellReuseIdentifier:kPayNewDynamicCellIdentifier];
    [_layoutTableView registerClass:[JYPayPointCell class] forCellReuseIdentifier:kPayPointCellIdentifier];
    [_layoutTableView registerClass:[JYPayTypeCell class] forCellReuseIdentifier:kPayTypeCellIdentifier];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    _defaultIndexPath = [NSIndexPath indexPathForRow:JYPayPointRowYear inSection:JYPayCellSectionPayPointCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return JYPayCellSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYPayCellSectionPayPointCell) {
        return JYPayPointRowCount;
    }else if (section == JYPayCellSectionPayTypeCell){
        return JYPayTypeRowCount;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYPayCellSectionNewDynamicCell) {
        JYPayNewDynamicCell *newDynamicCell = [tableView dequeueReusableCellWithIdentifier:kPayNewDynamicCellIdentifier forIndexPath:indexPath];
        newDynamicCell.scrollContents = @[@"【一克拉的眼泪】获得100元话费",
                                          @"【一抹蓝】获得30元话费",
                                          @"【带你回家吧】获得30元话费",
                                          @"【晓玉】获得100元话费",
                                          @"【爱我老二】获得30元话费",
                                          @"【不苦姐姐】获得30元话费",
                                          @"【老实人】获得30元话费",
                                          @"【有胆你就来】获得100元话费",
                                          @"【曼曼】获得30元话费",
                                          @"【憨板子】获得30元话费",
                                          @"【温柔乡】获得30元话费",
                                          @"【七日情人】获得100元话费",
                                          @"【忘了我】获得30元话费",
                                          @"【由衷】获得100元话费",
                                          @"【天下共你】获得30元话费"];
        return newDynamicCell;
    } else if (indexPath.section == JYPayCellSectionTitleCell) {
        JYPayHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayHeaderCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == JYPayCellSectionPayPointCell){
        JYPayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayPointCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYPayPointRowYear) {
            cell.vipLevel = JYVipTypeYear;
            cell.isSelected = YES;
        }else if (indexPath.row == JYVipTypeQuarter){
            cell.vipLevel = JYVipTypeQuarter;
            cell.isSelected = NO;
        }else if (indexPath.row == JYVipTypeMonth){
            cell.vipLevel = JYVipTypeMonth;
            cell.isSelected = NO;
        }
        return cell;
    
    } else if (indexPath.section == JYPayCellSectionPayTypeCell){
        JYPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTypeCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYPayTypeRowWechat) {
            cell.orderPayType = QBOrderPayTypeWeChatPay;
        }else if (indexPath.row == JYPayTypeRowAlipay){
            cell.orderPayType = QBOrderPayTypeAlipay;
        }
        
        @weakify(self);
        cell.payAction = ^(NSNumber *payType){
            @strongify(self);
            if ([payType unsignedIntegerValue] == QBOrderPayTypeWeChatPay) {
                [self payForPaymentType:QBOrderPayTypeWeChatPay vipLevel:self->_defaultIndexPath.row];
            } else if ([payType unsignedIntegerValue] == QBOrderPayTypeAlipay) {
                [self payForPaymentType:QBOrderPayTypeAlipay vipLevel:self->_defaultIndexPath.row];
            }
        };
        
        return cell;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYPayCellSectionNewDynamicCell) {
        return kWidth(64);
    } else if (indexPath.section == JYPayCellSectionTitleCell){
        return [JYUtil deviceType] < JYDeviceType_iPhone5 ? kWidth(150) : kWidth(170);
    } else if (indexPath.section == JYPayCellSectionPayPointCell){
        return [JYUtil deviceType] < JYDeviceType_iPhone5 ? kWidth(170) : kWidth(200);
    } else if (indexPath.section == JYPayCellSectionPayTypeCell){
        return [JYUtil deviceType] < JYDeviceType_iPhone5 ? kWidth(120) : kWidth(180);
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYPayCellSectionPayPointCell) {
        for (int i = 0; i < [_layoutTableView numberOfRowsInSection:JYPayCellSectionPayPointCell]; i++) {
           JYPayPointCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:JYPayCellSectionPayPointCell]];
            cell.isSelected = NO;
        }
        JYPayPointCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;
        _defaultIndexPath = indexPath;
    } else if (indexPath.section == JYPayCellSectionPayTypeCell) {
        JYVipType vipType = (JYVipType)_defaultIndexPath.row;
        if (indexPath.row == JYPayTypeRowWechat) {
            [self payForPaymentType:QBOrderPayTypeWeChatPay vipLevel:vipType];
        } else if (indexPath.row == JYPayTypeRowAlipay) { 
            [self payForPaymentType:QBOrderPayTypeAlipay vipLevel:vipType];
        }
//        [self.updateVipModel updateUserVipInfo:vipType CompletionHandler:nil];
//        QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
//        paymentInfo.payPointType = 2;
//        [self notifyPaymentResult:QBPayResultSuccess withPaymentInfo:paymentInfo];
    }
}


@end
