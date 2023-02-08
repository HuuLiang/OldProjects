//
//  YFBMessageModel.m
//  YFBFriend
//
//  Created by Liang on 2017/4/18.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBMessageModel.h"

@implementation YFBMessageModel

+ (NSArray<YFBMessageModel *> *)allMessagesWithUserId:(NSString *)userId {
    NSArray  <YFBMessageModel *>* allMsgs = [self findByCriteria:[NSString stringWithFormat:@"WHERE sendUserId=\'%@\' or receiveUserId=\'%@\'",userId,userId]];
    NSMutableArray <YFBMessageModel *>*msgs = [NSMutableArray array];
    [allMsgs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(YFBMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.receiveUserId isEqualToString:userId] && idx != 0) {
            obj.readDone = YES;
        } else {
            obj.readDone = NO;
        }
        [msgs addObject:obj];
    }];
    
    return [[msgs reverseObjectEnumerator] allObjects];
}

+ (void)deleteAllPreviouslyMessages {
    [[YFBMessageModel findAll] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(YFBMessageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[NSDate dateWithTimeIntervalSince1970:obj.messageTime] isToday]) {
            [obj deleteObject];
        }
    }];
}

@end
