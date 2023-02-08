//
//  JYApplicationManager.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYApplication.h"

@interface JYApplicationManager : NSObject

+(instancetype)defaultManager;
-(instancetype)initWithApplicationWorkspace:(id)appWorkspace;

-(NSArray *)allApplications;
-(NSArray *)allInstalledApplications;

-(NSArray *)allApplicationIdentifiers;
-(NSArray *)allInstalledAppIdentifiers;

@end
