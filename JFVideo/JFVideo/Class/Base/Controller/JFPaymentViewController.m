//
//  JFPaymentViewController.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentViewController.h"
#import "JFPaymentPopView.h"
#import <QBPayment/QBPaymentManager.h>
#import "JFSystemConfigModel.h"

@interface JFPaymentViewController ()
@property (nonatomic) JFPaymentPopView *popView;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) JFBaseModel *baseModel;
@end

@implementation JFPaymentViewController
QBDefineLazyPropertyInitialization(JFBaseModel, baseModel)

+ (instancetype)sharedPaymentVC {
    static JFPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[JFPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (JFPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    NSMutableArray *availablePaymentTypes = [NSMutableArray array];
    
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeWeChatPay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeWeChatPay)}];
    }
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeAlipay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeAlipay)}];
    }
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeQQPay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeQQPay)}];
    }
    
    _popView = [[JFPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(QBOrderPayType payType, JFPayPriceLevel priceLevel) {
        @strongify(self);
        [self payForPaymentType:payType withPriceLevel:priceLevel];
        
        
        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        [[JFStatsManager sharedManager] statsPayWithOrderNo:nil payAction:JFStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)payForPaymentType:(QBOrderPayType)payType withPriceLevel:(JFPayPriceLevel)priceLevel {
    [[QBPaymentManager sharedManager] startPaymentWithOrderInfo:[self createOrderInfoWithPaymentType:payType vipLevel:priceLevel] contentInfo:[self createContentInfo] beginAction:^(QBPaymentInfo *paymentInfo) {
        if (paymentInfo) {
                    [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:JFStatsPayActionGoToPay andTabIndex:[JFUtil currentTabPageIndex] subTabIndex:[JFUtil currentSubTabPageIndex]];
                }
        
    } completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
    }];
    
}


- (QBOrderInfo *)createOrderInfoWithPaymentType:(QBOrderPayType)payType vipLevel:(JFPayPriceLevel)priceLevel {
    QBOrderInfo *orderInfo = [[QBOrderInfo alloc] init];
    
    NSString *channelNo = JF_CHANNEL_NO;
    if (channelNo.length > 14) {
        channelNo = [channelNo substringFromIndex:channelNo.length-14];
    }
    
    channelNo = [channelNo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    orderInfo.orderId = orderNo;
    NSUInteger price = 0;
    if (priceLevel == JFPayPriceLevelA) {
        price = [JFSystemConfigModel sharedModel].payAmount;
    } else if (priceLevel == JFPayPriceLevelB) {
        price = [JFSystemConfigModel sharedModel].payAmountPlus;
    } else if (priceLevel == JFPayPriceLevelC) {
        price = [JFSystemConfigModel sharedModel].payAmountPlus;
    }
//    price = 200;
    orderInfo.orderPrice = price;
    NSString *orderDescription = @"VIP";
    
    orderInfo.orderDescription = orderDescription;
    orderInfo.payType = payType;
    orderInfo.reservedData = [JFUtil paymentReservedData];
    orderInfo.createTime = [JFUtil currentTimeString];
    orderInfo.payPointType = priceLevel;
    orderInfo.userId = [JFUtil userId];
    
    return orderInfo;
}

- (QBContentInfo *)createContentInfo {
    QBContentInfo *contenInfo = [[QBContentInfo alloc] init];
    contenInfo.contentId = self.baseModel.programId;
    contenInfo.contentType = self.baseModel.programType;
    contenInfo.contentLocation = [NSNumber numberWithInteger:self.baseModel.programLocation];
    contenInfo.columnId = self.baseModel.realColumnId;
    contenInfo.columnType = self.baseModel.channelType;
    return contenInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popupPaymentInView:(UIView *)view
                 baseModel:(JFBaseModel *)model
     withCompletionHandler:(void (^)(void))completionHandler
{
    [self.view beginLoading];
    self.completionHandler = completionHandler;
    self.baseModel = model;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    UIView *hudView = [CRKHudManager manager].hudView;
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [self.view addSubview:self.popView];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:PaymentTypeSection];
    [self.popView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kWidth(600);
            CGFloat height = kWidth(780);
            make.size.mas_equalTo(CGSizeMake(width,height));
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)hidePayment {
    [self.view endLoading];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        
        self.baseModel = nil;
        
    }];
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
//    
//    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
//    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
//    
//    paymentInfo.paymentResult = result;
//    paymentInfo.paymentStatus = QBPayStatusNotProcessed;
//    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
//    [paymentInfo save];
    
    if (result == QBPayResultSuccess) {
        [JFUtil registerVip];
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == QBPayResultCancelled) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
//    BOOL success = [self.commitModel commitPaymentInfo:paymentInfo];
//    if (success) {
//        QBLog(@"支付订单同步成功");
//    }
    
    
    [[JFStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                               forPayAction:JFStatsPayActionPayBack
                                                andTabIndex:[JFUtil currentTabPageIndex]
                                                subTabIndex:[JFUtil currentSubTabPageIndex]];
}



@end
