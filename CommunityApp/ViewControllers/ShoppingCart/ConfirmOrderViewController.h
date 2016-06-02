//
//  ConfirmOrderViewController.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmOrderViewController : BaseViewController

@property (retain, nonatomic) NSMutableArray    *cartGoodsArray;    //购物车内商品数据

@property (retain, nonatomic) NSMutableArray    *cartArray;         //购物车数组(包含商品和服务)
@property (assign, nonatomic) CGFloat           totalVal;           //购物车合计
-(NSString *)roundUp:(float)number afterPoint:(int)position;
@end
