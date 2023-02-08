//
//  JYMineViewController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineViewController.h"
#import "JYTableHeaderFooterView.h"
#import "JYMineCell.h"
#import "JYMineAvatarView.h"
#import "JYDredgeVipViewController.h"
#import "JYMyPhotosController.h"
#import "JYDetailVideoViewController.h"
#import "JYChangeUserInfoController.h"
#import "JYInteractiveViewController.h"
#import "VPImageCropperViewController.h"
#import "JYSystemHelperViewController.h"
#import "JYUserImageCache.h"
#import "JYLocalPhotoUtils.h"

typedef NS_ENUM(NSUInteger, JYMineSection) {
    JYMineFunctinSection,//功能分组
    JYMineDetailSection, //资料分组
    JYMineEditSection, //编辑分组
    JYMineSectionCount
};

typedef NS_ENUM(NSUInteger, JYMineFunctionRow) {
    JYMineFunctionVipRow, //开通VIP
    JYMineFunctionRobotRow, //红娘助手
    JYMineFunctionGuestRow, //访问我的人
    JYMineFunctionRowCount
};

typedef NS_ENUM(NSUInteger, JYMineDetailRow) {
    JYMineDetailAlbumRow, //相册
    JYMineDetailVideoRow, //视频认证
    JYMineDetailRowCount
};

typedef NS_ENUM(NSUInteger, JYMineEditRow) {
    JYMineEditUpdateRow, //资料修改
    JYMineEditRowCount
};

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";


@interface JYMineViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,JYLocalPhotoUtilsDelegate,VPImageCropperDelegate>
{
    UITableView *   _tableView;
    JYMineAvatarView *_avtarView;
}
@end

@implementation JYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = MAX(kScreenHeight*0.09, 44);
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerClass:[JYMineCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [_tableView registerClass:[JYTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-20);
        }];
    }
    
    _avtarView = [[JYMineAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth *220/375.)];
    _avtarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    _tableView.tableHeaderView = _avtarView;
    @weakify(self);
    _avtarView.usersTypeAction = ^(NSNumber *mineUsersType) {
        @strongify(self);
        if ([mineUsersType unsignedIntegerValue] == JYMineUsersTypeFollow || [mineUsersType unsignedIntegerValue] == JYMineUsersTypeFans) {
            [self pushIntoInteractiveViewControllerWithType:[mineUsersType unsignedIntegerValue]];
        }else if (mineUsersType.integerValue == JYMineUsersTypeHeader){
            //图片获取
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
            [actionSheet showInView:self.tabBarController.tabBar];
        }
    };
    [self setCurrentContenInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentContenInfo) name:KUserChangeInfoNotificationName object:nil];
}


- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCurrentContenInfo {
    if (_avtarView) {
        if ([JYUser currentUser].userImgKey != nil) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JYUser currentUser].userImgKey];
            if (image) {
                _avtarView.userImg = image;
            }
        }
        _avtarView.follow = [NSString stringWithFormat:@"%ld",[JYUtil getInteractiveCountWithUserType:JYMineUsersTypeFollow]];
        _avtarView.fans = [NSString stringWithFormat:@"%ld",[JYUtil getInteractiveCountWithUserType:JYMineUsersTypeFans]];
        _avtarView.nickName = [JYUser currentUser].nickName;
        _avtarView.signature = [JYUser currentUser].signature;
    }
}

- (void)pushIntoInteractiveViewControllerWithType:(JYMineUsersType)usersType {
    JYInteractiveViewController *interactiveVC = [[JYInteractiveViewController alloc] initWithType:usersType];
    [self.navigationController pushViewController:interactiveVC animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYMineSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYMineFunctinSection){
        return JYMineFunctionRowCount;
    }else if (section == JYMineDetailSection) {
        return JYMineDetailRowCount;
    } else if (section == JYMineEditSection) {
        return JYMineEditRowCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYMineCell *cell;
    if (indexPath.section == JYMineFunctinSection || indexPath.section == JYMineDetailSection || indexPath.section == JYMineEditSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == JYMineFunctinSection) {
            if (indexPath.row == JYMineFunctionVipRow) {
                cell.iconImage = [UIImage imageNamed:@"mine_ktvip_icon"];
                cell.title = @"开通VIP";
            } else if(indexPath.row == JYMineFunctionRobotRow){
                cell.iconImage = [UIImage imageNamed:@"mine_huechys_icon"];
                cell.title = @"红娘助手";
            } else if (indexPath.row == JYMineFunctionGuestRow) {
                cell.iconImage = [UIImage imageNamed:@"mine_visit_icon"];
                cell.title = @"访问我的人";
            }
        } else if (indexPath.section == JYMineDetailSection) {
            if (indexPath.row == JYMineDetailAlbumRow) {
                cell.iconImage = [UIImage imageNamed:@"mine_photo_icon"];
                cell.title = @"我的相册";
            } else if (indexPath.row == JYMineDetailVideoRow) {
                cell.iconImage = [UIImage imageNamed:@"mine_video_icon"];
                cell.title = @"视频认证";
            }
        } else if (indexPath.section == JYMineEditSection) {
            if (indexPath.row == JYMineEditUpdateRow)  {
                cell.iconImage = [UIImage imageNamed:@"mine_changeinfo_icon"];
                cell.title = @"修改资料";
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JYTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewReusableIdentifier];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == JYMineFunctinSection) {
        return 0;
    } else {
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == JYMineFunctinSection) {
        if (indexPath.row == JYMineFunctionVipRow) {
            JYDredgeVipViewController *vipVC  = [[JYDredgeVipViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
            
        } else if (indexPath.row == JYMineFunctionRobotRow) {
            JYSystemHelperViewController *helperVC = [[JYSystemHelperViewController alloc] init];
            [self.navigationController pushViewController:helperVC animated:YES];
            
        } else if (indexPath.row == JYMineFunctionGuestRow) {
            [self pushIntoInteractiveViewControllerWithType:JYMineUsersTypeVisitor];
        }
    } else if (indexPath.section == JYMineDetailSection) {
        if (indexPath.row == JYMineDetailAlbumRow)  {
            JYMyPhotosController *photoVC = [[JYMyPhotosController alloc] init];
            [self.navigationController pushViewController:photoVC animated:YES];
            
        } else if (indexPath.row == JYMineDetailVideoRow) {
            JYDetailVideoViewController *detailVC = [[JYDetailVideoViewController alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
    } else if (indexPath.section == JYMineEditSection) {
        if (indexPath.row == JYMineEditUpdateRow) {
            JYChangeUserInfoController *InfoVC = [[JYChangeUserInfoController alloc] init];
            [self.navigationController pushViewController:InfoVC animated:YES];
        }
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self->_avtarView.userImg = editedImage;
    
    NSString *userPhotoKey = [JYUserImageCache writeToFileWithImage:editedImage needSaveImageName:NO];
    [JYUser currentUser].userImgKey = userPhotoKey;
    [[JYUser currentUser] saveOrUpdate];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        //相册
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1){//相机
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary || type == UIImagePickerControllerSourceTypeCamera) {
        [JYLocalPhotoUtils shareManager].delegate = self;
        [[JYLocalPhotoUtils shareManager] getImageWithSourceType:type inViewController:self popoverPoint:CGPointZero  isVideo:NO allowsEditing:NO];
    }
}

#pragma mark JYLocalPhotoUtilsDelegate 相机相册访问

- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    @weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^() {
        @strongify(self);
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width *13/11) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:nil];
    }];
}

@end
