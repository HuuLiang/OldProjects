//
//  YFBGiftPopViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@class  YFBContactModel;



@interface YFBGiftPopViewController : YFBBaseViewController

+ (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController;

- (void)showGiftViewWithType:(YFBGiftPopViewType)type InCurrentViewController:(UIViewController *)currentViewController;

- (void)hide;

@property (nonatomic) YFBContactModel *contactInfo;

@property (nonatomic,copy) YFBAction payAction;
@property (nonatomic,copy) QBAction sendGiftAction;

@end
