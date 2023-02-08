//
//  YFBVoiceManager.h
//  YFBFriend
//
//  Created by Liang on 2017/5/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBVoiceManager : NSObject

+ (instancetype)manager;

- (void)playFaceTimeVoice;

- (void)endFaceTimeVoice;

- (void)playSendVoice;

- (void)playReceiveVoice;

@end
