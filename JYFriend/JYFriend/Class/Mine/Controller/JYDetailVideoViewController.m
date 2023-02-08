//
//  JYDetailVideoViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/30.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailVideoViewController.h"
#import "JYLocalPhotoUtils.h"
#import "JYLocalVideoUtils.h"

static NSString *const kVideoImageCacheKey = @"kvideoimage_cache_key";
static NSString *const kLastUpdateVideoTiem = @"klastupdate_video_time";//上传时间
static NSInteger const kUploadTiem = 30;//视频审核时间以分钟计

@interface JYDetailVideoViewController ()<JYLocalPhotoUtilsDelegate>

@property (nonatomic,retain) UIView *RZvideoView;//视频认证
@property (nonatomic,retain) UIView *holdRZVideoView;//待认证
@property (nonatomic,retain) UIImageView *holdImageView;//图片
@property (nonatomic,retain) UIView *successVideoView;//认证通过的视频
@property (nonatomic) CGPoint currentCellPoint;

@end

@implementation JYDetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频认证";
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kVideoImageCacheKey];
    NSInteger updateTime = [JYLocalVideoUtils dateTimeDifferenceWithStartTime:[[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateVideoTiem] endTime:[JYLocalVideoUtils currentTime]];
    
    if (image) {
        if (updateTime >= kUploadTiem *60) {
            self.successVideoView.alpha = 1;
        }else{
            self.holdRZVideoView.alpha = 1;
        }
    } else{
      self.RZvideoView.alpha = 1;

    }
    
}

- (void)creatRightBarButtonItem {
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"删除" style:UIBarButtonItemStyleDone handler:^(id sender) {
      
        [UIAlertView bk_showAlertViewWithTitle:@"是否删除当前的视频" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"删除"]  handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            @strongify(self);
            if (buttonIndex == 1) {
                [[SDImageCache sharedImageCache] removeImageForKey:kVideoImageCacheKey fromDisk:YES];
                   self.RZvideoView.alpha = 1;
                if (self->_successVideoView) {
                    self->_successVideoView.hidden = YES;
                    [self->_successVideoView removeFromSuperview];
                }
                if (self->_holdRZVideoView) {
                    self->_holdRZVideoView.hidden = YES;
                    [self->_holdRZVideoView removeFromSuperview];
                }
                [self removeRightBarButtonItem];
            }
        }];
    }];
}

- (void)removeRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = nil;
}

- (UIView *)successVideoView {
    if (_successVideoView) {
        return _successVideoView;
    }
    if (_holdRZVideoView) {
        _holdRZVideoView.hidden = YES;
        [_holdRZVideoView removeFromSuperview];
    }
    _successVideoView = [[UIView alloc] init];
    _successVideoView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_successVideoView];
    {
        [_successVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"您的视频已经通过审核并且显示在您的资料内.";
    [_successVideoView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_successVideoView).mas_offset(kWidth(160.));
            make.right.mas_equalTo(_successVideoView).mas_offset(kWidth(-160));
            make.top.mas_equalTo(_successVideoView).mas_offset(kWidth(80));
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kVideoImageCacheKey];
    imageView.image = image ? : [UIImage imageNamed:@"mine_photo_add"];
    [_successVideoView addSubview:imageView];
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(64));
            make.left.mas_equalTo(_successVideoView).mas_offset(kWidth(160.));
            make.right.mas_equalTo(_successVideoView).mas_offset(kWidth(-160));
            make.height.mas_equalTo(imageView.mas_width).multipliedBy(0.6);
        }];
    }
    UIImageView *playImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
    [imageView addSubview:playImage];
    {
    [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(80)));
    }];
    }
//    imageView.userInteractionEnabled = YES;
//    @weakify(self);
//    [imageView bk_whenTapped:^{
//        @strongify(self);
//       [self presentViewController:[self playerVCWithVideo:[JYLocalVideoUtils getJYLocalVideoPathModelUserLocalVideoPath]] animated:YES completion:nil];
//    }];
    [self creatRightBarButtonItem];
    return _successVideoView;
}

