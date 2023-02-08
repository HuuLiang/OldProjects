//
//  YFBUser.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUser.h"

static YFBUser *_currentUser;


//static NSString *const kYFBFriendCurrentUserIdKeyName       = @"kYFBFriendCurrentUserIdKeyName";
//static NSString *const kYFBFriendCurrentUserTokenKeyName    = @"kYFBFriendCurrentUserTokenKeyName";
//static NSString *const kYFBFriendCurrentUserPasswordName    = @"kFYBFriendCurrentUserPasswordName";
//static NSString *const kYFBFriendCurrentUserSignatureKeyName    = @"kYFBFriendCurrentUserSignatureKeyName";
//static NSString *const kYFBFriendCurrentUserImageKeyName    = @"kFriendCurrentUserImageKeyName";
//static NSString *const kYFBFriendCurrentUserNameKeyName     = @"kYFBFriendCurrentUserNameKeyName";
//static NSString *const kYFBFriendCurrentUserSexKeyName      = @"kYFBFriendCurrentUserSexKeyName";
//static NSString *const kYFBFriendCurrentUserAgeKeyName      = @"kYFBFriendCurrentUserAgeKeyName";
//static NSString *const kYFBFriendCurrentUserLiveCityKeyName = @"kYFBFriendCurrentUserLiveCityKeyName";
//static NSString *const kYFBFriendCurrentUserHeightKeyName   = @"kYFBFriendCurrentUserHeightKeyName";
//static NSString *const kYFBFriendCurrentUserIncomeKeyName   = @"kYFBFriendCurrentUserIncomeKeyName";
//static NSString *const kYFBFriendCurrentUserMarryingKeyName = @"kYFBFriendCurrentUserMarryingKeyName";
//static NSString *const kYFBFriendCurrentQQNumberKeyName     = @"kYFBFriendCurrentQQNumberKeyName";
//static NSString *const kYFBFriendCurrentWXNumberKeyName     = @"kYFBFriendCurrentWXNumberKeyName";
//static NSString *const kYFBFriendCurrentPhoneNumberKeyName  = @"kYFBFriendCurrentPhoneNumberKeyName";
//static NSString *const kYFBFriendCurrentEducationKeyName    = @"kYFBFriendCurrentEducationKeyName";
//static NSString *const kYFBFriendCurrentUserJobKeyName      = @"kYFBFriendCurrentUserJobKeyName";
//static NSString *const kYFBFriendCurrentBirthdayKeyName     = @"kYFBFriendCurrentBirthdayKeyName";
//static NSString *const kYFBFriendCurrentUserWeightKeyName   = @"kYFBFriendCurrentUserWeightKeyName";
//static NSString *const kYFBFriendCurrentUserStarKeyName     = @"kYFBFriendCurrentUserStarKeyName";
//
//static NSString *const kYFBUserPasswordCacheKeyName         = @"kYFBUserPasswordCacheKeyName";
static NSString *const kYFBUserDefaultPasswordKeyName       = @"666666";


@implementation YFBUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [self findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendCurrentUserKeyName]]];
//        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendCurrentUserKeyName]];
        if (!_currentUser) {
            _currentUser = [[YFBUser alloc] init];
        }
    });
    return _currentUser;
}

