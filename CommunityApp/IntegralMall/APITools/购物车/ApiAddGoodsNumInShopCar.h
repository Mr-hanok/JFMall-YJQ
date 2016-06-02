//
//  ApiAddGoodsNumInShopCar.h
//  CommunityApp
//
//  Created by yuntai on 16/5/13.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "APIRequest.h"
/**增加减少商品数量接口*/
@interface ApiAddGoodsNumInShopCar : APIRequest
- (void)setApiParamsWithGoodsInfoId:(NSString *)goodInfoId count:(NSString *)count;
@end
