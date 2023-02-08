//
//  JFPaymentPopView.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JFPaymentPopViewAction)(QBOrderPayType payType,JFPayPriceLevel priceLevel);

@interface JFPaymentPopView : UITableView

@property (nonatomic,retain) NSArray *availablePaymentTypes;

@property (nonatomic,copy) JFPaymentPopViewAction paymentAction;

@property (nonatomic,copy) JFAction closeAction;

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes;


@end
