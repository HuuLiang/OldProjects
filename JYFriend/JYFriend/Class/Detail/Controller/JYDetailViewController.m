//
//  JYDetailViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailViewController.h"
#import "JYNewDynamicCell.h"
#import "JYHomeTownCell.h"
#import "JYPhotoCollectionViewCell.h"
#import "JYDetailUserInfoCell.h"
#import "JYDetailBottotmView.h"
#import "JYUserDetailModel.h"
#import "JYMyPhotoBigImageView.h"
#import "JYLocalVideoUtils.h"
#import "JYRedPackPopViewController.h"
#import "JYMessageViewController.h"
#import "JYUserCreateMessageModel.h"
#import "JYContactModel.h"
#import "JYCharacterModel.h"
#import <QBPaymentInfo.h>

static NSString *const kPhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCell_Identifier";
static NSString *const kNewDynamicCellIdentifier = @"newDynamicCell_Identifier";
static NSString *const kDetailUserInfoCellIndetifier = @"detailuserInfoCell_indetifier";
static NSString *const kHomeTownCellIdetifier = @"hometownCell_indetifier";
static NSString *const kSectionHeaderIndetifier = @"sectionHeader_indetifier";
static NSString *const kDetailUserInfoCellKtVipIdentifier = @"detail_userinfocell_ktvip_identifier";

static CGFloat const kPhotoItemSpce = 6.;
static CGFloat const kPhotoLineSpace = 10.;


typedef NS_ENUM(NSInteger,JYSectionType) { //动态的根据后台返回的字段来控制显示的内容 ,控制方法在没个代理方法里有写
    //    JYSectionTypePhoto,
    JYSectionTypeHomeTown,
    //    JYSectionTypeDynamic,
    JYSectionTypeInfo,
    JYSectionTypeSectetInfo,
    //    JYSectionTypeVideo,
    JYSectionCount
};

//最新动态
typedef NS_ENUM(NSInteger , JYNewDynamicItem){
    JYNewDynamicItemTitle,
    JYNewDynamicItemDetailTitle,
    //    JYNewDynamicItemImage,
    JYNewDynamicItemTime,
    JYNewDynamicItemCount
} ;

//用户信息
typedef NS_ENUM(NSInteger , JYUserInfoItem) {
    JYUserInfoItemTitle,
    JYUserInfoItemName,
    JYUserInfoItemAge,
    JYUserInfoItemHeigth,
    JYUserInfoItemConstellation,
    JYUserInfoItemSignature,
    JYUserInfoItemCount
};
//详细信息
typedef NS_ENUM(NSInteger , JYSectetInfoItem) {
    JYSectetInfoItemTitle,
    JYSectetInfoItemWechat,
    JYSectetInfoItemQQ,
    JYSectetInfoItemPhone,
    JYSectetInfoItemCount
};

//视频认证
typedef NS_ENUM(NSInteger , JYVideoItem) {
    JYVideoItemTitle,
    JYVideoItemVideo,
    JYVideoItemCount
};

@interface JYDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString            *_userId;
    NSString            *_time;
    NSString            *_distance;
    UICollectionView    *_layoutCollectionView;
}

@property (nonatomic,retain) JYDetailBottotmView *bottomView;//底部视图
@property (nonatomic,retain) JYUserDetailModel *detailModel;
@property (nonatomic,retain) JYSendMessageModel *sendMessageModel;
@property (nonatomic)  BOOL isGreet;//是否打招呼

@property (nonatomic) BOOL isSendPacket;//是否已经给该机器人发送过红包
@property (nonatomic,retain) JYRedPackPopViewController *packePopView;
@end

@implementation JYDetailViewController
QBDefineLazyPropertyInitialization(JYUserDetailModel, detailModel)
QBDefineLazyPropertyInitialization(JYSendMessageModel, sendMessageModel)
QBDefineLazyPropertyInitialization(JYRedPackPopViewController, packePopView)

- (instancetype)initWithUserId:(NSString *)userId time:(NSString *)time distance:(NSString *)distance nickName:(NSString *)nickName
{
    self = [super init];
    if (self) {
        _userId = userId;
        _time   = time;
        _distance = distance;
        self.navigationItem.title = nickName;
    }
    return self;
}

