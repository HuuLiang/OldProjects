//
//  SATextField.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATextField : UIView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@property (nonatomic,readonly,nullable) NSString *text;

@property (nonatomic) UIKeyboardType keyboardType;

@end
