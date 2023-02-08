//
//  JYDetailViewController.h
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYDetailViewController : JYBaseViewController

//@property (nonatomic) NSString *dynamicTiem;//动态时间
//@property (nonatomic) NSString *distance;//距离
//@property (nonatomic) NSString *viewUserId;//被查看的机器人ID

- (instancetype)initWithUserId:(NSString *)userId time:(NSString *)time distance:(NSString *)distance nickName:(NSString *)nickName;

@end
