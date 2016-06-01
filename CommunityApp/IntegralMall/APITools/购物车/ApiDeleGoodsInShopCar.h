//
//  ApiDeleGoodsInShopCar.h
//  CommunityApp
//
//  Created by yuntai on 16/5/13.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**删除购物车商品接口*/
@interface ApiDeleGoodsInShopCar : APIRequest
- (void)setApiParamsWithStoreId:(NSString *)storeid goodsInfoId:(NSString *)goodInfoId;
@end
