//
//  YFBAskGiftManager.m
//  YFBFriend
//
//  Created by Liang on 2017/4/21.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBAskGiftManager.h"
#import "YFBGiftPopViewController.h"
#import "YFBContactManager.h"
#import "YFBGiftManager.h"
#import "YFBInteractionManager.h"
#import "YFBMessagePayPopController.h"

@implementation YFBAskGiftManager

+ (instancetype)manager {
    static YFBAskGiftManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YFBAskGiftManager alloc] init];
    });
    return _manager;
}

- (void)popAskGiftView:(UIViewController *)viewController {
    NSArray *dataSource = [[YFBContactManager manager] loadAllContactInfo];
    YFBContactModel *contactInfo;
    if (dataSource.count == 0) {
        [self performSelector:@selector(popAskGiftView:) withObject:viewController afterDelay:300];
        return;
    } else {
        contactInfo = [dataSource firstObject];
        if (!contactInfo || contactInfo.userId.length == 0 || !contactInfo.userId) {
            [self performSelector:@selector(popAskGiftView:) withObject:viewController afterDelay:300];
            return;
        }
    }
    
    YFBGiftPopViewController *popVC = [[YFBGiftPopViewController alloc] init];
    popVC.contactInfo = contactInfo;
    [popVC showGiftViewWithType:YFBGiftPopViewTypeBlag InCurrentViewController:viewController];
    popVC.sendGiftAction = ^(YFBGiftInfo * giftInfo) {
        if (giftInfo.diamondCount <= [YFBUser currentUser].diamondCount) {
            [[YFBInteractionManager manager] sendMessageInfoToUserId:contactInfo.userId content:giftInfo.giftId type:YFBMessageTypeGift deductDiamonds:-giftInfo.diamondCount handler:^(BOOL success) {
                if (success) {
                    //刷新上部功能菜单里的钻石数量 即礼物赠送界面的钻石数量
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateMessageDiamondCountNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kYFBUpdateGiftDiamondCountNotification object:nil];
                    
                    [[YFBHudManager manager] showHudWithText:@"礼物赠送成功"];
                }
            }];
        } else {
            [YFBMessagePayPopController showMessageTopUpPopViewWithType:YFBMessagePopViewTypeDiamond onCurrentVC:viewController];
        }
    };
}

- (void)startAutoBlagActionInViewController:(UIViewController *)viewController {
    [self performSelector:@selector(popAskGiftView:) withObject:viewController afterDelay:300];
}

@end
