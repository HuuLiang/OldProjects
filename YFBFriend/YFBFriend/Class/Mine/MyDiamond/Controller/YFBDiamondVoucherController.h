//
//  YFBDiamondVoucherController.h
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBDiamondVoucherController : YFBBaseViewController

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond;

- (instancetype)initWithPrice:(CGFloat)price diamond:(NSInteger)diamond Action:(NSString *)payAction;

@end
