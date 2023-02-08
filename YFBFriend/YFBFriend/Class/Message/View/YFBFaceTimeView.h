//
//  YFBFaceTimeView.h
//  YFBFriend
//
//  Created by Liang on 2017/5/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFBAutoReplyMessage;

@interface YFBFaceTimeView : UIView

+ (void)showFaceTimeViewWith:(YFBAutoReplyMessage *)messageModel InCurrentViewController:(UIViewController *)viewController;

- (instancetype)initWithInfo:(YFBAutoReplyMessage *)messageModel;

@property (nonatomic) YFBAction refuseAction;
@property (nonatomic) YFBAction answerAction;

@end
