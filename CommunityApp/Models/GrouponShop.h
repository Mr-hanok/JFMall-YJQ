//
//  GrouponShop.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GrouponShop : BaseModel

@property (nonatomic, copy) NSString    *shopId;        //店铺Id
@property (nonatomic, copy) NSString    *shopName;      //店铺名称
@property (nonatomic, copy) NSString    *shopTelNo;     //店铺电话
@property (nonatomic, copy) NSString    *address;       //店铺地址

@end
