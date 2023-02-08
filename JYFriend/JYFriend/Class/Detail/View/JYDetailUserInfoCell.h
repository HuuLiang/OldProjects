//
//  JYDetailUserInfoCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDetailUserInfoCell : UICollectionViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detailTitle;
@property (nonatomic,copy)QBAction vipAction;
@property (nonatomic,retain) UILabel *detailLabel;
@property (nonatomic) NSString *vipTitle;
@end
