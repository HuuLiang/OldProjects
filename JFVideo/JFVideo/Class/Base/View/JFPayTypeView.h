//
//  JFPayTypeView.h
//  JFVideo
//
//  Created by Liang on 16/8/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JFPaymentPopViewActions)(QBOrderPayType type);

@interface JFPayTypeView : UIView

- (instancetype)initWithPayTypesArray:(NSArray *)payTypes;

@property (nonatomic,copy) JFPaymentPopViewActions payAction;


@end