- (JYDetailBottotmView *)bottomView {
    if (_bottomView) {
        return _bottomView;
    }
    _bottomView = [[JYDetailBottotmView alloc] init];
    //    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#E147a5"];
    _bottomView.buttonModels = @[[JYDetailBottomModel creatBottomModelWith:@"关注TA" withImage:@"detail_attention_icon"],
                                 [JYDetailBottomModel creatBottomModelWith:@"发消息" withImage:@"detail_message_icon"],
                                 [JYDetailBottomModel creatBottomModelWith:@"打招呼" withImage:@"detail_greet_icon"]];
    @weakify(self);
    __block JYUserCreateMessageType messageType;
    _bottomView.action = ^(UIButton *btn){
        @strongify(self);
        if ([btn.titleLabel.text isEqualToString:@"关注TA"]) {
            if (btn.selected) {
                return ;
            }else {
                btn.selected = !btn.selected;
            }
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.4),@(0.7),@(1.0),@(1.5)];
            animation.keyTimes = @[@(0.0),@(0.3),@(0.7),@(1.0)];
            animation.calculationMode = kCAAnimationLinear;
            [btn.imageView.layer addAnimation:animation forKey:@"SHOW"];
            
            messageType = JYUserCreateMessageTypeFollow;
            
        }else if ([btn.titleLabel.text isEqualToString:@"发消息"]){
            
            JYUser *user = [[JYUser alloc] init];
            JYUserInfoModel *userInfo =  self.detailModel.userInfo;
            if (userInfo == nil) {
                [[JYHudManager manager] showHudWithText:@"未获取到用户信息，请稍候"];
                return;
            }
            user.userId = userInfo.userId;
            user.nickName = userInfo.nickName;
            user.userImgKey = userInfo.logoUrl;
            [JYMessageViewController showMessageWithUser:user inViewController:self];
            
        }else if ([btn.titleLabel.text isEqualToString:@"打招呼"]){
            messageType = JYUserCreateMessageTypeGreet;
            if (self.isGreet) {
                [[JYHudManager manager] showHudWithText:@"已经向该用户打过招呼"];
                return;
            }
            
        }
        if (![btn.titleLabel.text isEqualToString:@"发消息"]) {
            @weakify(self);
            [self.sendMessageModel fetchRebotReplyMessagesWithRobotId:self.detailModel.userInfo.userId msg:nil ContentType:@"Text" msgType:messageType CompletionHandler:^(BOOL success, id obj) {
                @strongify(self);
                if (success) {
                    if (messageType == JYUserCreateMessageTypeFollow) {
                        [[JYHudManager manager] showHudWithText:@"关注成功"];
                    }else if (messageType == JYUserCreateMessageTypeGreet){
                        self.isGreet = YES;
                        [[JYHudManager manager] showHudWithText:@"打招呼成功"];
                        //先向消息列表中加入选中的机器人的打招呼语言
                        JYCharacter *character = [[JYCharacter alloc] init];
                        character.nickName = self.detailModel.userInfo.nickName;
                        character.logoUrl = self.detailModel.userInfo.logoUrl;
                        character.userId = self.detailModel.userInfo.userId;
                        [JYContactModel insertGreetContact:@[character]];
                    }
                }
            }];
        }
        
    };
    
    [self.view addSubview:_bottomView];
    {
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(kWidth(88));
        }];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    [_layoutCollectionView registerClass:[JYPhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier];
    [_layoutCollectionView registerClass:[JYNewDynamicCell class] forCellWithReuseIdentifier:kNewDynamicCellIdentifier];
    [_layoutCollectionView registerClass:[JYDetailUserInfoCell class] forCellWithReuseIdentifier:kDetailUserInfoCellIndetifier];
    [_layoutCollectionView registerClass:[JYHomeTownCell class] forCellWithReuseIdentifier:kHomeTownCellIdetifier];
    [_layoutCollectionView registerClass:[JYDetailUserInfoCell class] forCellWithReuseIdentifier:kDetailUserInfoCellKtVipIdentifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderIndetifier];
    
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(0, 0, kWidth(88.), 0);
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
//    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#E147a5"];
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadModels];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(payResultSuccess:) name:kPaidNotificationName object:nil];
    
}
/**
 支付完成刷新UI
 */
