//
//  UITextField+LimitLength.m
//  TextLengthLimitDemo
//
//  Created by Su XinDe on 13-4-8.
//  Copyright (c) 2013年 Su XinDe. All rights reserved.
//

#import "UITextField+LimitLength.h"
#import <objc/objc.h>
//#import <objc/objc-runtime.h>
#import <objc/runtime.h>

@implementation UITextField (LimitLength)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
    
    NSString *lang = self.textInputMode.primaryLanguage; //[[UITextInputMode currentInputMode] primaryLanguage];
    //zh-Hans en-Us
    if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        if (!position){//非高亮
            if (self.text.length > length) {
                self.text = [self.text substringToIndex:length];
            }
        }
    }else{//中文输入法以外
        if(self.text.length > length){
            self.text = [self.text substringToIndex:length];
        }
    }
}

@end
