//
//  JYUpdateUserVipModel.h
//  JYFriend
//
//  Created by Liang on 2017/1/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface JYUpdateUserVipResponse : QBURLResponse
@property (nonatomic) NSString *vipEndDate;
@end

@interface JYUpdateUserVipModel : QBEncryptedURLRequest

- (BOOL)updateUserVipInfo:(JYVipType)vipType CompletionHandler:(QBCompletionHandler)handler;

@end
