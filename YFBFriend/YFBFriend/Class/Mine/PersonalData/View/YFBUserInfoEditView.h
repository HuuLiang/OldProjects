//
//  YFBUserInfoEditView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/23.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancleBlock)(void);

@interface YFBUserInfoEditView : UIView

- (instancetype)initWithTitle:(NSString *)title hander:(void(^)(NSString *textFieldContent,YFBUserInfoOpenType openType))hander;

@property (nonatomic,copy) cancleBlock cancel;

@end
