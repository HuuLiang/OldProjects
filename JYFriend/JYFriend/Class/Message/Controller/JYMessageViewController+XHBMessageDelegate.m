//
//  JYMessageViewController+XHBMessageDelegate.m
//  JYFriend
//
//  Created by Liang on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController+XHBMessageDelegate.h"
#import "JYMessageModel.h"
#import "XHAudioPlayerHelper.h"
#import "JYLocalPhotoUtils.h"
#import "JYUserImageCache.h"
#import "JYVideoChatViewController.h"
#import "JYMessageNoticeCell.h"
#import "JYPaymentViewController.h"
#import "JYNavigationController.h"
#import "JYMyPhotoBigImageView.h"


static NSString *const kJYFriendMessageNoticeCellKeyName    = @"kJYFriendMessageNoticeCellKeyName";
//static NSString *const kJYFriendMessageVipCellKeyName       = @"kJYFriendMessageVipCellKeyName";


@interface JYMessageViewController () <JYLocalPhotoUtilsDelegate>

@end

@implementation JYMessageViewController (XHBMessageDelegate)

//配置gif
- (void)configEmotions {
    NSMutableArray *emotionManagers = [NSMutableArray array];
//    for (NSInteger i = 0; i < 10; i ++) {
//        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
//        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSInteger j = 0; j < 55; j ++) {
//            XHEmotion *emotion = [[XHEmotion alloc] init];
//            NSString *imageName = [NSString stringWithFormat:@"e%ld.gif", (long)j + 100];
//            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"e%ld", (long)j+100] ofType:@"gif"];
//            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
//            [emotions addObject:emotion];
//        }
//        emotionManager.emotions = emotions;
//        
//        [emotionManagers addObject:emotionManager];
//    }
    //加载小黄脸
//    XHEmotionManager *smallEmotionManager = [[XHEmotionManager alloc] init];
//    smallEmotionManager.emotionName = @"小黄脸";
//    NSMutableArray *smallemotions = [NSMutableArray array];
//    for (NSInteger j = 1; j <= 36; j ++) {
//        XHEmotion *emotion = [[XHEmotion alloc] init];
//        NSString *imageName = [NSString stringWithFormat:@"emoji_%ld.png", (long)j];
//        emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emoji_%ld", (long)j] ofType:@"png"];
//        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
//        [smallemotions addObject:emotion];
//    }
//    smallEmotionManager.emotions = smallemotions;
//    [emotionManagers addObject:smallEmotionManager];
    
    //加载大黄脸
    XHEmotionManager *bigEmotionManager = [[XHEmotionManager alloc] init];
    bigEmotionManager.emotionName = @"大黄脸";
    NSMutableArray *bigEmotions = [NSMutableArray array];
    for (NSInteger j = 0; j < 55; j ++) {
        XHEmotion *emotion = [[XHEmotion alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"e%ld.gif", (long)j + 100];
        emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"e%ld", (long)j+100] ofType:@"gif"];
        emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
        [bigEmotions addObject:emotion];
    }
    bigEmotionManager.emotions = bigEmotions;
    [emotionManagers addObject:bigEmotionManager];

    
    self.emotionManagers = emotionManagers;
    self.emotionManagerView.isShowEmotionStoreButton = NO;
    
    [self.emotionManagerView reloadData];
}

/**
 点击加号里面
 */
- (void)setXHShareMenu{
    
    XHShareMenuItem *pictureItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"message_photo"] title:@"图片" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    
    XHShareMenuItem *photographItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"message_camera"] title:@"拍照" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    XHShareMenuItem *videoChatItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"message_video_chat"] title:@"视频聊天" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    self.shareMenuItems = @[pictureItem,photographItem,videoChatItem];
}

- (void)setupPopMenuTitles {
    [[XHConfigurationHelper appearance] setupPopMenuTitles:@[@"复制",@"删除"]];
}

- (void)registerCustomCell {
    [self.messageTableView registerClass:[JYMessageNoticeCell class] forCellReuseIdentifier:kJYFriendMessageNoticeCellKeyName];
}

#pragma mark - XHMessageTableViewControllerDelegate

//发送文本
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addTextMessage:text withSender:sender receiver:self.user.userId dateTime:[JYUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
    [self scrollToBottomAnimated:YES];
}

//发送图片
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSString *imagekey = nil;
    if (photo) {
        imagekey = [JYUserImageCache writeToFileWithImage:photo needSaveImageName:NO];
    }
    [self addPhotoMessage:imagekey thumbnailUrl:nil originPhotoUrl:nil withSender:sender receiver:self.user.userId dateTime:[JYUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}

//发送语音
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    if ([voiceDuration floatValue] < 1) {
        [[JYHudManager manager] showHudWithText:@"语音时常太短啦"];
        return;
    }
    [self addVoiceMessage:voicePath voiceDuration:voiceDuration withSender:sender receiver:self.user.userId dateTime:[JYUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

//发送表情
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addEmotionMessage:emotionPath WithSender:sender receiver:self.user.userId dateTime:[JYUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

//是否显示时间轴
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHMessage *previousMessage = indexPath.row > 0 ? self.messages[indexPath.row-1] : nil;
    if (previousMessage) {
        XHMessage *currentMessage = self.messages[indexPath.row];
        if ([currentMessage.timestamp isEqualToDateIgnoringSecond:previousMessage.timestamp]) {
            return NO;
        }
    }
    return YES;
}

//配置cell样式
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *message = self.messages[indexPath.row];
    
    BOOL isCurrentUser = [message.sender isEqualToString:[JYUser currentUser].userId];
    if (isCurrentUser) {
        [cell.avatarButton setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JYUser currentUser].userImgKey] forState:UIControlStateNormal];
    } else {
        [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.user.userImgKey] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_default_avatar"]];;
    }
}

