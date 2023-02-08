//
//  SAHudManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAHudManager : NSObject

@property (nonatomic,retain,readonly) UIView *hudView;

+(instancetype)manager;
-(void)showHudWithText:(NSString *)text;
-(void)showHudWithTitle:(NSString *)title message:(NSString *)msg;
-(void)showProgressInDuration:(NSTimeInterval)duration;
- (void)showProlgressShowTitle:(NSString *)title withDuration:(NSTimeInterval)duration progress:(CGFloat)progress completeHanlder:(void(^)(void))completeHanlder;

@end
