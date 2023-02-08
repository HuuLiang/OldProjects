//
//  JFMessageCenter.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFMessageCenter : NSObject
+ (instancetype)defaultCenter;
- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)defaultCenter instead")));

- (void)showMessageWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showWarningWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showErrorWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showSuccessWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;

- (void)dismissMessageWithCompletion:(void (^)(void))completion;

- (void)showProgressWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)proceedProgressWithPercent:(double)percent;
- (void)hideProgress;

@end

#define JFShowMessage(_title) [[JFMessageCenter defaultCenter] showMessageWithTitle:_title inViewController:nil]
#define JFShowWarning(_title) [[JFMessageCenter defaultCenter] showWarningWithTitle:_title inViewController:nil]
#define JFShowError(_title)   [[JFMessageCenter defaultCenter] showErrorWithTitle:_title inViewController:nil]
#define JFShowSuccess(_title) [[JFMessageCenter defaultCenter] showSuccessWithTitle:_title inViewController:nil]
