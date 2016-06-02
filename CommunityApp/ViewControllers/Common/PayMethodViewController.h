//
//  PayMethodViewController.h
//  CommunityApp
//
//  Created by issuser on 15/7/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "PaymentProductModel.h"
#import "MyOrderType.h"
typedef enum
{
  Payment_Prepay,
  Payment_Bill,//账单
  Payment_ServicePrepay,//服务在线付
}Payment_Goal;
@protocol PayMethodViewDelegate <NSObject>

@optional
-(void)paymentOkTodo;
-(void)paymentOkTodo:(NSString*)result;
-(void)paymentFailTodo;
@end
@interface PayMethodViewController : BaseViewController
@property (assign,nonatomic) CGFloat amount;
@property (nonatomic, copy) NSString    *orderId;
@property (nonatomic, copy) NSString    *daojiaNo;
@property (assign,nonatomic) OrderTypeEnum orderType;
 
-(void)setPayInfo:(PaymentProductModel*)product;
@property (assign,nonatomic) id<PayMethodViewDelegate> delegate;
@end
