//
//  JYSpreadBannerViewController.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYBaseViewController.h"

@class JYAppSpread;

@interface JYSpreadBannerViewController : JYBaseViewController
@property (nonatomic,retain,readonly) NSArray<JYAppSpread *> *spreads;
- (instancetype)initWithSpreads:(NSArray<JYAppSpread *> *)spreads;
- (void)showInViewController:(UIViewController *)viewController;
@end
