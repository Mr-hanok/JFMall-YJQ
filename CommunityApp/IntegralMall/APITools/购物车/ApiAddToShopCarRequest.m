//
//  ApiAddToShopCarRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ApiAddToShopCarRequest.h"

@implementation ApiAddToShopCarRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFGoodsAddShopCarAction;
}
- (void)setApiParamsWithGoodsId:(NSString *)goodsid
                          count:(NSString *)count
                       integral:(NSString *)integral
                         sku_id:(NSString *)skuid
                          gspid:(NSString *)gsp{
    
    JFPub_type
    User_userId_uId
    [self.params setObject:goodsid forKey:@"id"];
    [self.params setObject:count forKey:@"count"];
    [self.params setObject:integral forKey:@"price"];
    [self.params setObject:skuid forKey:@"sku_id"];
    [self.params setObject:gsp forKey:@"gsp"];

}

@end
