//
//  ApiDeleGoodsInShopCar.m
//  CommunityApp
//
//  Created by yuntai on 16/5/13.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ApiDeleGoodsInShopCar.h"

@implementation ApiDeleGoodsInShopCar
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFShopCarDelGoodsAction;
}
- (void)setApiParamsWithStoreId:(NSString *)storeid goodsInfoId:(NSString *)goodInfoId{
    JFPub_type
    User_userId_uId
    [self.params setObject:storeid forKey:@"store_id"];
    [self.params setObject:goodInfoId forKey:@"id"];
}

@end
