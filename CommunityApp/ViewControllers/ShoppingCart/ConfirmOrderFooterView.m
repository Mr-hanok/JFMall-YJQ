//
//  ConfirmOrderFooterView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConfirmOrderFooterView.h"

@interface ConfirmOrderFooterView () {
    BOOL isConstraintsed;
}

@end

@implementation ConfirmOrderFooterView

- (void)showSpecialOffer:(BOOL)isShow {
    _discountView.hidden = !isShow;
    [_discountConstraint setConstant:isShow ? 44.0f : 0.0f];
}

- (void)showCouponView:(BOOL)isShow {
    _couponView.hidden = !isShow;
    [_couponConstraint setConstant:isShow ? 44.0f : 0.0f];
}

- (void)updateConstraints {
    
    if (!isConstraintsed) {
        CGFloat lineHeight = 0.5f;
        [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:lineHeight];
        [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:lineHeight];
        [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:lineHeight];
        [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:lineHeight];
        [Common updateLayout:_hLine5 where:NSLayoutAttributeHeight constant:lineHeight];
        [Common updateLayout:_hLine6 where:NSLayoutAttributeHeight constant:lineHeight];
        isConstraintsed = YES;
    }
    
    [super updateConstraints];
}

// 配送方式选择按钮点击事件处理函数
- (IBAction)deliverMethodBtnClickHandler:(id)sender
{
    if (self.selectExpressTypeBlock) {
        self.selectExpressTypeBlock();
    }
}

// 选择优惠券按钮点击事件处理函数
- (IBAction)selectCouponBtnClickHandler:(id)sender
{
    if (self.selectCouponBlock) {
        self.selectCouponBlock();
    }
}

// 备注按钮点击事件处理函数
- (IBAction)remarkBtnClickHandler:(id)sender
{
    if (self.writeRemarkBlock) {
        self.writeRemarkBlock();
    }
}


- (IBAction)paymentTypeButtonClicked:(UIButton *)sender
{
    if (self.selectPaymentTypeBlock) {
        self.selectPaymentTypeBlock();
    }
}

//#pragma mark上面的一个方法修改为下面的
//-(void)paymentTypePaymenOnline
//{
//    if (self.selectPaymentTypeBlock) {
//        self.selectPaymentTypeBlock();
//    }
//
//}
@end
