//
//  JFVersionUpdateModel.h
//  JFuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface JFVersionUpdateInfo : QBURLResponse

@property (nonatomic) NSString *versionNo;
@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSNumber *isForceToUpdate;
@property (nonatomic) NSNumber *up;
@end

@interface JFVersionUpdateModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) JFVersionUpdateInfo *fetchedVersionInfo;
+ (instancetype)sharedModel;
- (BOOL)fetchLatestVersionWithCompletionHandler:(JFCompletionHandler)completionHandler;


@end
