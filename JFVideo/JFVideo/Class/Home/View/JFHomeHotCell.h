//
//  JFHomeHotCell.h
//  JFVideo
//
//  Created by Liang on 16/6/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFHomeHotCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) BOOL isFree;

@end
