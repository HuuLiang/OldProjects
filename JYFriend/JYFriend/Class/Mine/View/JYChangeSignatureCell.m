//
//  JYChangeSignatureCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/4.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYChangeSignatureCell.h"

@interface JYChangeSignatureCell ()<UITextViewDelegate>
{
    UILabel *_titleLabel;
}

@end

@implementation JYChangeSignatureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:_titleLabel];
        {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(30));
            make.top.mas_equalTo(self).mas_offset(kWidth(24.));
            make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(45)));
        }];
        }
        
        _signatureView = [[UITextView alloc] init];
        _signatureView.delegate = self;
        _signatureView.textColor = [UIColor colorWithHexString:@"#333333"];
        _signatureView.textAlignment = NSTextAlignmentLeft;
        _signatureView.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_signatureView];
        {
        [_signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
        }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSignature:(NSString *)signature {
    _signature = signature;
    _signatureView.text = signature;
    [self changeTextLineSpaceWith:_signatureView];
}


-(void)textViewDidChange:(UITextView *)textView

{
    
    [self changeTextLineSpaceWith:textView];
    
    
    
}

- (void)changeTextLineSpaceWith:(UITextView *)textView {

    //    textview 改变字体的行间距
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    paragraphStyle.firstLineHeadIndent = 30;
    
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    QBSafelyCallBlock(self.action,self);

}


@end
