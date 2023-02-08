//
//  JYRegisterDetailViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterDetailViewController.h"
#import "JYTableHeaderFooterView.h"
#import "JYSetAvatarView.h"
#import "JYNextButton.h"
#import "JYRegisterDetailCell.h"
#import "ActionSheetPicker.h"
#import "VPImageCropperViewController.h"
#import "JYRegisterPhoneNumberViewController.h"
#import "JYUserImageCache.h"

typedef NS_ENUM(NSUInteger, JYRegisterDetailRow) {
    JYRegisterDetailSexRow, //开通VIP
    JYRegisterDetailBirthRow, //红娘助手
    JYRegisterDetailTallRow, //访问我的人
    JYRegisterDetailHomeRow, //家乡
    JYRegisterDetailCount
};

static NSString *const kDetailCellReusableIdentifier = @"DetailCellReusableIdentifier";
static NSString *const kDetailHeaderViewReusableIdentifier = @"DetailHeaderViewReusableIdentifier";

@interface JYRegisterDetailViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ActionSheetMultipleStringPickerDelegate,UIActionSheetDelegate,VPImageCropperDelegate>
{
    UITableView     *_tableView;
    JYSetAvatarView *_setAvatarView;
    JYNextButton    *_nextButton;
}
@end

@implementation JYRegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载默认用户图片数据
    NSString *userPhotoKey = [JYUserImageCache writeToFileWithImage:[UIImage imageNamed:@"mine_default_avatar"] needSaveImageName:NO];
    [JYUser currentUser].userImgKey = userPhotoKey;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = MAX(kScreenHeight*0.09, 44);
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerClass:[JYRegisterDetailCell class] forCellReuseIdentifier:kDetailCellReusableIdentifier];
    [_tableView registerClass:[JYTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kDetailHeaderViewReusableIdentifier];
    
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    _setAvatarView = [[JYSetAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(400)) action:^{
        @strongify(self);
        //图片获取
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
        [actionSheet showInView:self.view];
    }];
    
    _tableView.tableHeaderView = _setAvatarView;
    _tableView.tableFooterView = [self setTableFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)setTableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth(784), kScreenWidth, kWidth(190))];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"注册成功后，性别不能修改";
    label.textColor = kColor(@"#999999");
    label.font = [UIFont systemFontOfSize:kWidth(24)];
    [footerView addSubview:label];
    
    @weakify(self);
    _nextButton = [[JYNextButton alloc] initWithTitle:@"下一步" action:^{
        @strongify(self);
        if ([JYUser currentUser].birthday == nil) {
            [[JYHudManager manager] showHudWithText:@"生日未填写"];
            return ;
        } else if ([JYUser currentUser].height == nil) {
            [[JYHudManager manager] showHudWithText:@"身高未填写"];
            return ;
        } else if ([JYUser currentUser].homeTown == nil) {
            [[JYHudManager manager] showHudWithText:@"家乡未填写"];
            return ;
        }
        
        JYRegisterPhoneNumberViewController *phoneNumVC = [[JYRegisterPhoneNumberViewController alloc] initWithTitle:@"注册"];
        [self.navigationController pushViewController:phoneNumVC animated:YES];
    }];
    [_nextButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    
    [footerView addSubview:_nextButton];
    
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(kWidth(kWidth(60)));
            make.top.equalTo(footerView).offset(kWidth(15));
            make.height.mas_equalTo(kWidth(24));
        }];
        
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(kWidth(56));
            make.centerX.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kWidth(88)));
        }];
    }
    
    return footerView;
}

