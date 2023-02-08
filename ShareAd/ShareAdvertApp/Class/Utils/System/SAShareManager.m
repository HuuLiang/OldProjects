//
//  SAShareManager.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareManager.h"
#import "SAShareContentModel.h"
#import <WXApi.h>
#import <AFNetworking.h>
#import "SAReqManager.h"
#import "SAConfigModel.h"

@interface SAShareManager ()
@property (nonatomic) SAShareContentProgramModel *programModel;
@property (nonatomic) SACompletionHandler handler;
@end

@implementation SAShareManager

+ (instancetype)manager {
    static SAShareManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SAShareManager alloc] init];
    });
    return _manager;
}

- (void)startToShareWithModel:(SAShareContentProgramModel *)programModel {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:programModel.coverImg]
                                                          options:SDWebImageDownloaderLowPriority
                                                         progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        self.programModel = programModel;
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = WXSceneSession;
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = programModel.title;//分享标题
        urlMessage.description = programModel.title;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = programModel.shUrl;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    }];
}

- (void)startToRecruitUrlWoWx {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[SAConfigModel defaultConfig].config.AP_IMG]
                                                          options:SDWebImageDownloaderLowPriority
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = WXSceneSession;
        
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [SAConfigModel defaultConfig].config.AP_TITLE;//分享标题
        urlMessage.description = [SAConfigModel defaultConfig].config.AP_SUBTITLE;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"%@?userId=%@",[SAConfigModel defaultConfig].config.AP_URL,[SAUser user].userId];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    }];
}

- (void)fetchUserInfoWithWx:(SACompletionHandler)handler {
    self.handler = handler;
    
    SendAuthReq *loginReq = [[SendAuthReq alloc] init];
    loginReq.scope = @"snsapi_userinfo";
    loginReq.state = @"123";
    loginReq.openID = @"100";
    [WXApi sendReq:loginReq];
}



- (void)sendAuthRespCode:(SendAuthResp *)resp {
    NSString *tokenUrl = [NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code",SA_WECHAT_TOKEN,SA_WEXIN_APP_ID,SA_WECHAT_SECRET,resp.code];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:tokenUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * tokenDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (tokenDic[@"errcode"] != nil) {
            [[SAHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",tokenDic[@"errcode"],tokenDic[@"errmsg"]]];
        }
        [self getUserInfoWithTokenDic:tokenDic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[SAHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getUserInfoWithTokenDic:(NSDictionary *)tokenDic {
    NSString *userInfoUrl = [NSString stringWithFormat:@"%@access_token=%@&openid=%@&lang=%@",SA_WECHAT_USERINFO,tokenDic[@"access_token"],tokenDic[@"openid"],@"zh_CN"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:userInfoUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * userInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        QBLog(@"responseObject:%@ \n userInfoDic:%@",responseObject,userInfoDic);
        [SAUser user].city = userInfoDic[@"city"];
        [SAUser user].nickName = userInfoDic[@"nickname"];
        [SAUser user].portraitUrl = userInfoDic[@"headimgurl"];
        [SAUser user].sex = [userInfoDic[@"sex"] integerValue] == 1 ? @"男" : @"女";
        [SAUser user].openId = userInfoDic[@"openid"];
        if ([[SAUser user] update]) {
            self.handler(YES, nil);
            return ;
        }
     
        if (userInfoDic[@"errcode"] != nil) {
            [[SAHudManager manager] showHudWithText:[NSString stringWithFormat:@"errcode:%@\nerrmsg:%@",userInfoDic[@"errcode"],userInfoDic[@"errmsg"]]];
            self.handler(NO, nil);
            return;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[SAHudManager manager] showHudWithText:[NSString stringWithFormat:@"%@",error]];
    }];
    
}

- (void)receiveWxResp:(BaseResp *)resp {
    SendMessageToWXResp *msgResp = (SendMessageToWXResp *)resp;
    if (msgResp.errCode == 0 && self.programModel) {
        //分享成功
        [[SAReqManager manager] updateShareBountyWithPrice:self.programModel.shAmount shareId:self.programModel.shareId class:[self class] handler:^(BOOL success, id obj) {
            if (success) {
                [SAUtil fetchAccountInfo];
                [[SAHudManager manager] showHudWithText:@"分享成功"];
            }
            self.programModel = nil;
        }];
    }
}

@end
