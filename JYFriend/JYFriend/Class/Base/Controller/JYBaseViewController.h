//
//  JYBaseViewController.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

//- (instancetype)init __attribute__ ((unavailable("Use initWithTitle: instead")));
- (instancetype)initWithTitle:(NSString *)title;
- (UIViewController *)playerVCWithVideo:(NSString *)videoUrl;

//跳转到详情页
- (void)pushDetailViewControllerWithUserId:(NSString *)userId time:(NSString *)timeStr distance:(NSString *)distance nickName:(NSString *)nickName;

//支付弹窗
- (void)presentPayViewController;

@end
