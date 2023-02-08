//
//  JFWebViewController.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFWebViewController : JFBaseViewController

@property (nonatomic) NSURL *url;
@property (nonatomic,readonly) NSURL *standbyUrl;
@property (nonatomic,readonly) NSString *htmlString;

- (instancetype)initWithURL:(NSURL *)url standbyURL:(NSURL *)standbyUrl;
- (instancetype)initWithHTML:(NSString *)htmlString;

@end
