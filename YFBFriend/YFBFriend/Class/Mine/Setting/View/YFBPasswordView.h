//
//  YFBPasswordView.h
//  YFBFriend
//
//  Created by Liang on 2017/3/27.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFBPasswordTextFieldDelegate <NSObject>
@optional
- (void)textFieldEditingContent:(NSString *)content;
@end

@interface YFBPasswordView : UIView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@property (nonatomic,copy,readonly) NSString *content;

@property (nonatomic,weak) id <YFBPasswordTextFieldDelegate> delegate;

- (void)resignFirstResponse;

@end
