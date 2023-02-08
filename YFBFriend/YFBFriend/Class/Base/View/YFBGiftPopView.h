//
//  YFBGiftPopView.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBGiftPopView : UIView

@property (nonatomic) NSInteger diamondCount;

- (instancetype)initWithGiftInfos:(NSArray *)giftInfos WithGiftViewType:(YFBGiftPopViewType)type;

- (void)startSelectedDefaultIndexPath;

@property (nonatomic,copy) YFBAction payAction;
@property (nonatomic,copy) QBAction sendGiftAction;

@end
