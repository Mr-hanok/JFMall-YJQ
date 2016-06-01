//
//  ConfirmOrderFooterView.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfirmOrderFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UIView *couponView;

@property (weak, nonatomic) IBOutlet UILabel *deliverMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTextViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIImageView *hLine5;
@property (weak, nonatomic) IBOutlet UIImageView *hLine6;
@property (nonatomic, strong) IBOutlet UILabel *paymentTypeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponConstraint;

@property (nonatomic, copy) void(^selectCouponBlock)(void);
@property (nonatomic, copy) void(^selectExpressTypeBlock)(void);
@property (nonatomic, copy) void(^selectPaymentTypeBlock)(void);
@property (nonatomic, copy) void(^writeRemarkBlock)(void);
//-(void)paymentTypePaymenOnline;

- (void)showSpecialOffer:(BOOL)isShow;
- (void)showCouponView:(BOOL)isShow;

@end
