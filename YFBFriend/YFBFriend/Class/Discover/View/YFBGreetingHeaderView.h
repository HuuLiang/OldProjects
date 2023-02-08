//
//  YFBGreetingHeaderView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GreetingBlock)(void);

@interface YFBGreetingHeaderView : UICollectionReusableView

@property (nonatomic,copy) NSString *backImageUrl;
@property (nonatomic,copy) NSString *frontImageUrl;

@property (nonatomic,copy) GreetingBlock greeingBlock;

@end
