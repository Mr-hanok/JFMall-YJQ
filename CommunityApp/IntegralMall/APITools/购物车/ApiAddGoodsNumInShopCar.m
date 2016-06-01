//
//  ApiAddGoodsNumInShopCar.m
//  CommunityApp
//
//  Created by yuntai on 16/5/13.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ApiAddGoodsNumInShopCar.h"

@implementation ApiAddGoodsNumInShopCar
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFShopCarGoodsNumAddDelAction;
}
- (void)setApiParamsWithGoodsInfoId:(NSString *)goodInfoId count:(NSString *)count{
    JFPub_type
    User_userId_uId
    [self.params setObject:goodInfoId forKey:@"gcid"];
    [self.params setObject:count forKey:@"count"];
}

@end
