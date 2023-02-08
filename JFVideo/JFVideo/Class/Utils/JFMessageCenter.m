//
//  JFMessageCenter.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFMessageCenter.h"
#import "TSMessage.h"

@implementation JFMessageCenter

+ (instancetype)defaultCenter {
    static JFMessageCenter *_defaultCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultCenter = [[self alloc] init];
    });
    return _defaultCenter;
}

+ (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController.presentedViewController) {
        return viewController.presentedViewController;
    } else {
        return viewController;
    }
}

- (void)showMessageWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[JFMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeMessage duration:2];
}

- (void)showWarningWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[JFMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeWarning duration:2];
}

- (void)showErrorWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[JFMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeError duration:2];
}

- (void)showSuccessWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[JFMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeSuccess duration:2];
}

- (void)dismissMessageWithCompletion:(void (^)(void))completion {
    [TSMessage dismissActiveNotificationWithCompletion:completion];
}

- (void)showProgressWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window beginProgressingWithTitle:title subtitle:subtitle];
}

- (void)proceedProgressWithPercent:(double)percent {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window progressWithPercent:percent];
}

- (void)hideProgress {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window endProgressing];
}


@end
