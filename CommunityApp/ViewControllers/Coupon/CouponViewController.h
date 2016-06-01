//
//  CouponViewController.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponsDetail.h"

@interface CouponViewController : BaseViewController
@property (nonatomic, copy) void(^selectCoupon)(CouponsDetail *);
@property (nonatomic, assign) BOOL leftBtnBackToRoot;
@end
