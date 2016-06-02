//
//  JFCategorysModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  首页活动类目模型
 */
@interface JFCategorysModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray *goodsList;

+ (JFCategorysModel *)initJFCategorysModelWith:(NSDictionary *)dic;
@end


@interface JFHomeGoodsModel : NSObject
@property(strong,nonatomic)NSString *goodsId;//商品id
@property(strong,nonatomic)NSString *goods_img;//商品图片
@property(strong,nonatomic)NSString *goods_name;//商品标题
@property(strong,nonatomic)NSString *goods_price;//商品积分
@property(strong,nonatomic)NSString *store_price;//价格
@end