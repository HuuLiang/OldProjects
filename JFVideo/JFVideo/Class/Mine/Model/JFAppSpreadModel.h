//
//  JFAppSpreadModel.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

@interface JFAppSpread : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *pkgName;
@property (nonatomic) NSString *postTime;
@property (nonatomic) NSUInteger programId;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSString *offUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger type;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *spreadImg;
@property (nonatomic) BOOL isInstall;
@end

@interface JFAppSpreadResponse : QBURLResponse
@property (nonatomic) NSArray <JFAppSpread *> *programList;
@end

@interface JFAppSpreadModel : QBEncryptedURLRequest
@property (nonatomic,retain,readonly) NSMutableArray<JFAppSpread *> *fetchedSpreads;
- (BOOL)fetchAppSpreadWithCompletionHandler:(JFCompletionHandler)handler;
@end