//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self = [super init];
//    if (self) {
//        self.userId = [coder decodeObjectForKey:kYFBFriendCurrentUserIdKeyName];
//        self.token = [coder decodeObjectForKey:kYFBFriendCurrentUserTokenKeyName];
//        self.password = [coder decodeObjectForKey:kYFBFriendCurrentUserPasswordName];
//        self.signature = [coder decodeObjectForKey:kYFBFriendCurrentUserSignatureKeyName];
//        self.userImage = [coder decodeObjectForKey:kYFBFriendCurrentUserImageKeyName];
//        self.nickName = [coder decodeObjectForKey:kYFBFriendCurrentUserNameKeyName];
//        self.userSex = [[coder decodeObjectForKey:kYFBFriendCurrentUserSexKeyName] integerValue];
//        self.age = [[coder decodeObjectForKey:kYFBFriendCurrentUserAgeKeyName] integerValue];
//        self.liveCity = [coder decodeObjectForKey:kYFBFriendCurrentUserLiveCityKeyName];
//        self.height = [[coder decodeObjectForKey:kYFBFriendCurrentUserHeightKeyName] integerValue];
//        self.income = [coder decodeObjectForKey:kYFBFriendCurrentUserIncomeKeyName];
//        self.marriageStatus = [[coder decodeObjectForKey:kYFBFriendCurrentUserMarryingKeyName] integerValue];
//        self.QQNumber = [coder decodeObjectForKey:kYFBFriendCurrentQQNumberKeyName];
//        self.WXNumber = [coder decodeObjectForKey:kYFBFriendCurrentWXNumberKeyName];
//        self.phoneNumber = [coder decodeObjectForKey:kYFBFriendCurrentPhoneNumberKeyName];
//        self.education = [coder decodeObjectForKey:kYFBFriendCurrentEducationKeyName];
//        self.job = [coder decodeObjectForKey:kYFBFriendCurrentUserJobKeyName];
//        self.birthday = [coder decodeObjectForKey:kYFBFriendCurrentBirthdayKeyName];
//        self.weight = [coder decodeObjectForKey:kYFBFriendCurrentUserWeightKeyName];
//        self.star = [coder decodeObjectForKey:kYFBFriendCurrentUserStarKeyName];
//    }
//    return self;
//}

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.userId forKey:kYFBFriendCurrentUserIdKeyName];
//    [aCoder encodeObject:self.token forKey:kYFBFriendCurrentUserTokenKeyName];
//    [aCoder encodeObject:self.password forKey:kYFBFriendCurrentUserPasswordName];
//    [aCoder encodeObject:self.signature forKey:kYFBFriendCurrentUserSignatureKeyName];
//    [aCoder encodeObject:self.userImage forKey:kYFBFriendCurrentUserImageKeyName];
//    [aCoder encodeObject:self.nickName forKey:kYFBFriendCurrentUserNameKeyName];
//    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.userSex] forKey:kYFBFriendCurrentUserSexKeyName];
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.age] forKey:kYFBFriendCurrentUserAgeKeyName];
//    [aCoder encodeObject:self.liveCity forKey:kYFBFriendCurrentUserLiveCityKeyName];
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.height] forKey:kYFBFriendCurrentUserHeightKeyName];
//    [aCoder encodeObject:self.income forKey:kYFBFriendCurrentUserIncomeKeyName];
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.marriageStatus] forKey:kYFBFriendCurrentUserMarryingKeyName];
//    [aCoder encodeObject:self.QQNumber forKey:kYFBFriendCurrentQQNumberKeyName];
//    [aCoder encodeObject:self.WXNumber forKey:kYFBFriendCurrentWXNumberKeyName];
//    [aCoder encodeObject:self.phoneNumber forKey:kYFBFriendCurrentPhoneNumberKeyName];
//    [aCoder encodeObject:self.education forKey:kYFBFriendCurrentEducationKeyName];
//    [aCoder encodeObject:self.job forKey:kYFBFriendCurrentUserJobKeyName];
//    [aCoder encodeObject:self.birthday forKey:kYFBFriendCurrentBirthdayKeyName];
//    [aCoder encodeObject:self.weight forKey:kYFBFriendCurrentUserWeightKeyName];
//    [aCoder encodeObject:self.star forKey:kYFBFriendCurrentUserStarKeyName];
//}