- (void)payResultSuccess:(NSNotification *)notifation {
    self.isSendPacket = YES;
    [_layoutCollectionView reloadData];
    QBPaymentInfo *paymentInfo = notifation.object;
    if (paymentInfo.payPointType == 3) {
        [JYUtil saveSendPacketUserId:self.detailModel.userInfo.userId];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

/**
 加载模型
 */
- (void)loadModels {
    @weakify(self);
    [self.detailModel fetchUserDetailModelWithViewUserId:self->_userId CompleteHandler:^(BOOL success, JYUserDetail *useDetai) {
        if (success) {
            @strongify(self);
            self.isSendPacket = [JYUtil isSendPacketWithUserId:useDetai.user.userId];
            [self->_layoutCollectionView reloadData];
            [self->_layoutCollectionView JY_endPullToRefresh];
//            _bottomView.attentionBtnSelect = useDetai.follow;
            self.isGreet = useDetai.greet;
            self.navigationItem.title  = useDetai.user.nickName;
            [self loadBottomViewWithIsFollow:useDetai.follow];
        }
    }];
    
}

- (void)loadBottomViewWithIsFollow:(BOOL)isFollow{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#E147a5"];
            self.bottomView.attentionBtnSelect = isFollow;
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.detailModel.userInfo) {
        return 0;
    }
    NSInteger count = JYSectionCount;
    if (self.detailModel.userPhoto.count >0) {
        count += 1;
    }
    if (self.detailModel.userVideo.videoUrl) {
        count += 1;
    }
    return count ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger hasPhoto = 0; //默认没有图片,如果self.detailModel.userPhoto.count > 0 hasPhoto = 1
    NSUInteger hasVideo = 0; //同上视频
    NSUInteger hasDynamic = 0;//最新动态同上
    NSInteger photoSection = NSNotFound; //如果self.detailModel.userPhoto.count > 0 就是有图片这时候图片的photoSection 会赋值为0
    NSInteger dynamicHasImage = 0;//如果最新动态里面配有图片,则会对dynamicHasImage 赋值为1;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
        if (self.detailModel.mood.moodUrl.count > 0) {
            dynamicHasImage = 1;
        }
    }
    
    if (section == photoSection) {
        return self.detailModel.userPhoto.count;
    }else if (section == JYSectionTypeHomeTown + hasPhoto){
        return 1;
    }else if (section == JYSectionTypeHomeTown + + hasPhoto + hasDynamic){
        return JYNewDynamicItemCount + dynamicHasImage;
    }else if (section == JYSectionTypeInfo + hasPhoto + hasDynamic){
        return JYUserInfoItemCount;
    }else if (section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic){
        return JYSectetInfoItemCount;
    }else if (section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic + hasVideo){
        return JYVideoItemCount;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger hasPhoto = 0; //默认没有图片,如果self.detailModel.userPhoto.count > 0 hasPhoto = 1
    NSUInteger hasVideo = 0; //同上视频
    NSUInteger hasDynamic = 0;//最新动态同上
    NSInteger photoSection = NSNotFound; //如果self.detailModel.userPhoto.count > 0 就是有图片这时候图片的photoSection 会赋值为0
    NSInteger dynamicHasImage = 0;//如果最新动态里面配有图片,则会对dynamicHasImage 赋值为1;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
        if (self.detailModel.mood.moodUrl.count > 0) {
            dynamicHasImage = 1;
        }
    }
    
    
    
    if (indexPath.section == photoSection) {
        JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
//        if (!self.isSendPacket) {
//            if (indexPath.item == 0 ) {
//                cell.isFirstPhoto = YES;
//            }else {
//                cell.isFirstPhoto = NO;
//            }
//        }
        if (indexPath.item == 0) {
          [cell setImageUrl:self.detailModel.userPhoto[indexPath.item].smallPhoto isFirstPhoto:YES isSendPacket:self.isSendPacket];
        }else {
        [cell setImageUrl:self.detailModel.userPhoto[indexPath.item].smallPhoto isFirstPhoto:NO isSendPacket:self.isSendPacket];
        }
       
        cell.isVideoImage = NO;
        return cell;
    }else if (indexPath.section == JYSectionTypeHomeTown + hasPhoto){
        JYHomeTownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeTownCellIdetifier forIndexPath:indexPath];
        cell.gender = [self.detailModel.userInfo.sex isEqualToString:@"F"] ? JYUserSexFemale : JYUserSexMale;
        cell.age = self.detailModel.userInfo.age.integerValue;
        cell.height = self.detailModel.userInfo.height.integerValue;
        cell.distance = self->_distance;//距离
        cell.vip = self.detailModel.userInfo.isVip.integerValue;
        cell.time = [JYLocalVideoUtils fetchTimeIntervalToCurrentTimeWithStartTime:self->_time];
        NSString *home = [NSString stringWithFormat:@"%@%@",self.detailModel.userInfo.province,self.detailModel.userInfo.city];
        if (self.detailModel.userInfo.province.length == 0 && self.detailModel.userInfo.city.length == 0) {
            home = @"未填写";
        }
        cell.homeTown = [NSString stringWithFormat:@"%@",home];
        return cell;
        
    } else if (indexPath.section == JYSectionTypeHomeTown + hasPhoto + hasDynamic){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        cell.title = nil;
        cell.detailTitle = nil;
        cell.vipTitle = nil;
        if (indexPath.item == JYNewDynamicItemTitle) {
            cell.title = @"最新动态";
            return cell;
        }else if (indexPath.item == JYNewDynamicItemDetailTitle){
            cell.detailTitle = self.detailModel.mood.text;
            return cell;
        }else if (indexPath.item == JYNewDynamicItemTime + dynamicHasImage){
            
            cell.detailTitle = self->_time ;
            return cell;
        }else if(indexPath.item == JYNewDynamicItemDetailTitle +dynamicHasImage ){
            
            JYNewDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewDynamicCellIdentifier forIndexPath:indexPath];
            cell.detaiMoods = self.detailModel.mood.moodUrl;
            cell.action = ^(NSInteger index){
                [self photoBrowseWithImageGroup:[self dynamicImageGroupWithDyImageModels:self.detailModel.mood.moodUrl] currentIndex:index isNeedBlur:NO];
                
            };
            return cell;
        }
        
    }else if (indexPath.section == JYSectionTypeInfo + hasPhoto + hasDynamic){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        cell.title = nil;
        cell.detailTitle = nil;
        cell.vipTitle = nil;
        if (indexPath.item == JYUserInfoItemTitle) {
            cell.title = @"个人信息";
            //             cell.detailTitle = nil;
            return cell;
        }else if (indexPath.item == JYUserInfoItemName){
            cell.detailTitle = [NSString stringWithFormat:@"昵       称:  %@",self.detailModel.userInfo.nickName];//;
            return cell;
        }else if (indexPath.item == JYUserInfoItemAge){
            cell.detailTitle = [NSString stringWithFormat:@"年       龄:  %@",self.detailModel.userInfo.age];
            return cell;
        }else if (indexPath.item == JYUserInfoItemHeigth){
            cell.detailTitle = [NSString stringWithFormat:@"身       高:  %@",self.detailModel.userInfo.height];
            return cell;
        }else if (indexPath.item == JYUserInfoItemConstellation){
            cell.detailTitle = [NSString stringWithFormat:@"星       座:  %@",self.detailModel.userInfo.starSign];
            return cell;
        }else if (indexPath.item == JYUserInfoItemSignature){
            cell.detailTitle = [NSString stringWithFormat:@"个性签名:  %@",self.detailModel.userInfo.note];
            return cell;
        }
        
    } else if (indexPath.section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        cell.title = nil;
        cell.detailTitle = nil;
        cell.vipTitle = nil;
        if (indexPath.item == JYSectetInfoItemTitle) {
            JYDetailUserInfoCell *vipCell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellKtVipIdentifier forIndexPath:indexPath];
            vipCell.title = @"私密资料";
            //             cell.detailTitle = nil;
            //            [cell.vipBtn setTitle:@"成为VIP会员" forState:UIControlStateNormal];
            vipCell.vipTitle = [JYUtil isVip] ? @"续费VIP会员" : @"成为VIP会员";
            @weakify(self);
            vipCell.vipAction = ^(id sender){
                @strongify(self);
                [self presentPayViewController];
            };
            return vipCell;
        }else if (indexPath.item == JYSectetInfoItemWechat){
            
            cell.detailTitle = [NSString stringWithFormat:@"微   信: %@", [JYUtil isVip] ? self.detailModel.userInfo.weixinNum : @"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemQQ){
            cell.detailTitle = [NSString stringWithFormat:@"Q    Q: %@",[JYUtil isVip] ? self.detailModel.userInfo.qq : @"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemPhone){
            cell.detailTitle = [NSString stringWithFormat:@"手机号: %@",[JYUtil isVip] ? self.detailModel.userInfo.phone : @"仅限VIP会员查看"];
            return cell;
        }
        
    }else if (indexPath.section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic + hasVideo){
        if (indexPath.item == JYVideoItemTitle) {
            JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
            cell.title = @"TA的视频认证";
            cell.detailTitle = nil;
            cell.vipTitle = nil;
            return cell;
        }else if (indexPath.item == JYVideoItemVideo){
            JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = self.detailModel.userVideo.imgCover;//@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg";
            cell.isVideoImage = YES;
            return cell;
        }
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger hasPhoto = 0;
    NSUInteger hasVideo = 0;
    NSUInteger hasDynamic = 0;
    NSInteger photoSection = NSNotFound;
    NSInteger dynamicHasImage = 0;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
        if (self.detailModel.mood.moodUrl.count > 0) {
            dynamicHasImage = 1;
        }
    }
    
    if (indexPath.section == photoSection) {
        CGFloat width = (kScreenWidth - kPhotoItemSpce*2 - 15*2. )/3.;
        return CGSizeMake(width, width);
    }else if (indexPath.section == JYSectionTypeHomeTown + hasPhoto){
        return CGSizeMake(kScreenWidth, kWidth(150));
        
    } else if (indexPath.section == JYSectionTypeHomeTown + hasPhoto + hasDynamic){
        if (indexPath.item == JYNewDynamicItemTitle) {
            return CGSizeMake(kScreenWidth, kWidth(90.));
        }else if (indexPath.item == JYNewDynamicItemDetailTitle ){
            CGSize size = [self.detailModel.mood.text sizeWithFont:[UIFont systemFontOfSize:kWidth(28.)] maxWidth:(kScreenWidth - kWidth(60))];
            return CGSizeMake(kScreenWidth, size.height +kWidth(20));
        }else if (indexPath.item == JYNewDynamicItemTime + dynamicHasImage){
            return CGSizeMake(kScreenWidth, kWidth(45.));
        }else if(indexPath.item == JYNewDynamicItemDetailTitle + dynamicHasImage){
            return CGSizeMake(kScreenWidth, kWidth(140));
        }
        
    }else if (indexPath.section == JYSectionTypeInfo + hasPhoto + hasDynamic|| indexPath.section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic){
        if (indexPath.item == JYUserInfoItemTitle || indexPath.item == JYSectetInfoItemTitle) {
            return CGSizeMake(kScreenWidth, kWidth(90.));
        }else if (indexPath.item == JYUserInfoItemSignature){
            CGSize size = [[NSString stringWithFormat:@"个性签名:  %@",self.detailModel.userInfo.note] sizeWithFont:[UIFont systemFontOfSize:kWidth(28)] maxWidth:(kScreenWidth - kWidth(60))];//根据签名长短来确定行数
            return CGSizeMake(kScreenWidth, size.height +kWidth(20));
        }
        return CGSizeMake(kScreenWidth, kWidth(55.));
    } else if (indexPath.section == JYSectionTypeSectetInfo + hasPhoto + hasDynamic +hasVideo){
        if (indexPath.item == JYVideoItemTitle) {
            return CGSizeMake(kScreenWidth, kWidth(90.));
        }else if (indexPath.item == JYVideoItemVideo){
            return CGSizeMake(kScreenWidth *0.92, kWidth(0.74 *kScreenWidth));
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    NSUInteger hasPhoto = 0;
    NSUInteger hasVideo = 0;
    NSUInteger hasDynamic = 0;
    NSInteger photoSection = NSNotFound;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
    }
    
    if (section == photoSection) {
        return kWidth(kPhotoLineSpace *2);
    }
//    else if (section == JYSectionTypeHomeTown + hasPhoto + hasDynamic){
//        return kWidth(kPhotoLineSpace );
//    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    NSUInteger hasPhoto = 0;
    NSUInteger hasVideo = 0;
    NSUInteger hasDynamic = 0;
    NSInteger photoSection = NSNotFound;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
    }
    
    if (section == photoSection) {
        return kPhotoItemSpce;
    }else if (section == JYSectionTypeHomeTown + hasPhoto + hasDynamic){
        return kWidth(kPhotoItemSpce);
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSUInteger hasPhoto = 0;
    NSUInteger hasVideo = 0;
    NSUInteger hasDynamic = 0;
    NSInteger photoSection = NSNotFound;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
    }
    if (section == photoSection) {
        return  UIEdgeInsetsMake(kWidth(20.), 15., kWidth(10.), 15.);
    }else if (section == JYSectionTypeSectetInfo + hasPhoto + hasVideo){
        return UIEdgeInsetsMake(0, 0, kWidth(20), 0);
    }
    return UIEdgeInsetsZero; }

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(20.));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderIndetifier forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger hasPhoto = 0;
    NSUInteger hasVideo = 0;
    NSUInteger hasDynamic = 0;
    NSInteger photoSection = NSNotFound;
    NSInteger dynamicHasImage = 0;
    if (self.detailModel.userPhoto.count > 0) {
        hasPhoto = 1;
        photoSection = 0;
    }
    if (self.detailModel.userVideo.videoUrl) {
        hasVideo = 1;
    }
    if (self.detailModel.mood) {
        hasDynamic = 1;
        if (self.detailModel.mood.moodUrl.count > 0) {
            dynamicHasImage = 1;
        }
    }
    
    if (indexPath.section == photoSection) {
        
        if (![JYUtil isVip] || !self.isSendPacket) {
            if (indexPath.item == 0) {
                [self photoBrowseWithImageGroup:[self photoImageGroupWithUserPhotosModel:self.detailModel.userPhoto] currentIndex:indexPath.item isNeedBlur:YES];
            }else {
                if (self.isSendPacket || [JYUtil isVip]) {
                    [self photoBrowseWithImageGroup:[self photoImageGroupWithUserPhotosModel:self.detailModel.userPhoto] currentIndex:indexPath.item isNeedBlur:YES];
                }else{
                    [self.packePopView popRedPackViewWithCurrentViewCtroller:self payAction:nil];
                }
            }
            
        }else {
            [self photoBrowseWithImageGroup:[self photoImageGroupWithUserPhotosModel:self.detailModel.userPhoto] currentIndex:indexPath.item isNeedBlur:NO];
        }
    }else if (indexPath.section == JYSectionTypeSectetInfo + hasPhoto + hasVideo) {
        //播放视频
        if ([JYUtil isVip] || self.isSendPacket) {
            [self playerVCWithVideo:self.detailModel.userVideo.videoUrl];
        }else {
            [self presentPayViewController];
        }
    }
}
/**
 用户相册的图片数组
 */
