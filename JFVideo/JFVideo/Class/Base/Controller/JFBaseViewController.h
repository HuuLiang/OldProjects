//
//  JFBaseViewController.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFBaseModel.h"

@interface JFBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;

- (void)payWithInfo:(JFBaseModel *)model;

- (void)playPhotoUrlWithInfo:(JFBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index;

- (void)playVideoWithInfo:(JFBaseModel *)model videoUrl:(NSString *)videoUrlStr;

- (NSUInteger)currentIndex;
- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(JFAction) action;
- (void)removeCurrentRefreshBtn;
@end
