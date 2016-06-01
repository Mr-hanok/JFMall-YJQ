//
//  BillGeneralInfoModel.h
//  CommunityApp
//
//  Created by issuser on 15/7/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface BillGeneralInfoModel : BaseModel

@property (nonatomic, copy) NSString    *prepaidAmount;     // 预交金额
@property (nonatomic, copy) NSString    *unpaidAmount;      // 未交金额

@end
