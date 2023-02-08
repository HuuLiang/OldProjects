//
//  SAShareDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareDetailVC.h"
#import "SADetailFooterView.h"
#import "SAMineAlertUIHelper.h"
#import "SAShareContentModel.h"
#import "SAShareManager.h"
#import "SAAboutUsVC.h"

@interface SAShareDetailVC () <UIWebViewDelegate>
@property (nonatomic) UIWebView *shareDetailView;
@property (nonatomic) SAShareContentProgramModel *programModel;
@property (nonatomic) SADetailFooterView *footerView;
@end

@implementation SAShareDetailVC

- (instancetype)initWithInfo:(SAShareContentProgramModel *)programModel {
    self = [super init];
    if (self) {
        _programModel = programModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    self.shareDetailView = [[UIWebView alloc] init];
    _shareDetailView.delegate = self;
    [self.view addSubview:_shareDetailView];
    {
        [_shareDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (_programModel.shUrl.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_programModel.shUrl]];
        [_shareDetailView loadRequest:request];
    } else {
        [self showError];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showError {
    [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeNetworkError onCurrentVC:self];
}

- (void)configShareModel {
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"share_start"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self startToShareContent];
    }];
    
    self.footerView = [[SADetailFooterView alloc] init];
    [self.view addSubview:_footerView];
    
    _footerView.ruleAction = ^{
        @strongify(self);
        SAAboutUsVC *aboutUsVC = [[SAAboutUsVC alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",SA_BASE_URL,SA_RULE_URL]];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    };
    
    _footerView.shareAction = ^{
        @strongify(self);
        [self startToShareContent];
    };
    
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(90));
        }];
    }
}

- (void)startToShareContent {
    if (![SAUtil checkUserIsLogin]) {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeShareOffline onCurrentVC:self];
    } else {
        [[SAShareManager manager] startToShareWithModel:_programModel];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [self configShareModel];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self showError];
}

@end
