//
//  JFVideoPlayer.h
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFVideoPlayer : UIView
@property (nonatomic) NSURL *videoURL;
- (instancetype)initWithVideoURL:(NSURL *)videoURL;
- (void)startToPlay;
- (void)pause;
@property (nonatomic,copy) JFAction endPlayAction;
@end
