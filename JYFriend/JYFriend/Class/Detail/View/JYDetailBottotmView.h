//
//  JYDetailBottotmView.h
//  JYFriend
//
//  Created by ylz on 2017/1/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDetailBottomModel : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *image;
+ (instancetype)creatBottomModelWith:(NSString *)title withImage:(NSString *)image;

@end

@interface JYDetailBottotmView : UIView

@property (nonatomic,retain) NSArray <JYDetailBottomModel *> *buttonModels;
@property (nonatomic,copy)QBAction action;
@property (nonatomic) BOOL attentionBtnSelect;
@end
