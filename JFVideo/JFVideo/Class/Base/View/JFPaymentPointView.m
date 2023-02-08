//
//  JFPaymentPointView.m
//  JFVideo
//
//  Created by Liang on 16/9/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentPointView.h"
#import "JFSystemConfigModel.h"

@interface JFPayPriceView : UIView
{
    UILabel * _priceLabel;
}
@property (nonatomic) UIButton *selectedBtn;
@property (nonatomic) JFPayPriceLevel priceLevel;
@end

@implementation JFPayPriceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor blueColor];
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
        [self addSubview:_selectedBtn];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _priceLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self addSubview:_priceLabel];
        
        {
            [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(28), kWidth(28)));
            }];
            
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_selectedBtn.mas_right).offset(kWidth(5));
                make.centerY.equalTo(_selectedBtn);
                make.height.mas_equalTo(kWidth(28));
            }];
        }
        
    }
    return self;
}


- (void)setPriceLevel:(JFPayPriceLevel)priceLevel {
    if (priceLevel == JFPayPriceLevelA) {
        _priceLabel.text = [NSString stringWithFormat:@"%ld元包月",[JFSystemConfigModel sharedModel].payAmount /100];
    } else if (priceLevel == JFPayPriceLevelB) {
        _priceLabel.text = [NSString stringWithFormat:@"%ld元包年",[JFSystemConfigModel sharedModel].payAmountPlus /100];
    } else if (priceLevel == JFPayPriceLevelC) {
        _priceLabel.text = [NSString stringWithFormat:@"%ld元终身",[JFSystemConfigModel sharedModel].payAmountPlus /100];
    }
}


@end


@interface JFPaymentPointView ()
{
    JFPayPriceView *_priceViewA;
    JFPayPriceView *_priceViewB;
    JFPayPriceView *_priceViewC;
    
    JFPayPriceLevel _priceLevel;
}
@end

@implementation JFPaymentPointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        
        _priceViewA = [[JFPayPriceView alloc] init];
        _priceViewA.selectedBtn.selected = YES;
        _priceViewA.priceLevel = JFPayPriceLevelA;
        _priceLevel = JFPayPriceLevelA;
        [self addSubview:_priceViewA];
        
//        _priceViewB = [[JFPayPriceView alloc] init];
//        _priceViewB.priceLevel = JFPayPriceLevelB;
//        [self addSubview:_priceViewB];
        
        _priceViewC = [[JFPayPriceView alloc] init];
        _priceViewC.priceLevel = JFPayPriceLevelC;
        [self addSubview:_priceViewC];
        
        @weakify(self);
        [_priceViewA bk_whenTapped:^{
            @strongify(self);
            if (_priceViewA.selectedBtn.selected) {
                return ;
            } else {
                _priceViewA.selectedBtn.selected = YES;
                _priceViewB.selectedBtn.selected = NO;
                _priceViewC.selectedBtn.selected = NO;
                _priceLevel = JFPayPriceLevelA;
                self.levelAction(_priceLevel);
            }
        }];
        
        [_priceViewB bk_whenTapped:^{
            @strongify(self);
            if (_priceViewB.selectedBtn.selected) {
                return ;
            } else {
                _priceViewA.selectedBtn.selected = NO;
                _priceViewB.selectedBtn.selected = YES;
                _priceViewC.selectedBtn.selected = NO;
                _priceLevel = JFPayPriceLevelB;
                self.levelAction(_priceLevel);
            }
        }];
        
        
        [_priceViewC bk_whenTapped:^{
            @strongify(self);
            if (_priceViewC.selectedBtn.selected) {
                return ;
            } else {
                _priceViewA.selectedBtn.selected = NO;
                _priceViewB.selectedBtn.selected = NO;
                _priceViewC.selectedBtn.selected = YES;
                _priceLevel = JFPayPriceLevelC;
                self.levelAction(_priceLevel);
            }
        }];
        
        {
            [_priceViewA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_centerX).offset(-kWidth(50));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(70)));
            }];
            
//            [_priceViewB mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(70)));
//                make.centerY.equalTo(self);
//                make.left.equalTo(_priceViewA.mas_right).offset(kWidth(25));
//            }];
            
            [_priceViewC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(70)));
                make.centerY.equalTo(self);
//                make.left.equalTo(_priceViewA.mas_right).offset(kWidth(100));
                make.left.equalTo(self.mas_centerX).offset(kWidth(50));
            }];
        }
        
    }
    return self;
}
@end
