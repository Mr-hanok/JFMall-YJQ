//
//  ApiAddToShopCarRequest.h
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**加入购物车接口*/
@interface ApiAddToShopCarRequest : APIRequest

- (void)setApiParamsWithGoodsId:(NSString *)goodsid
                          count:(NSString *)count
                       integral:(NSString *)integral
                         sku_id:(NSString *)skuid
                          gspid:(NSString *)gsp;
@end