//配置自定义cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    return kWidth(90)+20;
}

//配置自定义cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    message = (XHMessage *)message;
    JYMessageNoticeCell *cell;
    if (message.messageMediaType == XHBubbleMessageMediaTypeCustomNormal || message.messageMediaType == XHBubbleMessageMediaTypeCustomVIP) {
        cell = (JYMessageNoticeCell *)[tableView dequeueReusableCellWithIdentifier:kJYFriendMessageNoticeCellKeyName forIndexPath:indexPath];
        cell.title = message.text;
//        @weakify(self);
        cell.payAction = ^(id sender) {
//            @strongify(self);
            if (message.messageMediaType == XHBubbleMessageMediaTypeCustomNormal) {
                JYPaymentViewController *payVC = [[JYPaymentViewController alloc] init];
                JYNavigationController *payNav = [[JYNavigationController alloc] initWithRootViewController:payVC];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:payNav animated:YES completion:nil];
            }
        };
    }
    return cell;
}

#pragma mark - XHMessageTableViewCellDelegate

/**
 *  点击多媒体消息的时候统一触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 *  @param messageTableViewCell 目标消息在该Cell上
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    if (message.messageMediaType == XHBubbleMessageMediaTypePhoto) {
        //图片浏览
        if (message.photo) {
            [self photoBrowseWithImageGroup:@[message.photo] currentIndex:0 isNeedBlur:NO isLocalImage:YES];
        } else {
            [self photoBrowseWithImageGroup:@[message.originPhotoUrl] currentIndex:0 isNeedBlur:NO isLocalImage:NO];
        }
    } else if (message.messageMediaType == XHBubbleMessageMediaTypeVoice) {
        message.isRead = YES;
        messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
        
        [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
        if (self.currentSelectedCell) {
            [self.currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
        }
        if (self.currentSelectedCell == messageTableViewCell) {
            [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
            [[XHAudioPlayerHelper shareInstance] stopAudio];
            self.currentSelectedCell = nil;
        } else {
            self.currentSelectedCell = messageTableViewCell;
            [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
            [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
        }
        
    }
}

//图片浏览
- (void)photoBrowseWithImageGroup:(NSArray *)imageGroup currentIndex:(NSInteger)currentIndex isNeedBlur:(BOOL)isNeedBlur isLocalImage:(BOOL)isLocalImage {
    JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:imageGroup frame:self.view.window.frame isLocalImage:isLocalImage isNeedBlur:isNeedBlur userId:nil];
    bigImageView.backgroundColor = [UIColor whiteColor];
    bigImageView.shouldAutoScroll = NO;
    bigImageView.shouldInfiniteScroll = NO;
    bigImageView.pageControlYAspect = 0.8;
    bigImageView.currentIndex = currentIndex;
    
    @weakify(bigImageView);
    bigImageView.action = ^(id sender){
        @strongify(bigImageView);
        [UIView animateWithDuration:0.5 animations:^{
            bigImageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [bigImageView removeFromSuperview];
        }];
    };
    [self.view.window addSubview:bigImageView];
    bigImageView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        bigImageView.alpha = 1;
    }];
}


#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (self.currentSelectedCell) {
        return;
    }
    [self.currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

/**
 *  双击文本消息，触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    //    XHMessage *message = self.messages[indexPath.row];
    
}

/**
 *  点击消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didSelectedAvatarOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isCurrentUser = [message.sender isEqualToString:[JYUser currentUser].userId];
    
    if (isCurrentUser) {
        
    } else {
        
    }
}

/**
 *  Menu Control Selected Item
 *
 *  @param bubbleMessageMenuSelecteType 点击item后，确定点击类型
 */
- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType atIndexPath:(NSIndexPath *)indexPath {
    if (bubbleMessageMenuSelecteType == XHBubbleMessageMenuSelecteTypeDelete) {
        [self deleteMessageAtIndexPath:indexPath];
    }
}

#pragma mark - XHMessageInputViewDelegate


#pragma mark - XHShareMenuViewDelegate
/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    if ([JYUtil isVip]) {
        [JYLocalPhotoUtils shareManager].delegate = self;
        if (index == 0) {
            [[JYLocalPhotoUtils shareManager] getImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary inViewController:self popoverPoint:CGPointZero isVideo:NO allowsEditing:YES];
        }else if (index == 1){
            [[JYLocalPhotoUtils shareManager] getImageWithSourceType:UIImagePickerControllerSourceTypeCamera inViewController:self popoverPoint:CGPointZero isVideo:NO allowsEditing:YES];
        }else if (index == 2){
            JYVideoChatViewController *chatvVC = [[JYVideoChatViewController alloc] init];
            [self presentViewController:chatvVC animated:YES completion:nil];
        }
    } else {
        JYMessageModel *messageModel = [[JYMessageModel alloc] init];
        [self addChatMessage:messageModel];
    }
}

#pragma mark - XHEmotionManagerViewDelegate,XHEmotionManagerViewDataSource

/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    [self didSendEmotion:emotion.emotionPath fromSender:[JYUser currentUser].userId onDate:[NSDate date]];
//    UIImage *image = [UIImage imageWithContentsOfFile:emotion.emotionPath];
//    [self didSendPhoto:image fromSender:[JYUser currentUser].userId onDate:[NSDate date]];
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

#pragma mark - JYLocalPhotoUtilsDelegate

- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self didSendPhoto:image fromSender:[JYUser currentUser].userId onDate:[NSDate date]];
}


@end
