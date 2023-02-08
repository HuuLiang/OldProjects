//
//  JYApplication.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYApplication : NSObject
@property (readonly) NSString *applicationIdentifier;
@property (readonly) NSString *applicationDSID;
@property (readonly) NSString *applicationType;
@property (readonly) NSString *bundleVersion;
@property (readonly) BOOL isPurchasedReDownload;
@property (readonly) BOOL isInstalled;
@property (readonly) NSNumber *itemID;
@property (readonly) NSString *itemName;
@property (readonly) NSString *shortVersionString;
@property (readonly) NSString *sourceAppIdentifier;
@property (readonly) NSString *teamID;
@property (readonly) NSString *vendorName;

@property (readonly) BOOL valid;

+(instancetype)applicationFromApplicationProxy:(id)applicationProxy;
-(instancetype)initWithApplicationProxy:(id)applicationProxy;
@end
