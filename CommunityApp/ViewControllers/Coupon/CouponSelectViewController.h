//
//  CouponSelectViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "Coupon.h"

@interface CouponSelectViewController : BaseViewController

@property (nonatomic, copy) void(^selectCouponBlock)(Coupon *coupon);

@property (nonatomic, copy) void(^selectCouponsBlock)(NSArray *coupons);

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, strong) NSArray *selectCouponIds;         /**< 本商家已经选择的优惠券 */
@property (nonatomic, strong) NSArray *otherSelectCouponIds;    /**< 别的商家已经选择的优惠券 */

@end
