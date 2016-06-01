//
//  ExpressOrderModel.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ExpressOrderModel : BaseModel


@property (nonatomic, copy) NSString    *expressId;     //快递订单ID
@property (nonatomic, copy) NSString    *createDate;    //创建时间
@property (nonatomic, copy) NSString    *stateId;       //快递订单状态 （未完成 包括 ： 待寄件，待取件。 已完成 包括：已寄件，已取件，已取消，已完成。一共六种状态。）
@property (nonatomic, copy) NSString    *expressName;   //快递名称
@property (nonatomic, copy) NSString    *expressNo;     //快递单号
@property (nonatomic, copy) NSString    *qrcode;        //二维码路径 待取件的时候返回这个参数

@end