- (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if ([JYUtil isIpad]) {
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:CGRectMake(0, 0, kScreenWidth, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        NSString *sourceTypeTitle = sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? @"相册":@"相机";
        [[JYHudManager manager] showHudWithTitle:sourceTypeTitle message:[NSString stringWithFormat:@"请在设备的\"设置-隐私-%@\"中允许访问%@",sourceTypeTitle,sourceTypeTitle]];
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JYRegisterDetailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYRegisterDetailCell *cell;

    if (indexPath.row < JYRegisterDetailCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYRegisterDetailSexRow) {
            cell.cellType = JYDetailCellTypeSelect;
            cell.title = @"性别";
            [JYUser currentUser].userSex = JYUserSexMale;
            cell.sexSelected = ^(NSNumber *userSex) {
            [JYUser currentUser].userSex = [userSex unsignedIntegerValue];
        };
            
        } else if(indexPath.row == JYRegisterDetailBirthRow){
            cell.cellType = JYDetailCellTypeContent;
            cell.title = @"生日";
        } else if (indexPath.row == JYRegisterDetailTallRow) {
            cell.cellType = JYDetailCellTypeContent;
            cell.title = @"身高";
        } else if (indexPath.row == JYRegisterDetailHomeRow) {
            cell.cellType = JYDetailCellTypeContent;
            cell.title = @"家乡";
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(96);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(-1, kWidth(50), -1, kWidth(50))];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(-1, kWidth(50), -1, kWidth(50))];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @weakify(self);
    if (indexPath.row == JYRegisterDetailBirthRow) {
        
        [ActionSheetDatePicker showPickerWithTitle:@"生日选择"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:[JYUtil dateFromString:KBirthDaySeletedDate WithDateFormat:kDateFormatShort]
                                       minimumDate:[JYUtil dateFromString:kBirthDayMinDate WithDateFormat:kDateFormatShort]
                                       maximumDate:[JYUtil dateFromString:kBirthDayMaxDate WithDateFormat:kDateFormatShort]
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                             @strongify(self);
                                             NSDate *newDate = [selectedDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:selectedDate]];
                                             if (newDate) {
                                                 NSString *newDateStr = [JYUtil timeStringFromDate:newDate WithDateFormat:kDateFormatChina];
                                                 [JYUser currentUser].birthday = newDateStr;
                                                 JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                                 cell.content = newDateStr;
                                             }
                                        } cancelBlock:nil origin:self.view];
        
    } else if (indexPath.row == JYRegisterDetailTallRow) {
        
        [ActionSheetStringPicker showPickerWithTitle:@"身高(:cm)"
                                                rows:[JYUser allUserHeights]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [JYUser currentUser].height = selectedValue;
                                               JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                               cell.content = selectedValue;
                                           } cancelBlock:nil origin:self.view];
        
    } else if (indexPath.row == JYRegisterDetailHomeRow) {
        
        ActionSheetMultipleStringPicker *picker = [[ActionSheetMultipleStringPicker alloc] initWithTitle:@"家乡"
                                                                                                    rows:[JYUser defaultHometown]
                                                                                        initialSelection:@[@0,@0]
                                                                                               doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
                                                   {
                                                       @strongify(self);
                                                       NSString *home = [NSString stringWithFormat:@"%@%@",[selectedValues firstObject],[selectedValues lastObject]];
                                                       [JYUser currentUser].homeTown = home;
                                                       JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                                       cell.content = home;
                                                   } cancelBlock:nil origin:self.view];
        picker.actionSheetDelegate = self;
        [picker showActionSheetPicker];
    }
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        //相册
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1)  {
        //相机
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary || type == UIImagePickerControllerSourceTypeCamera) {
        [self getImageWithSourceType:type];
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self->_setAvatarView.userImg = editedImage;
    
    NSString *userPhotoKey = [JYUserImageCache writeToFileWithImage:editedImage needSaveImageName:NO];
    [JYUser currentUser].userImgKey = userPhotoKey;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- ActionSheetMultipleStringPickerDelegate
- (NSArray *)refreshDataSource:(NSArray *)dataSource atSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *array = [dataSource firstObject];
    NSString *province = array[row];
    NSArray *cities = [JYUser allCitiesWihtProvince:province];
    return cities;
}

@end