- (NSArray *)photoImageGroupWithUserPhotosModel:(NSArray <JYUserPhoto *>*)photoModels {
    NSMutableArray *arrM = [NSMutableArray array];
    [photoModels enumerateObjectsUsingBlock:^(JYUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrM addObject:obj.bigPhoto];
    }];
    return arrM.copy;
}

/**
 用户动态的图片数组
 */

- (NSArray *)dynamicImageGroupWithDyImageModels:(NSArray <JYUserDetailMood *>*)imageModels {
    NSMutableArray *arrM = [NSMutableArray array];
    [imageModels enumerateObjectsUsingBlock:^(JYUserDetailMood * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrM addObject:obj.url];
    }];
    return arrM.copy;
}

/**
 图片浏览器
 */
- (void)photoBrowseWithImageGroup:(NSArray *)imageGroup currentIndex:(NSInteger)currentIndex isNeedBlur:(BOOL)isNeedBlur{
    JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:imageGroup frame:self.view.window.frame isLocalImage:NO isNeedBlur:isNeedBlur userId:self.detailModel.userInfo.userId];
    bigImageView.backgroundColor = [UIColor whiteColor];
    bigImageView.shouldAutoScroll = NO;
    bigImageView.shouldInfiniteScroll = NO;
    bigImageView.pageControlYAspect = 0.8;
    bigImageView.currentIndex = currentIndex;
    
    @weakify(self);
    bigImageView.action = ^(JYMyPhotoBigImageView *bigImageView ){
        @strongify(self);
        [self bigImageHiddenWithBigImage:bigImageView];
    };
    bigImageView.scrollAction = ^(JYMyPhotoBigImageView *bigImageView ,NSNumber *index){
        @strongify(self);
        if (index.integerValue >= 1 && isNeedBlur && ![JYUtil isVip] && !self.isSendPacket) {
        [self.packePopView popRedPackViewWithCurrentViewCtroller:self payAction:^(id obj) {
            [self bigImageHiddenWithBigImage:bigImageView];
        }];
        }
    };
    
    [self.view.window addSubview:bigImageView];
    bigImageView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        bigImageView.alpha = 1;
    }];
}

- (void)bigImageHiddenWithBigImage:(JYMyPhotoBigImageView *)bigImageView{
    [UIView animateWithDuration:0.5 animations:^{
        bigImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [bigImageView removeFromSuperview];
    }];
}

@end
