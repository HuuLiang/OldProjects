//
//  YFBVoiceManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBVoiceManager.h"
#import <AVFoundation/AVFoundation.h>

@interface YFBVoiceManager ()
@property (nonatomic) SystemSoundID faceTimeId;
@property (nonatomic) SystemSoundID sendMsgId;
@property (nonatomic) SystemSoundID receMsgId;
@end

@implementation YFBVoiceManager

+ (instancetype)manager {
    static YFBVoiceManager *_voiceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _voiceManager = [[YFBVoiceManager alloc] init];
    });
    return _voiceManager;
}

- (SystemSoundID)faceTimeId {
    if (_faceTimeId) {
        return _faceTimeId;
    }
    _faceTimeId = 1314;
    return _faceTimeId;
}

- (SystemSoundID)sendMsgId {
    if (_sendMsgId) {
        return _sendMsgId;
    }
    _sendMsgId = 1004;
    return _sendMsgId;
}

- (SystemSoundID)receMsgId {
    if (_receMsgId) {
        return _receMsgId;
    }
    _receMsgId = 1003;
    return _receMsgId;
}

- (void)playSendVoice {
    AudioServicesPlaySystemSound(self.sendMsgId);
}

- (void)playReceiveVoice {
    AudioServicesPlaySystemSound(self.receMsgId);
}

- (void)playFaceTimeVoice {
    AudioServicesAddSystemSoundCompletion(self.faceTimeId, NULL, NULL, systemAudioCallback, NULL);
    AudioServicesPlaySystemSound(self.faceTimeId);
}

void systemAudioCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(sound);
}


- (void)endFaceTimeVoice {
    AudioServicesDisposeSystemSoundID(self.faceTimeId);
    AudioServicesRemoveSystemSoundCompletion(self.faceTimeId);
}

@end
