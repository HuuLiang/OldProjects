//
//  YFBMineHeaderCell.h
//  YFBFriend
//
//  Created by Liang on 2017/3/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBMineHeaderCell : UITableViewCell

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *idNumber;
@property (nonatomic,copy) NSString *headerImage;
@property (nonatomic,copy) NSString *invite;//邀请码

@property (nonatomic,copy) QBAction ktVipAction;//开通VIP
@property (nonatomic,copy) QBAction attestationAction;//手机认证

@end
