//
//  SACleanUpContentVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SACleanUpContentVC.h"
#import "SAMineAlertUIHelper.h"

@interface SACleanUpContentVC () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) SAMineCleanUpType type;
@end

@implementation SACleanUpContentVC

- (instancetype)initWithType:(SAMineCleanUpType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    NSString *contentUrl = nil;
    
    switch (_type) {
        case SAMineCleanUpTypeShare:
            contentUrl = [NSString stringWithFormat:@"%@%@",SA_BASE_URL,SA_SHAREMM_URL];
            break;
        case SAMineCleanUpTypeRecruit:
            contentUrl = [NSString stringWithFormat:@"%@%@",SA_BASE_URL,SA_APPRENTICEMM_URL];
            break;
            
        default:
            break;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:contentUrl]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [SAMineAlertUIHelper showAlertUIWithType:1 onCurrentVC:self];
}

@end
