//
//  CouponTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface CouponTableViewCell : UITableViewCell

- (void)loadCellData:(Coupon *)model withIsSelectCoupon:(BOOL)yesOrNo;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (nonatomic, copy) void(^selectCouponCheckBoxBlock)(BOOL yesOrNo);
@property (nonatomic, assign) BOOL selectMode;

@end
