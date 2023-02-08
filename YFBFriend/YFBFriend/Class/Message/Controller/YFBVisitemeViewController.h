//
//  YFBVisitemeViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/5/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBVisitemeCell : UICollectionViewCell
@property (nonatomic) NSString *imageUrl;
@end

@interface YFBVisitemeFooterView : UICollectionReusableView
@property (nonatomic) YFBAction payAction;
@end

@interface YFBVisiteMeCountFooterView : UICollectionReusableView
@property (nonatomic) NSInteger visiteMeCount;
@end

@interface YFBVisitemeViewController : YFBBaseViewController

@end

