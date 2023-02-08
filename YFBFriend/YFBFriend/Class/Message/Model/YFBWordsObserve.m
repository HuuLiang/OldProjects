//
//  YFBWordsObserve.m
//  YFBFriend
//
//  Created by Liang on 2017/5/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBWordsObserve.h"
#import "YFBMessageModel.h"
#import "YFBAutoReplyManager.h"

static NSString *kYFBReplyMessageFileName = @"ReplyMessage";

@interface YFBWordsObserve ()
@property (nonatomic) NSMutableArray *keyWords;
@property (nonatomic) NSMutableArray *replyWords;
@end

@implementation YFBWordsObserve

QBDefineLazyPropertyInitialization(NSMutableArray, keyWords)

QBDefineLazyPropertyInitialization(NSMutableArray, replyWords)

+ (instancetype)observe {
    static YFBWordsObserve *_observe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _observe = [[YFBWordsObserve alloc] init];
    });
    return _observe;
}

- (NSDictionary *)bundleFileData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ReplyMessage" ofType:@"plist"];
    NSDictionary *fileData = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    return fileData;
}

- (NSString *)documentFilePath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingPathComponent:@"ReplyMessage.plist"];
    return filePath;
}

- (void)checkDocumentFile {
    NSString *filePath = [self documentFilePath];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL exit =[filemanage fileExistsAtPath:filePath];
    NSDictionary *fileData = nil;
    if (exit) {
        fileData = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    } else {
        fileData = [self bundleFileData];
        [fileData writeToFile:filePath atomically:YES];
    }
    [self.keyWords removeAllObjects];
    [self.keyWords addObjectsFromArray:fileData[@"keywords"]];
    [self.replyWords removeAllObjects];
    [self.replyWords addObjectsFromArray:fileData[@"replyMsg"]];
}

- (void)checkMessageContent:(YFBMessageModel *)messageModel {
    [self checkDocumentFile];
    
    BOOL haveKeyword = NO;
    for (NSString *keyword in self.keyWords) {
        if ([messageModel.content rangeOfString:keyword].location != NSNotFound) {
            haveKeyword = YES;
            break;
        }
    }
    
    if (haveKeyword && self.replyWords.count > 0) {
        NSString *replyMsg = self.replyWords[(arc4random() % self.replyWords.count)];
        [[YFBAutoReplyManager manager] insertAutoReplyMessageWithUserIs:messageModel.receiveUserId MessageContent:replyMsg];
        [self.replyWords removeObject:replyMsg];
        NSDictionary *newData = @{@"keywords":self.keyWords,
                                  @"replyMsg":self.replyWords};
        [newData writeToFile:[self documentFilePath] atomically:YES];
	    }
}

@end
