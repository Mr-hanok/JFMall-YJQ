//
//  UseCouponsViewController.h
//  CommunityApp
//
//  Created by issuser on 15/7/29.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponsDetail.h"

@interface UseCouponsViewController : BaseViewController
@property(copy,nonatomic)void(^selectCouponsId)(CouponsDetail* detail);
@end
