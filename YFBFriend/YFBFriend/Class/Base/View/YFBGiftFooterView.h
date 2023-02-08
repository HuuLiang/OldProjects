//
//  YFBGiftReusableView.h
//  YFBFriend
//
//  Created by Liang on 2017/4/17.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBGiftFooterView : UIView

- (instancetype)initWithGiftType:(YFBGiftPopViewType)type;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageNumbers;
@property (nonatomic) NSInteger diamondCount;

@property (nonatomic,copy) YFBAction payAction;
@property (nonatomic,copy) YFBAction sendAction;

@end