- (BOOL)saveOrUpdateUserInfo {
    if (_userId.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:kYFBFriendCurrentUserKeyName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //保存到数据库中
    return [self saveOrUpdate];
}

- (NSString *)userId {
    return _userId ?: @"";
}

- (NSString *)token {
    return _token;
}

- (NSString *)password {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kYFBUserPasswordCacheKeyName] ?: kYFBUserDefaultPasswordKeyName;
    return _password == nil ? kYFBUserDefaultPasswordKeyName : (_password.length == 0 ? kYFBUserDefaultPasswordKeyName : _password);
}

//- (void)setPassword:(NSString *)password {
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kYFBUserPasswordCacheKeyName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (NSString *)userImage {
    return _userImage;
}

- (NSString *)signature {
    return _signature ?: @"我正在构思一个伟大的签名";
}

- (NSString *)nickName {
    return _nickName;
}

- (YFBUserSex)userSex {
    return _userSex;
}

- (NSInteger)age {
    return (_age >= 18 && _age <= 50) ? _age : 18 ;
}

- (NSString *)liveCity {
    return _liveCity ?: @"未填写";
}

- (NSInteger)height {
    return _height;
}

- (NSString *)income {
    return _income ?: @"未填写";
}

- (YFBUserMarriageStatus)marriageStatus {
    return _marriageStatus;
}

- (NSString *)QQNumber {
    return _QQNumber ?: @"未填写";
}

- (NSString *)WXNumber {
    return _WXNumber ?: @"未填写";
}

- (NSString *)phoneNumber {
    return _phoneNumber ?: @"未填写";
}

- (NSString *)education {
    return _education ?: @"未填写";
}

- (NSString *)job {
    return _job ?: @"未填写";
}

- (NSString *)birthday {
    return _birthday ?: @"未填写";
}

- (NSString *)weight {
    return _weight ?: @"未填写";
}

- (NSString *)star {
    return _star ?: @"未填写";
}

#pragma mark - 用户注册信息选择

+ (NSArray *)allUserSex {
    return @[@"",@"男",@"女"];
}

+ (NSArray *)allUserAge {
    NSMutableArray *allAges = [NSMutableArray array];
    for (NSInteger age = 18; age <= 50; age++) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)age];
        [allAges addObject:str];
    }
    return allAges;
}

+ (NSArray *)allUserWeight {
    NSMutableArray *allWeight = [NSMutableArray array];
    for (NSInteger weight = 40; weight <= 120; weight++) {
        NSString *str = [NSString stringWithFormat:@"%ldkg",(long)weight];
        [allWeight addObject:str];
    }
    return allWeight;
}

+ (NSArray *)allUserStars {
    return @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
}

+ (NSArray *)allUserJob {
    return @[@"在校学生",@"军人",@"私营业主",@"企业职工",@"农业劳动者",@"政府机关／事业单位工作者",@"其他"];
}

+ (NSArray *)allUserEdu {
    return @[@"初中及以下",@"高中及中专",@"大专",@"本科",@"硕士及以上"];
}

+ (NSArray *)allUserIncome {
    return @[@"小于2000",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"];
}

+ (NSArray *)allUserHeight {
    NSMutableArray *allHeights = [NSMutableArray array];
    for (NSInteger height = 150; height <= 190; height++) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)height];
        [allHeights addObject:str];
    }
    return allHeights;
}

+ (NSArray *)allUserMarr {
    return @[@"未婚",@"已婚"];
}

+ (NSMutableDictionary *)allProvincesAndCities {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"provinces" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return dataDic;
}

+ (NSArray *)defaultHometown {
    NSMutableArray *hometown = [NSMutableArray array];
    NSDictionary *allProvincesAndCities = [self allProvincesAndCities];
    [hometown addObject:allProvincesAndCities.allKeys];
    [hometown addObject:[allProvincesAndCities objectForKey:[allProvincesAndCities.allKeys firstObject]][@"city"]];
    return hometown;
}

+ (NSArray *)allCitiesWihtProvince:(NSString *)province {
    NSArray *allCities = [self allProvincesAndCities][province][@"city"];
    return allCities;
}

@end
