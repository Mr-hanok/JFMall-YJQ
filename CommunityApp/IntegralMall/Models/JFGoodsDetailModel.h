//
//  JFGoodsDetail.h
//  CommunityApp
//
//  Created by yuntai on 16/5/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  商品详情模型
 */
@interface JFGoodsDetailModel : NSObject
/**商品名*/
@property (nonatomic, copy) NSString *goods_name;
/**规格模型数组*/
@property (nonatomic,strong) NSMutableArray *goods_specs;
/**轮播图片url数组*/
@property (nonatomic, strong) NSMutableArray *goods_photos;
/**积分*/
@property (nonatomic, copy) NSString *goods_price;
/**价格*/
@property (nonatomic, copy) NSString *store_price;
/**图文详情html*/
@property (nonatomic, copy) NSString *goods_url;
/**库存*/
@property (nonatomic, copy) NSString *goods_inventory;
/**品牌*/
@property (nonatomic, copy) NSString *goods_brand;
/**商品描述*/
@property (nonatomic, copy) NSString *describe1;
@property (nonatomic, copy) NSString *describe2;
@property (nonatomic, copy) NSString *describe3;
@property (nonatomic, copy) NSString *describe4;

+ (JFGoodsDetailModel *)initJFGoodsDetailModellWith:(NSDictionary *)dic;
@end


/**
 *  规格模型
 */
@interface JFGoodsSpec : NSObject
@property (nonatomic, copy) NSString *specId;
/**规格名称 类型*/
@property (nonatomic, copy) NSString *name;
/**规格内容 模型数组*/
@property (nonatomic, strong) NSMutableArray *gsps;

/**选中规格id*/
@property (nonatomic, copy) NSString *checked;
@end

/**
 *  规格内容模型
 */
@interface JFGoodsGsp : NSObject
@property (nonatomic, copy) NSString *gspId;
/**规格内容*/
@property (nonatomic, copy) NSString *value;

/**是否选中*/
@property (nonatomic,assign )BOOL isSelect;
@end
