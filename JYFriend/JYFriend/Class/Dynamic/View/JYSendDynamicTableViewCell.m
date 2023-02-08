//
//  JYSendDynamicTableViewCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSendDynamicTableViewCell.h"
#import "JYSendDynamicCell.h"
#import "JYLocalPhotoUtils.h"
#import "JYDynamicCacheUtil.h"
#import "JYLocalVideoUtils.h"

static NSString *const kSendDynamicCellIdentifier = @"ksend_dynamic_cell_identifier";
static NSString *const kSendDynamicTextCellIdentifier = @"ksend_dynamic_text_cell_identifier";
static CGFloat const kSpce = 5;



@implementation JYSendDynamaicModel


@end

@interface JYSendDynamicTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,JYLocalPhotoUtilsDelegate,UIActionSheetDelegate>

{
    UICollectionView *_layoutCollectionView;
}

@property (nonatomic,retain) NSMutableArray <JYSendDynamaicModel *>*dataSource;
@property (nonatomic,retain) UIActionSheet *actionSheet;
@end

@implementation JYSendDynamicTableViewCell
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (UIActionSheet *)actionSheet {
    if (_actionSheet) {
        return _actionSheet;
    }
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"视频", nil];
    
    return _actionSheet;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _textView = [[JYTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.textColor = [UIColor colorWithHexString:@"#333333"];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.font = [UIFont systemFontOfSize:kWidth(30)];
        _textView.myPlaceholder = @"请输入你要发表的状态...";
        _textView.myPlaceholderColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:_textView];
        {
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(30));
            make.right.mas_equalTo(self).mas_offset(kWidth(-30));
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(kWidth(300));
        }];
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kWidth(kSpce *2);
        layout.minimumInteritemSpacing = kWidth(kSpce *2);
        _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _layoutCollectionView.backgroundColor = self.backgroundColor;
        _layoutCollectionView.delegate = self;
        _layoutCollectionView.dataSource = self;
        [_layoutCollectionView registerClass:[JYSendDynamicCell class] forCellWithReuseIdentifier:kSendDynamicCellIdentifier];
        
        [self addSubview:_layoutCollectionView];
        {
            [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_textView);
                make.top.mas_equalTo(_textView.mas_bottom).mas_offset(kWidth(5));
                make.bottom.mas_equalTo(self);
            }];
        }

        
    }
    return self;
}



#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if ( indexPath.item <self.dataSource.count){
            JYSendDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSendDynamicCellIdentifier forIndexPath:indexPath];
        JYSendDynamaicModel *model = self.dataSource[indexPath.item];
        cell.image = model.image;
        if (model.type == JYSendModelTypeVideo) {
            cell.isVideo = YES;
        }else {
            cell.isVideo = NO;
        }
            return cell;
            
        }else if (indexPath.item == self.dataSource.count){
            JYSendDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSendDynamicCellIdentifier forIndexPath:indexPath];
            cell.image = [UIImage imageNamed:@"mine_photo_add"];
            return cell;
        }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.item < self.dataSource.count+1){
            CGFloat width = (CGRectGetWidth(_layoutCollectionView.bounds) - 3*kWidth(kSpce *2) )/4.;
            return CGSizeMake(width, width);
        }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
 
    if (indexPath.item <self.dataSource.count) {

    }else if (indexPath.item == self.dataSource.count){
        if (self.dataSource.count == 3) {
            [[JYHudManager manager] showHudWithText:@"最多只能上传三张图片"];
        }else {
        [self.actionSheet showFromTabBar:self.tabBar];
        }
    }
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL isVideo = NO;
    if (buttonIndex == 0) {
        //相册
        isVideo = NO;
    }else if (buttonIndex == 1){//相机
        isVideo = YES;
    }
    
    if (buttonIndex == 0 || buttonIndex == 1) {
        
    [JYLocalPhotoUtils shareManager].delegate = self;
    [[JYLocalPhotoUtils shareManager] getImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary inViewController:self.curentVC popoverPoint:CGPointZero  isVideo:isVideo allowsEditing:YES];
    }
}

#pragma mark JYLocalPhotoUtilsDelegate 相机相册访问

- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
   NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//   QBLog(@"%@",mediaType)
    if ([mediaType isEqualToString:@"public.movie"]) {//判断是否是视频
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (!videoURL) {
            return;
        }
        if (self.dataSource.count == 0) {
            UIImage *videoImage = [JYLocalVideoUtils getImage:videoURL];
            JYSendDynamaicModel *model = [[JYSendDynamaicModel alloc] init];
            model.image = videoImage;
            model.type = JYSendModelTypeVideo;
            model.videoUrl = videoURL;
            [self.dataSource addObject:model];
        }else {
            [[JYHudManager manager] showHudWithText:@"视频只能单独上传,并且最多只能上传一个视频"];
            return;
        }
        
    }else if ([mediaType isEqualToString:@"public.image"]){//判断是否是图片
          UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (self.dataSource.count >= 3) {
           [[JYHudManager manager] showHudWithText:@"最多只能上传三张图片"];
            return;
        }else {
            if (self.dataSource.count > 0) {
                JYSendDynamaicModel *model = [self.dataSource firstObject];
                if (model.type == JYSendModelTypePicture) {
                    JYSendDynamaicModel *PichModel = [[JYSendDynamaicModel alloc] init];
                    PichModel.image = image;
                    PichModel.type = JYSendModelTypePicture;
                    [self.dataSource addObject:PichModel];
                }else {
                    [[JYHudManager manager] showHudWithText:@"视频和图片不能同时上传"];
                    return;
                }
            }else if (self.dataSource.count == 0){
                JYSendDynamaicModel *PichModel = [[JYSendDynamaicModel alloc] init];
                PichModel.image = image;
                PichModel.type = JYSendModelTypePicture;
                [self.dataSource addObject:PichModel];
            
            }
        }

    }
    
    if (self.collectAction) {
        self.collectAction(self.dataSource);
    }
        [_layoutCollectionView reloadData];
    
}

@end
