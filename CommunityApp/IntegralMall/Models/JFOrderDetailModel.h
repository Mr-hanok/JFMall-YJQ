//
//  JFOrderDetailModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/20.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**订单明细*/
@interface JFOrderDetailModel : NSObject

//"id": 2,
//"gcs": [],
//"ship_phone": "15128276703",
//"ship_address": "chaoyangqusihuiditiezhan",
//"ship_name": "é\u009f©å\u0088©å¼º",
//"order_id": "JFDD330582016051810503503900000",
//"total_count": 0,
//"store_name": "亿街区商城",
//"total_price": 198,
//"order_status": 0
@property (nonatomic, copy) NSString *oid;
@property (nonatomic, strong) NSMutableArray *gcs;
@property (nonatomic, copy) NSString *ship_phone;
@property (nonatomic, copy) NSString *ship_address;
@property (nonatomic, copy) NSString *ship_name;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *total_count;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *order_status;

@end


@interface JFOrderDetailGoodsModel : NSObject
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *spec_info;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_img;

@end