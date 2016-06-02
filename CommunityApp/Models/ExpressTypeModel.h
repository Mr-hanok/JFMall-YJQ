//
//  ExpressTypeModel.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ExpressTypeModel : BaseModel
@property (copy,nonatomic) NSString *ExpressTypeId;     // 快递ID
@property (copy,nonatomic) NSString *ExpressTypeName;   // 快递名称
@property (copy,nonatomic) NSString *ExpressTypeNo;     // 快递单号
@property (copy,nonatomic) NSString *ExpressTypePrice;  // 快递价格


-(id)initWithArray:(NSArray *)array;
@end
