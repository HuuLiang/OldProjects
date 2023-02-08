//
//  JFPaymentPointView.h
//  JFVideo
//
//  Created by Liang on 16/9/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JFPaymentPriceLevel)(JFPayPriceLevel priceLevel);

@interface JFPaymentPointView : UIView

@property (nonatomic) JFPaymentPriceLevel levelAction;

@end
