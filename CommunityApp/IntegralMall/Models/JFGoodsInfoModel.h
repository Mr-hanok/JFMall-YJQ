//
//  JFGoodsInfoModel.h
//  CommunityApp
//
//  Created by yuntai on 16/4/21.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  购物车商品模型
 */
@interface JFGoodsInfoModel : NSObject

//"id": 230785,
//"spec_info": "颜色:白色 ",
//"price": 99,
//"count": 1,
//"goods_name": "超5星幸福指数精致花束",
//"sku_id": "98552.32768_",
//"goods_img": "upload/store/1/2016/01/17/f010287c55b04e98aaca7d1d208224b9.jpg_small.jpg"
@property(strong,nonatomic)NSString *goodsId;//商品id
@property(strong,nonatomic)NSString *goods_img;//商品图片
@property(strong,nonatomic)NSString *goods_name;//商品名
@property(strong,nonatomic)NSString *spec_info;//商品规格
@property(strong,nonatomic)NSString *goodsIntegral;//商品积分
@property(strong,nonatomic)NSString *sku_id;//sku_id
@property(assign,nonatomic)NSInteger goodsNum;//商品个数

@property(assign,nonatomic)BOOL isSelect;//是否选中状态
@property(assign,nonatomic)BOOL isEdite;//是编辑状态

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
