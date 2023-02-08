//
//  JYVideoChatView.h
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYVideoChatView : UIView

@property (nonatomic) NSString *headerImageUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *chatState;
@property (nonatomic,copy)QBAction action;//挂断

@end
