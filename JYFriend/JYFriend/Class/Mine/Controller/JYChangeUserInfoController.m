//
//  JYChangeUserInfoController.m
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYChangeUserInfoController.h"
#import "JYChangeInfoCell.h"
#import "JYChangeSignatureCell.h"
#import "ActionSheetPicker.h"
#import "JYChangeInfoTableView.h"
#import "JYRegexUtil.h"

static NSString *const kUserInfosCellIdentifier = @"kuserinfo_cell_indetifier";
static NSString *const kCangeSignatureCellIndetifier = @"kchangesignature_cell_indetifier";

typedef NS_ENUM(NSInteger,JYUserInfoSection) {//section
    JYUserInfoSectionData,//资料
    JYUserInfoSectionContact,//联系方式
    JYUserInfoSectionSignature,//签名
    JYUserInfoSectionCount
};

typedef NS_ENUM(NSInteger,JYUserInfoDataRow) {
    JYUserInfoDataRowName,
    JYUserInfoDataRowBirthDay,
    JYUserInfoDataRowGender,
    JYUserInfoDataRowHeight,
    JYUserInfoDataRowHome,
    JYUserInfoDataRowCount
};

typedef NS_ENUM(NSInteger,JYUserInfoContactRow) {
    JYUserInfoContactRowWechat,
    JYUserInfoContactRowQQ,
    JYUserInfoContactRowPhone,
    JYUserInfoContactRowCount
};

@interface JYChangeUserInfoController ()<UITableViewDelegate,UITableViewDataSource,JYChangeInfoCellDelegate,ActionSheetMultipleStringPickerDelegate>

{
    JYChangeInfoTableView *_layoutTableView;
    NSIndexPath *_currentIndexPath;
}

@end

