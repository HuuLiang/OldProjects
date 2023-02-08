//
//  JFPaymentViewController.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFBaseModel.h"

@interface JFPaymentViewController : JFBaseViewController

+ (instancetype)sharedPaymentVC;

- (void)popupPaymentInView:(UIView *)view
                 baseModel:(JFBaseModel *)model
     withCompletionHandler:(void (^)(void))completionHandler;

- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;

@end
