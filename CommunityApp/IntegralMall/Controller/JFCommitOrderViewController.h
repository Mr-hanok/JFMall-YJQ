//
//  JFCommitOrderViewController.h
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFBaseViewController.h"
/**
 *  提交订单
 */
@interface JFCommitOrderViewController : JFBaseViewController
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *log_id;
@property (nonatomic, copy) NSString *order_flag;
@property (nonatomic, assign) BOOL isPrize;
@end
