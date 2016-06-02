//
//  AfterSaleCheckViewController.h
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface AfterSaleCheckViewController : BaseViewController
- (void) setOrderId:(NSString *)orderId andGoodsId:(NSString *)goodId;
@property (nonatomic, strong) NSString *moduleType;
@end