@implementation JYChangeUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[JYChangeInfoTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _layoutTableView.separatorInset = UIEdgeInsetsZero;
    _layoutTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_layoutTableView registerClass:[JYChangeInfoCell class] forCellReuseIdentifier:kUserInfosCellIdentifier];
    [_layoutTableView registerClass:[JYChangeSignatureCell class] forCellReuseIdentifier:kCangeSignatureCellIndetifier];
    [self.view addSubview:_layoutTableView];
    {
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStyleBordered handler:^(id sender) {
        @strongify(self);
        [UIAlertView bk_showAlertViewWithTitle:@"保存修改" message:@"是否保存个人资料的修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                if ([self saveAllUserInfo]){
                    [[JYHudManager manager] showHudWithText:@"修改成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KUserChangeInfoNotificationName object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
        
    }];
    self.navigationItem.rightBarButtonItem.tintColor = kColor(@"#e147a5");
//    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
/**
 保存用户信息
 */
- (BOOL)saveAllUserInfo {
   __block BOOL result = YES;
    [[_layoutTableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [_layoutTableView indexPathForCell:obj];
        
        if (indexPath.section == JYUserInfoSectionData) {
              JYChangeInfoCell *infoCell = obj;
            if (indexPath.row == JYUserInfoDataRowName) {
                if (infoCell.textField.text.length < 2) {
                    [[JYHudManager manager] showHudWithText:@"昵称太短了"];
                    result = NO;
                    *stop = YES;
                }
            }
        } else if (indexPath.section == JYUserInfoSectionContact) {
            JYChangeInfoCell *contactCell = obj;
            switch (indexPath.row) {
                case JYUserInfoContactRowWechat:
                    if (![JYRegexUtil isWechatWithString:contactCell.textField.text] && contactCell.textField.text.length != 0) {
                        [[JYHudManager manager] showHudWithText:@"请输入正确的微信号"];
                        result = NO;
                        *stop = YES;
                    }
                    break;
                case JYUserInfoContactRowQQ:
                    if (![JYRegexUtil isQQWithString:contactCell.textField.text] && contactCell.textField.text.length != 0) {
                          [[JYHudManager manager] showHudWithText:@"请输入正确的QQ号"];
                         result = NO;
                        *stop = YES;
                    }
                    break;
                case JYUserInfoContactRowPhone:
                    if (![JYRegexUtil isPhoneNumberWithString:contactCell.textField.text] && contactCell.textField.text.length != 0) {
                        [[JYHudManager manager] showHudWithText:@"请输入正确的手机号"];
                         result = NO;
                        *stop = YES;
                    }
                    
                    break;
                default:
                    break;
            }
        }
    }];
    
    if (result == NO) {
        return result;
    }
    
    [[_layoutTableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [_layoutTableView indexPathForCell:obj];
        if (indexPath.section == JYUserInfoSectionData) {
            JYChangeInfoCell *Infocell = obj;
            switch (indexPath.row) {
                case JYUserInfoDataRowName:
                    [JYUser currentUser].nickName = Infocell.textField.text;
                    break;
                case JYUserInfoDataRowBirthDay:
                    [JYUser currentUser].birthday = Infocell.textField.text;
                    break;
                case JYUserInfoDataRowHeight:
                    [JYUser currentUser].height = Infocell.textField.text;
                    break;
                case JYUserInfoDataRowHome:
                    [JYUser currentUser].homeTown = Infocell.textField.text;
                    break;
                default:
                    break;
            }
        }else if (indexPath.section == JYUserInfoSectionContact){
            JYChangeInfoCell *cell = obj;
            switch (indexPath.row) {
                case JYUserInfoContactRowWechat:
                    [JYUser currentUser].wechat = cell.textField.text;
                    break;
                case JYUserInfoContactRowQQ:
                    [JYUser currentUser].QQ = cell.textField.text;
                    break;
                case JYUserInfoContactRowPhone:
                    [JYUser currentUser].phoneNum = cell.textField.text;
                    
                    break;
                default:
                    break;
            }
        }else if (indexPath.section == JYUserInfoSectionSignature){
            JYChangeSignatureCell *cell = obj;
            [JYUser currentUser].signature = cell.signatureView.text;
        }
    }];
  return  [[JYUser currentUser] saveOrUpdate];
    
}

/**
 键盘弹出
 */
- (void)keyBoardWillShow:(NSNotification *)notification {
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _layoutTableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    if (_currentIndexPath.section > JYUserInfoSectionData) {
        _layoutTableView.contentOffset = CGPointMake(0, keyBoardRect.size.height);
    }

}

- (void)keyBoardWillHide:(NSNotification *)notifacation {
    _layoutTableView.contentInset = UIEdgeInsetsZero;
//    _layoutTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    _layoutTableView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYUserInfoSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYUserInfoSectionData) {
        return JYUserInfoDataRowCount;
    }else if (section == JYUserInfoSectionContact) {
        return JYUserInfoContactRowCount;
    }else if (section == JYUserInfoSectionSignature){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == JYUserInfoSectionData) {
        JYChangeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfosCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYUserInfoDataRowName) {
            cell.title = @"昵称";
            cell.userInfo = [JYUser currentUser].nickName;
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == JYUserInfoDataRowBirthDay){
            cell.title = @"生日";
            cell.userInfo = [JYUser currentUser].birthday;
//            cell.cancleEditing = YES;
            cell.textField.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if (indexPath.row == JYUserInfoDataRowGender){
            cell.title = @"性别";
            cell.textField.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.userInfo = [JYUser currentUser].userSex == 1 ? @"男" : @"女";
            cell.textField.userInteractionEnabled = NO;
            return cell;
        }else if (indexPath.row == JYUserInfoDataRowHeight){
        cell.title = @"身高";
            cell.userInfo = [JYUser currentUser].height;
//            cell.cancleEditing = YES;
            cell.textField.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if (indexPath.row == JYUserInfoDataRowHome){
            cell.title = @"家乡";
            cell.userInfo = [JYUser currentUser].homeTown;
//            cell.cancleEditing = YES;
            cell.textField.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else if (indexPath.section == JYUserInfoSectionContact){
        JYChangeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfosCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYUserInfoContactRowWechat) {
            cell.title = @"微信";
            cell.userInfo = [JYUser currentUser].wechat;
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == JYUserInfoContactRowQQ){
            cell.title = @"Q Q";
            cell.userInfo = [JYUser currentUser].QQ;
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == JYUserInfoContactRowPhone){
        cell.title = @"手机";
            cell.userInfo = [JYUser currentUser].account;
            cell.delegate = self;
            return cell;
        }
    }else if (indexPath.section == JYUserInfoSectionSignature){
        JYChangeSignatureCell *cell = [tableView dequeueReusableCellWithIdentifier:kCangeSignatureCellIndetifier forIndexPath:indexPath];
        cell.title = @"个人签名";
        cell.signature = [JYUser currentUser].signature;
        @weakify(self);
        cell.action = ^(id sender){
            @strongify(self);
            self->_currentIndexPath = indexPath;
        };
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYUserInfoSectionSignature) {
        return kWidth(340);
    }
    return kWidth(90);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20);
}

/**
 tableView下划线问题
 */
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([_layoutTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_layoutTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_layoutTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_layoutTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == JYUserInfoSectionData) {
        JYChangeInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == JYUserInfoDataRowBirthDay) {
            [ActionSheetDatePicker showPickerWithTitle:@"生日选择"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[JYUtil dateFromString:KBirthDaySeletedDate WithDateFormat:kDateFormatShort]
                                           minimumDate:[JYUtil dateFromString:kBirthDayMinDate WithDateFormat:kDateFormatShort]
                                           maximumDate:[JYUtil dateFromString:kBirthDayMaxDate WithDateFormat:kDateFormatShort]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 //                                                 @strongify(self);
                                                 NSDate *newDate = [selectedDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:selectedDate]];
                                                 if (newDate) {
                                                     NSString *newDateStr = [JYUtil timeStringFromDate:newDate WithDateFormat:kDateFormatChina];
                                                     [JYUser currentUser].birthday = newDateStr;
                                                     cell.userInfo = newDateStr;
                                                 }
                                             } cancelBlock:nil origin:self.view];
            
        }else if (indexPath.row == JYUserInfoDataRowHeight){
            [ActionSheetStringPicker showPickerWithTitle:@"身高(:cm)"
                                                    rows:[JYUser allUserHeights]
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   [JYUser currentUser].height = selectedValue;
                                                   cell.userInfo = selectedValue;
                                               } cancelBlock:nil origin:self.view];
            
        }else if (indexPath.row == JYUserInfoDataRowHome){
            ActionSheetMultipleStringPicker *picker = [[ActionSheetMultipleStringPicker alloc] initWithTitle:@"家乡"
                                                                                                        rows:[JYUser defaultHometown]
                                                                                            initialSelection:@[@0,@0]
                                                                                                   doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
                                                       {
                                                           
                                                           NSString *home = [NSString stringWithFormat:@"%@%@",[selectedValues firstObject],[selectedValues lastObject]];
                                                           [JYUser currentUser].homeTown = home;
                                                           cell.userInfo = home;
                                                       } cancelBlock:nil origin:self.view];
            picker.actionSheetDelegate = self;
            [picker showActionSheetPicker];
            
        }
    }


}



#pragma mark -- ActionSheetMultipleStringPickerDelegate
- (NSArray *)refreshDataSource:(NSArray *)dataSource atSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *array = [dataSource firstObject];
    NSString *province = array[row];
    NSArray *cities = [JYUser allCitiesWihtProvince:province];
    return cities;
}

#pragma mark JYChangeInfoCellDelegate
- (void)JYChageInfoCell:(JYChangeInfoCell *)cell DidCancleEditingWithTextFiled:(UITextField *)textField {

    _currentIndexPath = [_layoutTableView indexPathForCell:cell];

}


@end