- (UIView *)RZvideoView {
    if (_RZvideoView) {
        return _RZvideoView;
    }
    _RZvideoView = [[UIView alloc] init];
    _RZvideoView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_RZvideoView];
    {
    [_RZvideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"点击添加认证视频,认证的视频需要经系统审核.";
    [_RZvideoView addSubview:titleLabel];
    {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RZvideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_RZvideoView).mas_offset(kWidth(-160));
        make.top.mas_equalTo(_RZvideoView).mas_offset(kWidth(80));
    }];
    }

    UIButton *rzImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rzImageBtn setBackgroundImage:[UIImage imageNamed:@"mine_rz_video_icon"] forState:UIControlStateNormal];
    [_RZvideoView addSubview:rzImageBtn];
//    @weakify(self);
    [rzImageBtn bk_addEventHandler:^(id sender) {
        [JYLocalPhotoUtils shareManager].delegate = self;
        [[JYLocalPhotoUtils shareManager] getImageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum inViewController:self popoverPoint:self.currentCellPoint isVideo:YES allowsEditing:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    {
    [rzImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(64));
        make.left.mas_equalTo(_RZvideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_RZvideoView).mas_offset(kWidth(-160));
        make.height.mas_equalTo(rzImageBtn.mas_width).multipliedBy(0.6);
    }];
    }
    
    return _RZvideoView;
}

- (UIView *)holdRZVideoView {
    if (_holdRZVideoView) {
        return _holdRZVideoView;
    }
    if (_RZvideoView) {
        _RZvideoView.hidden = YES;
        [_RZvideoView removeFromSuperview];
    }
    _holdRZVideoView = [[UIView alloc] init];
    _holdRZVideoView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_holdRZVideoView];
    {
        [_holdRZVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"您的视频已经上传,请耐心等待审核.";
    [_holdRZVideoView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(160.));
            make.right.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(-160));
            make.top.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(80));
        }];
    }
    
    self.holdImageView  = [[UIImageView alloc] init];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kVideoImageCacheKey];
    _holdImageView.image = image ? : [UIImage imageNamed:@"mine_photo_add"];
    [_holdRZVideoView addSubview:_holdImageView];
    {
    [_holdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(64));
        make.left.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(-160));
        make.height.mas_equalTo(_holdImageView.mas_width).multipliedBy(0.6);
    }];
    }

    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    
    [_holdImageView addSubview:coverView];
    {
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_holdImageView);
    }];
    }
    UILabel *videoTitleLabel = [[UILabel alloc] init];
    videoTitleLabel.text = @"待审核";
    videoTitleLabel.font = [UIFont systemFontOfSize:kWidth(40.)];
    videoTitleLabel.textColor = [UIColor whiteColor];
    videoTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_holdImageView addSubview:videoTitleLabel];
    {
    [videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.mas_equalTo(_holdImageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(150), 56));
    }];
    }
    
    return _holdRZVideoView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark JYLocalPhotoUtilsDelegate
- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (!videoURL) {
            return;
        }
        [JYLocalVideoUtils writeToFileWithVideoUrl:videoURL needSaveVideoName:YES];//视频保存到本地沙盒
        
        //获取视频的thumbnail
        UIImage  *thumbnail = [JYLocalVideoUtils getImage:videoURL];
        if (thumbnail) {
            self.holdRZVideoView.hidden = NO;
            self.holdImageView.image = thumbnail;
            [[SDImageCache sharedImageCache] storeImage:thumbnail forKey:kVideoImageCacheKey toDisk:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[JYLocalVideoUtils currentTime] forKey:kLastUpdateVideoTiem];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[JYHudManager manager] showProlgressShowTitle:@"视频上传中.." withDuration:10. progress:0 ];
        
           __block CGFloat time = 0;
            CGFloat videoTime = [JYLocalVideoUtils getVideoLengthWithVideoUrl:videoURL];
            videoTime = videoTime *0.2;
            if (videoTime < 2.0) {
                videoTime = 2.0;
            }else if (videoTime >= 30.0){
                videoTime = 30.0;
            }
            
            [NSTimer bk_scheduledTimerWithTimeInterval:videoTime/10 block:^(NSTimer *timer) {
            [[JYHudManager manager] showProlgressShowTitle:@"视频上传中.." withDuration:videoTime progress:time completeHanlder:^{
                [[JYHudManager manager] showHudWithText:@"视频上传成功,请等待审核"];
                }];
                time += 0.11;
                if (time > 1) {
                [timer invalidate];
                    timer = nil;
                }
            } repeats:YES];
            
        }
    }
    
}

- (void)dealloc {

}

@end
