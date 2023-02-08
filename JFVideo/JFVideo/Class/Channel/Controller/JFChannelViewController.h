//
//  JFChannelViewController.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"
@class JFChannelColumnModel;
//typedef void(^channeColumnlCount)(NSUInteger count,CGFloat height);

@interface JFChannelViewController : JFBaseViewController

@property (nonatomic,retain)JFChannelColumnModel *column;
- (instancetype)initWithColumnId:(NSInteger)columnId ColumnName:(NSString *)name;

//@property (nonatomic)channeColumnlCount programCount;

//@property (nonatomic)UICollectionView *layoutCollectionView;

@end
