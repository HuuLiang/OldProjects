//
//  YFBPhotoManager.h
//  YFBFriend
//
//  Created by Liang on 2017/3/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void(^ImagePicker)(UIImage *pickerImage,NSString *keyName);

@interface YFBPhotoManager : QBEncryptedURLRequest

+ (instancetype)manager;

//- (void)saveAllImageKeys:(NSArray *)imageKeys;
//
//- (NSArray *)allImageKeys;
//
//- (void)saveOneImageKey:(NSString *)imageKey;



- (void)getImageInCurrentViewController:(UIViewController *)viewController handler:(ImagePicker)picker;

//- (void)uploadImageUrlWithUrlStr:(NSString *)urlStr handler:(void(^)(BOOL success))handler;

@end
