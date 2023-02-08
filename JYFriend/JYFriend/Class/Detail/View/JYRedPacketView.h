//
//  JYRedPacketView.h
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYRedPacketView : UIView

@property (nonatomic,copy) QBAction closeAction;
@property (nonatomic) NSInteger price;
@property (nonatomic,copy)QBAction ktVipAction;
@property (nonatomic,copy)QBAction sendPacketAction;//发红包

@end
