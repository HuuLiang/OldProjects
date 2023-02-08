//
//  YFBDetailFooterView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YFBFooterFunction) {
    YFBFunctionSendMsg = 0,
    YFBFunctionSendGreet,
    YFBFunctionSendFollow
};

typedef void(^SendInfoType)(NSUInteger);

@interface YFBDetailFooterView : UIView

@property (nonatomic,copy) SendInfoType infoType;

@end
