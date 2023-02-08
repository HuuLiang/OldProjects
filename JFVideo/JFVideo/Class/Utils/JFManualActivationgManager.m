//
//  JFManualActivationgManager.m
//  JFVideo
//
//  Created by ylz on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFManualActivationgManager.h"
#import "JFPaymentViewController.h"

@implementation JFManualActivationgManager

+ (instancetype)shareManager {
    static JFManualActivationgManager *_instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (void)doActivate {
    if ([JFUtil isVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"您已经购买了全部VIP，无需再激活！" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        return ;
    }
    NSArray<QBPaymentInfo *> *paymentInfos = [JFUtil allUnsuccessfulPaymentInfos];
    
    [[UIApplication sharedApplication].keyWindow beginLoading];
    [[QBPaymentManager sharedManager] activatePaymentInfos:paymentInfos withCompletionHandler:^(BOOL success, id obj) {
        [[UIApplication sharedApplication].keyWindow endLoading];
        
        if (success) {
            [UIAlertView bk_showAlertViewWithTitle:@"激活成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            [[JFPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:obj];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"未找到支付成功的订单" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        }
    }];
}

@end
