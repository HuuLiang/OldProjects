//
//  JYVideoChatViewController.h
//  JYFriend
//
//  Created by ylz on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYVideoChatViewController : JYBaseViewController

@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *headImageUrl;
@property (nonatomic,copy)QBAction closeAction;

@end
