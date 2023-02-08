//
//  JFPaymentPopView.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentPopView.h"
#import "JFPaymentTypeCell.h"
#import "JFSystemConfigModel.h"
#import "JFPayTypeView.h"
#import "JFPaymentPointView.h"

//static const CGFloat kHeaderImageScale = 620./280.;

#define kPaymentCellHeight MIN(kScreenHeight * 0.15, 80)
#define kPayPointTypeCellHeight MIN(kScreenHeight * 0.1, 60)



@interface JFPaymentPopView () <UITableViewSeparatorDelegate, UITableViewDataSource>
{
    UITableViewCell *_headerCell;
    UITableViewCell *_paypointTypeCell;
//    JFPaymentTypeCell *_alipayCell;
//    JFPaymentTypeCell *_wxpayCell;
//    JFPaymentTypeCell *_iAppPayCell;
//    JFPaymentTypeCell *_qqpayCell;
    NSIndexPath *_selectedIndexPath;
    JFPayTypeView *_payTypeView;
    JFPaymentPointView *_payPointView;
    
}
@property (nonatomic) JFPayPriceLevel priceLevel;
@end

@implementation JFPaymentPopView

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes
{
    self = [super init];
    if (self) {
        _availablePaymentTypes = availablePaymentTypes;
        
        _priceLevel = JFPayPriceLevelA;
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = lround(kScreenWidth*0.04);
        self.layer.masksToBounds = YES;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == PaymentTypeSection) {
//        return _availablePaymentTypes.count;
//    } else {
//        return 1;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HeaderSection) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UIImageView * bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_bgimg.jpg"]];
            UIImageView *bgImgV = [[UIImageView alloc] init];
            [bgImgV sd_setImageWithURL:[NSURL URLWithString:[JFSystemConfigModel sharedModel].payImg]];
            [_headerCell addSubview:bgImgV];
            
            UIButton *closeButton = [[UIButton alloc] init];
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
            [_headerCell addSubview:closeButton];
            
            UIImageView *shadeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_shade"]];
            shadeImgV.userInteractionEnabled = YES;
            [_headerCell addSubview:shadeImgV];
            
            _payPointView = [[JFPaymentPointView alloc] init];
            [_headerCell addSubview:_payPointView];
            
            _payTypeView = [[JFPayTypeView alloc] initWithPayTypesArray:_availablePaymentTypes];
            [shadeImgV addSubview:_payTypeView];
            
            
            {
                [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_headerCell);
                }];
                
                [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(_headerCell).offset(10);
                    make.top.equalTo(_headerCell).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
                
                [shadeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(_headerCell);
                    make.height.mas_equalTo(kWidth(259));
                }];
                
                [_payPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(shadeImgV);
                    make.top.equalTo(shadeImgV).offset(kWidth(40));
                    make.height.mas_equalTo(kWidth(100));
                }];
                
                [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(shadeImgV);
                    make.height.mas_equalTo(kWidth(100));
                    make.bottom.equalTo(shadeImgV.mas_bottom).offset(-kWidth(30));
                }];

            }
            
            @weakify(self);
            _payPointView.levelAction = ^(JFPayPriceLevel priceLevel) {
                @strongify(self);
                self.priceLevel = priceLevel;
            };
            
            
            _payTypeView.payAction = ^(QBOrderPayType type) {
                @strongify(self);
                self.paymentAction(type,self.priceLevel);
            };
            
            [closeButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.closeAction) {
                    self.closeAction(self);
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
        return _headerCell;
    }
//    }  else if (indexPath.section == PaymentTypeSection) {
//        @weakify(self);
//        for (NSInteger i  = 0; i < _availablePaymentTypes.count; i++) {
//            NSDictionary *dict = _availablePaymentTypes[i];
//            JFPaymentType type = [dict[@"type"] integerValue];
//            JFSubPayType subType = [dict[@"subType"] integerValue];
//            if (indexPath.row == i) {
//                
//                JFPaymentTypeCell *cell = [[JFPaymentTypeCell alloc]initWithPaymentType:type subType:subType];
//                cell.selectionAction = ^(JFPaymentType paymentType){
//                    @strongify(self);
//                    [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//                };
//                
//                return cell;
//            }
//        }
//    } else if (indexPath.section == PaySection) {
//        UITableViewCell * _payCell = [[UITableViewCell alloc] init];
//        _payCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        _payCell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//        
//        UIButton *_payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
//        _payBtn.titleLabel.font = [UIFont systemFontOfSize:16.];
//        [_payBtn setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
//        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#ff680d"];
//        _payBtn.layer.cornerRadius = kScreenHeight * 10 / 1334.;
//        _payBtn.layer.masksToBounds = YES;
//        [_payCell addSubview:_payBtn];
//        @weakify(self);
//        [_payBtn bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            JFPaymentTypeCell * cell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
//            if (_paymentAction) {
//                 _paymentAction(cell.payType,cell.subType);
//            }
//           
//        } forControlEvents:UIControlEventTouchUpInside];
//        
//        {
//            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(_payCell);
//                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 440 / 750., kScreenHeight * 78 / 1334.));
//            }];
//        }
//        return _payCell;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kWidth(780);
}

@end
