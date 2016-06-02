//
//  CouponTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "UIImageView+AFNetworking.h"

typedef enum{
    CashCoupon = 1, // 1.现金券,
    DiscountCoupon, // 2:折扣券,
    FullCoupon,     // 3:满减券,
    GiftCoupon,     // 4:买赠券
    BenifitCoupon,  // 5:福利券
}CouponType;

@interface CouponTableViewCell()
// View
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *singleLineView;
@property (weak, nonatomic) IBOutlet UIView *doubleLineView;
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;//down
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellerNameTopMargin;


// Label
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketsTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferentialPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsPriceLabel;//满0可用

// imageView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;//up
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBoxWidth;

@end

@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _icon.layer.borderWidth = 2;
    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon.layer.cornerRadius = _icon.layer.frame.size.height / 2.0;
    _icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (_selectMode) {
//        _checkBoxBtn.selected = selected;
//    }
}

// 加载Cell数据
- (void)loadCellData:(Coupon *)model withIsSelectCoupon:(BOOL)yesOrNo
{
    _selectMode = yesOrNo;
    [self initUIViewStyle:model.ticketstype];
    [self loadUIViewData:model];
    
    if (!yesOrNo) {
        [_checkBoxBtn setHidden:YES];
        _checkBoxWidth.constant = 0;
    }else{
        [_checkBoxBtn setHidden:NO];
        self.checkBoxBtn.selected = model.isSelected;
        _checkBoxWidth.constant = 25.0f;
        _sellerNameTopMargin.constant = 20;
    }
}

- (void)initUIViewStyle:(NSString *)ticketstype {
    UIColor *bgColor = Color_Comm_AppBackground;
    NSString *ticketsType = @"";
    [_checkBoxBtn setHidden:YES];
    _checkBoxWidth.constant = 0;
    if (ticketstype == nil || [ticketstype isEqualToString:@""]) {
        return;
    }
    switch ([ticketstype integerValue]) {
        case CashCoupon:
            bgColor = Color_Coupon_Type_Cash;
            ticketsType = Str_Coupon_Type_Cash;
            [self setTextViewLineNum:2];
            break;
        case DiscountCoupon:
            bgColor = Color_Coupon_Type_Discount;
            ticketsType = Str_Coupon_Type_Discount;
            [self setTextViewLineNum:1];
            break;
        case FullCoupon:
            bgColor = Color_Coupon_Type_Full;
            ticketsType = Str_Coupon_Type_Full;
            [self setTextViewLineNum:1];
            break;
        case GiftCoupon:
            bgColor = Color_Coupon_Type_Gift;
            ticketsType = Str_Coupon_Type_Gift;
            [self setTextViewLineNum:1];
            break;
        case BenifitCoupon:
            bgColor = Color_Coupon_Type_Benifit;
            ticketsType = Str_Coupon_Type_Benifit;
            [self setTextViewLineNum:1];
            _checkBoxWidth.constant = 25.0f;
            [_checkBoxBtn setHidden:NO];
            break;
        default:
            break;
    }

    [_ticketsTypeLabel setText:ticketsType];
    [self setUIViewBorder:_baseView.layer andUIViewColor:bgColor];
}

- (void)setTextViewLineNum:(NSInteger)line {
    if (line == 1) {
        _singleLineView.hidden = NO;
        _doubleLineView.hidden = YES;
    }
    else if (line == 2)
    {
        _singleLineView.hidden = YES;
        _doubleLineView.hidden = NO;
    }
}

- (void)loadUIViewData:(Coupon *)coupon {
    NSURL *iconUrl = nil;
    NSString *imgUrl = coupon.logo;
    NSRange rang = [imgUrl rangeOfString:FileManager_Address];
    if(rang.length == 0){
        iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
    }else{
        iconUrl = [NSURL URLWithString:imgUrl];
    }
    [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    NSString *avaliableDuration = @"有效期";
    if (coupon.endDate.length < 10 && coupon.endDate.length < 10) {
        avaliableDuration = @"没有有效期";
    }
    else{
        if (coupon.startDate.length >= 10) {
            avaliableDuration = [avaliableDuration stringByAppendingString:[NSString stringWithFormat:@"自%@起", [coupon.startDate substringToIndex:10]]];
        }
        if (coupon.endDate.length >= 10) {
            avaliableDuration = [avaliableDuration stringByAppendingString:[NSString stringWithFormat:@"至%@止", [coupon.endDate substringToIndex:10]]];
        }
    }
    [self.endDateLabel setText:avaliableDuration];
    [_sellerName setText:coupon.sellerName];
    if (coupon.property != nil && coupon.property.length > 0 && coupon.cpModule != nil && coupon.cpModule.length > 0) {
        [_propertyLabel setText:[NSString stringWithFormat:@"%@|%@", coupon.property, coupon.cpModule]];
    }else if (coupon.cpModule != nil && coupon.cpModule.length > 0){
        [_propertyLabel setText:[NSString stringWithFormat:@"%@", coupon.cpModule]];
    }else if (coupon.property != nil && coupon.property.length > 0) {
        [_propertyLabel setText:[NSString stringWithFormat:@"%@", coupon.property]];
    }
    
    
    switch (coupon.ticketstype.intValue) {
        case CashCoupon:
            [_preferentialPriceLabel setText:[NSString stringWithFormat:@"￥%@",coupon.preferentialPrice]];
            //2016.03.17 满X可用，x为空时不显示
            if (![coupon.conditionsPrice isEqualToString:@""]) {
                [_conditionsPriceLabel setText:[NSString stringWithFormat:@"满%ld可用",(long)[coupon.conditionsPrice integerValue]]];
            }
            else
            {
                [_conditionsPriceLabel setText:[NSString stringWithFormat:@""]];
            }

            break;
        case DiscountCoupon:
            [_singleLineLabel setText:[NSString stringWithFormat:@"%.1f折",([coupon.discount floatValue]/10.0)]];
            break;
        case FullCoupon:
            [_singleLineLabel setText:[NSString stringWithFormat:@"满%ld减%ld",(long)[coupon.conditionsPrice integerValue],(long)[coupon.preferentialPrice integerValue]]];
            break;
        case GiftCoupon:
            [_singleLineLabel setText:[NSString stringWithFormat:@"买%@赠%@",coupon.buyNumber,coupon.givenNumber]];
            break;
        case BenifitCoupon:
            [_singleLineLabel setText:[NSString stringWithFormat:@"￥%@",coupon.preferentialPrice]];
            break;
        default:
            break;
    }
}

- (void)setUIViewBorder:(CALayer *)layer andUIViewColor:(UIColor *)color{
    layer.borderWidth = 1;
    layer.cornerRadius = 1;
    layer.masksToBounds = YES;
    layer.borderColor = Color_Coupon_Border.CGColor;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    // 团购圆形图标
    _headerView.layer.backgroundColor = color.CGColor;
}


- (IBAction)checkBoxSelectHandler:(id)sender {
    
   [_checkBoxBtn setSelected:!_checkBoxBtn.selected];
    
    if (self.selectCouponCheckBoxBlock) {
        self.selectCouponCheckBoxBlock(_checkBoxBtn.selected);
    }
}



@end
