//
//  CouponVerifyViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "Coupon.h"

@interface CouponVerifyViewController : BaseViewController
@property (copy,nonatomic) void (^couponCode)(NSString*codeString);
@end
