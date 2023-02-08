//
//  JFChannelCell.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFChannelColumnModel.h"

@interface JFChannelCell : UICollectionViewCell
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSInteger rankCount;
@property (nonatomic) NSString * hotCount;


@end
