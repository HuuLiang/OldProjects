//
//  JYApplication.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYApplication.h"

static NSString *const kRawClassName = @"LSApplicationProxy";

@interface JYApplication ()
@property (nonatomic,retain,readonly) id applicationProxy;

@end

@implementation JYApplication

+(instancetype)applicationFromApplicationProxy:(id)applicationProxy {
    if (![NSStringFromClass([applicationProxy class]) isEqualToString:@"LSApplicationProxy"]) {
        return nil;
    }
    
    JYApplication *instance = [[JYApplication alloc] initWithApplicationProxy:applicationProxy];
    return instance;
}

-(instancetype)initWithApplicationProxy:(id)applicationProxy {
    self = [super init];
    if (self) {
        _applicationProxy = applicationProxy;
        
        [self propAccessInspect_init];
    }
    return self;
}

-(BOOL)valid {
    return _applicationProxy != nil
    && [NSStringFromClass([_applicationProxy class]) isEqualToString:@"LSApplicationProxy"];
}

-(id)propAccessInspect_preAccessProperty:(NSString *)propertyName {
    NSArray *hookedProperties = @[@"applicationIdentifier", @"applicationDSID",
                                  @"applicationType", @"isPurchasedReDownload",
                                  @"isInstalled", @"itemID", @"itemName", @"shortVersionString",
                                  @"sourceAppIdentifier", @"teamID", @"vendorName"];
    if ([hookedProperties containsObject:propertyName]) {
        id value = [_applicationProxy valueForKey:propertyName];
        return value;
    }
    return nil;
}

@end
