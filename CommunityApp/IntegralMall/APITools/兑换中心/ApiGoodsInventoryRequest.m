//
//  ApiGoodsInventoryRequest.m
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ApiGoodsInventoryRequest.h"

@implementation ApiGoodsInventoryRequest
- (ApiAccessType)accessType
{
    return kApiAccessPost;
}
- (NSString *)serviceUrl {
    return SERVER_HOST_PRODUCT;
}
- (NSString *)urlAction {
    return JFGoodsInventoryAction;
}
-(void)setApiParamsWithGoodId:(NSString *)goodId goodsSpec:(NSString *)spec{
    JFPub_type
    User_userId_uId
    [self.params setObject:goodId forKey:@"goodsId"];
    [self.params setObject:spec forKey:@"specIds"];
}
@end
