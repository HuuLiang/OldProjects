//
//  YFBContactView.h
//  YFBFriend
//
//  Created by Liang on 2017/5/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFBAutoReplyMessage;

typedef void(^ReplyAction)(NSString *userId,NSString *nickName,NSString *portraitUrl);

@interface YFBContactView : UIView

+ (void)showInCurrentViewController:(UIViewController *)viewController MessageInfo:(YFBAutoReplyMessage *)messageInfo;

- (instancetype)initWithContactInfo:(YFBAutoReplyMessage *)contactModel replyHandler:(ReplyAction)handler;



@end
