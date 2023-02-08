//
//  JYTextField.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYTextField.h"

@implementation JYTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 10;
    return editingRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

- (NSAttributedString *)attributedPlaceholder {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.placeholder
                                                                              attributes:@{NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.87],
                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:kWidth(28)]}];
    return attri;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x += 10;
    placeholderRect.size.width -= 10;
    return placeholderRect;
}

@end
