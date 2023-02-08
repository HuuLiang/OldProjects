//
//  JFChannelProgramModel.h
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

@interface JFChannelProgram : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSInteger programId;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spec;
@property (nonatomic) NSString *speciaDesc;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *videoUrl;
@end

@interface JFChannelProgramResponse : QBURLResponse
@property (nonatomic) NSArray <JFChannelProgram *> *programList;
@end

@interface JFChannelProgramModel : QBEncryptedURLRequest

- (BOOL)fecthChannelProgramWithColumnId:(NSInteger)columnId Page:(NSInteger)page CompletionHandler:(JFCompletionHandler)handler;

@end
