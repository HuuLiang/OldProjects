//
//  JFDetailModel.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBNetworking/QBEncryptedURLRequest.h>

@interface JFDetailPhotoModel : NSObject
@property (nonatomic) NSInteger height;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSInteger width;
@end

@interface JFDetailProgramModel : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *detailsCoverImg;
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

@interface JFDetailCommentModel : NSObject
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *createAt;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *userName;
@end

@interface JFDetailModelResponse : QBURLResponse
@property (nonatomic) NSInteger columnId;
@property (nonatomic) NSArray <JFDetailCommentModel *> *commentJson;
@property (nonatomic) JFDetailProgramModel *program;
@property (nonatomic) NSArray <JFDetailPhotoModel *> *programUrlList;
@end

@interface JFDetailModel : QBEncryptedURLRequest

- (BOOL)fetchProgramDetailWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId CompletionHandler:(JFCompletionHandler)handler;

@end
