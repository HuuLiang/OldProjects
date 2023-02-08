//
//  JYMyPhotoCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMyPhotoCell : UICollectionViewCell

@property (nonatomic,assign)BOOL isAdd;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) UIImage *image;

@property (nonatomic) BOOL isDelegate;
@property (nonatomic,copy) QBAction action;
@end
