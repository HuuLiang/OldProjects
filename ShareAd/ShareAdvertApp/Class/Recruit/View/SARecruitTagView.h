//
//  SARecruitTagView.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SATagViewType) {
    SATagViewTypeTodayRecruit = 0,
    SATagViewTypeAllRecruit,
    SATagViewTypeTodayBalance,
    SATagViewTypeAllBalance
};

@interface SARecruitTagView : UIView

@property (nonatomic) SATagViewType tagType;

@property (nonatomic) NSString *count;

@end
