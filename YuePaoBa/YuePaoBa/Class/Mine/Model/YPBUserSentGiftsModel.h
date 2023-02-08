//
//  YPBUserSentGiftsModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBUserGiftsDataSource.h"

@interface YPBUserSentGiftsResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<YPBGift *> *gifts;
@end

@interface YPBUserSentGiftsModel : YPBEncryptedURLRequest <YPBUserGiftsDataSource>

@property (nonatomic,retain,readonly) NSArray<YPBGift *> *fetchedGifts;

- (BOOL)fetchGiftsByUser:(NSString *)userId withCompletionHandler:(YPBCompletionHandler)handler;

@end
