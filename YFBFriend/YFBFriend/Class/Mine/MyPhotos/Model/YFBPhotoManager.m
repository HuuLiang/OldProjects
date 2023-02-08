//
//  YFBPhotoManager.m
//  YFBFriend
//
//  Created by Liang on 2017/3/28.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBPhotoManager.h"
#import "XHPhotographyHelper.h"
#import <CommonCrypto/CommonDigest.h>

#define CC_MD5_DIGEST_LENGTH 16


static NSString *const kYFBPhotoCacheKeyName = @"YFBPhotoCacheKeyName";

@interface YFBPhotoManager () <UIActionSheetDelegate>
@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;
@end

@implementation YFBPhotoManager
QBDefineLazyPropertyInitialization(XHPhotographyHelper, photographyHelper)

+ (instancetype)manager {
    static YFBPhotoManager *_photoManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _photoManager = [[YFBPhotoManager alloc] init];
    });
    return _photoManager;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

//- (void)saveAllImageKeys:(NSArray *)imageKeys {
//    [[NSUserDefaults standardUserDefaults] setObject:imageKeys forKey:kYFBPhotoCacheKeyName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSArray *)allImageKeys {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kYFBPhotoCacheKeyName];
//}
//
//- (void)saveOneImageKey:(NSString *)imageKey {
//    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[self allImageKeys]];
//    [allKeys addObject:imageKey];
//    [self saveAllImageKeys:allKeys];
//}
//
//- (void)removeFormCache:(NSString *)imageKey {
//    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[self allImageKeys]];
//    [allKeys enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([key isEqualToString:imageKey]) {
//            [allKeys removeObject:key];
//            * stop = YES;
//        }
//    }];
//    [self saveAllImageKeys:allKeys];
//}


- (void)getImageInCurrentViewController:(UIViewController *)viewController handler:(ImagePicker)picker {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
    [actionSheet showInView:viewController.view];
    
    @weakify(self);
    void (^PickerMediaBlock)(UIImage *image, NSDictionary *editingInfo) = ^(UIImage *image, NSDictionary *editingInfo) {
        @strongify(self);
        UIImage *originalImage = editingInfo[UIImagePickerControllerOriginalImage];
        if (originalImage) {
            picker(originalImage,[self getMd5ImageKeyNameWithImage:originalImage]);
        } else {
            [[YFBHudManager manager] showHudWithText:@"图片获取失败"];
        }
    };
    
    [actionSheet bk_setHandler:^{
        @strongify(self);
        //相册
        [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:viewController compled:PickerMediaBlock];
    } forButtonAtIndex:0];
    
    [actionSheet bk_setHandler:^{
        @strongify(self);
        //相机
        [self.photographyHelper showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:viewController compled:PickerMediaBlock];
    } forButtonAtIndex:1];
}

- (NSString *)getMd5ImageKeyNameWithImage:(UIImage *)image {
    
    NSData *sourceData = UIImageJPEGRepresentation(image, 1.0);
    
    if (!sourceData) {
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //需要MD5变量并且初始化
    CC_MD5_CTX  md5;
    CC_MD5_Init(&md5);
    //开始加密(第一个参数：对md5变量去地址，要为该变量指向的内存空间计算好数据，第二个参数：需要计算的源数据，第三个参数：源数据的长度)
    CC_MD5_Update(&md5, sourceData.bytes, (CC_LONG)sourceData.length);
    //声明一个无符号的字符数组，用来盛放转换好的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //将数据放入result数组
    CC_MD5_Final(result, &md5);
    //将result中的字符拼接为OC语言中的字符串，以便我们使用。
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X",result[i]];
    }
    //    NSLog(@"resultString=========%@",resultString);
    return  resultString;

}

//- (void)uploadImageUrlWithUrlStr:(NSString *)urlStr handler:(void (^)(BOOL))handler {
//    NSDictionary *params = @{@"channelNo":YFB_CHANNEL_NO,
//                             @"userId":[YFBUser currentUser].userId,
//                             @"token":[YFBUser currentUser].token,
//                             @"photoStr":urlStr};
//    
//    [self requestURLPath:YFB_SAVEPHOTO_URL
//          standbyURLPath:nil
//              withParams:params
//         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
//    {
//        if (handler) {
//            handler(respStatus == QBURLResponseSuccess);
//        }
//    }];
//}

@end
