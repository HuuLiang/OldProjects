//
//  YFBWebViewController.h
//  YFBFriend
//
//  Created by Liang on 2017/5/20.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBBaseViewController.h"

@interface YFBWebViewController : YFBBaseViewController
@property (nonatomic) NSURL *url;
@property (nonatomic,readonly) NSURL *standbyUrl;
@property (nonatomic,readonly) NSString *htmlString;

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl;
- (instancetype)initWithHTML:(NSString *)htmlString;
@end
