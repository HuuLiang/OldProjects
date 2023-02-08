//
//  JYRedPackPopViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRedPackPopViewController.h"
#import "JYRedPacketView.h"
#import "JYPaymentViewController.h"
@interface JYRedPackPopViewController ()

@property (nonatomic,retain) JYRedPacketView *packView;
@property (nonatomic,copy)QBAction payAction;
@property (nonatomic,retain) JYPaymentViewController *paymentVC;
@end

@implementation JYRedPackPopViewController
QBDefineLazyPropertyInitialization(JYPaymentViewController, paymentVC)

- (JYRedPacketView *)packView {
    if (_packView) {
        return _packView;
    }
    _packView = [[JYRedPacketView alloc] init];
    @weakify(self);
    _packView.closeAction = ^(JYRedPacketView *view){
        @strongify(self);
        [self hiddenPackView];
    };
    
    _packView.ktVipAction = ^(id sender){
        @strongify(self);
         QBSafelyCallBlock(self.payAction,self);
        [self presentPayViewController];
         [self hiddenPackView];
    };
    
    _packView.sendPacketAction = ^(id sender){
        @strongify(self);
        [self hiddenPackView];
        QBSafelyCallBlock(self.payAction,self);
        QBBaseModel *baseModel = [[QBBaseModel alloc] init];
        baseModel.realColumnId = @(235345);
        baseModel.channelType = @(1);
        baseModel.programType= @(2);
        baseModel.programId = @(234);
        baseModel.programLocation = @(45);
        [self.paymentVC payForWithBaseModel:baseModel vipLevel:JYVipTypePacket price:500];
    };
    
    return _packView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)popRedPackViewWithCurrentViewCtroller:(UIViewController *)currentViewCtroller payAction:(QBAction)payAction{
        self.payAction = payAction;
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    if (_packView && [currentViewCtroller.view.window.subviews containsObject:_packView]) {
        [self showPopPackViewWithCurrentVc:currentViewCtroller];
        return;
    }
    if (![currentViewCtroller.childViewControllers containsObject:self]) {
        [currentViewCtroller addChildViewController:self];
        self.packView.price = 5;
        self.packView.hidden = NO;
        self.packView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
        [currentViewCtroller.view.window addSubview:self.packView];
    }
  
    [self showPopPackViewWithCurrentVc:currentViewCtroller];
    
}


- (void)showPopPackViewWithCurrentVc:(UIViewController *)currentViewCtroller{
    @weakify(self);
    self.packView.hidden = NO;
      [currentViewCtroller.view.window bringSubviewToFront:self.packView];
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        self.packView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];

}

- (void)hiddenPackView{
    [UIView animateWithDuration:0.5 animations:^{
        _packView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    }completion:^(BOOL finished) {
        _packView.hidden = YES;
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
