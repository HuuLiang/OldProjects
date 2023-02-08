//
//  JQKPaymentViewController.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKProgram;

@interface JQKPaymentViewController : JQKBaseViewController

+ (instancetype)sharedPaymentVC;

//- (void)popupPaymentInView:(UIView *)view forProgram:(JQKProgram *)program withCompletionHandler:(void (^)(void))completionHandler;
- (void)popupPaymentInView:(UIView *)view
                forProgram:(JQKProgram *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(JQKChannels *)channel
     withCompletionHandler:(void (^)(void))completionHandler;
- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;
@end
