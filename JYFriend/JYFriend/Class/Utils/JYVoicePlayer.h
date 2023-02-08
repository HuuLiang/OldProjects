//
//  JYVoicePlayer.h
//  JYFriend
//
//  Created by Liang on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JYVoicePlayer : AVAudioPlayer

+ (void)playLocalVoiceFileWithPath:(NSString *)voicePath action:(void (^)(void))handler;

@end
