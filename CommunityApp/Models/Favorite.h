//
//  Favorite.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface Favorite : BaseModel

@property (nonatomic, copy) NSString        *goodsId;       //商品ID
@property (nonatomic, copy) NSString        *goodsName;     //商品名称
@property (nonatomic, copy) NSString        *picUrl;        //商品图片url
@property (nonatomic, copy) NSString        *salePrice;     //销售价格

@end
