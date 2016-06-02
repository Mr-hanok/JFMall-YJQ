//
//  JFOrderModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**积分订单列表模型*/
@interface JFOrderModel : NSObject

@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, strong) NSMutableArray *goods;
@property (nonatomic, copy) NSString *order_flag;//1 取消订单按钮隐藏

@end


/**积分订单内商品模型*/
@interface JFOrderGoodModel : NSObject

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_spec;
@property (nonatomic, copy) NSString *goods_img;

@end
