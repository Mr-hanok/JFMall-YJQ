//
//  SubmitOrderViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface SubmitOrderViewController : BaseViewController

@property (retain, nonatomic) NSMutableArray    *cartArray;         //购物车数组(包含商品和服务)
@property (assign, nonatomic) CGFloat           totalVal;           //购物车合计

@end
