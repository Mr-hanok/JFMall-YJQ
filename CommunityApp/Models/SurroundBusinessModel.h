//
//  SurroundBusinessModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface SurroundBusinessModel : BaseModel


@property(nonatomic, copy) NSString     *businessId;        //商家ID
@property(nonatomic, copy) NSString     *businessPicUrl;    //商家图片地址
@property(nonatomic, copy) NSString     *businessName;      //商家名称
@property(nonatomic, copy) NSString     *phone;             //商家电话
@property(nonatomic, copy) NSString     *address;           //商家地址
@property(nonatomic, copy) NSString     *longitude;         //经度
@property(nonatomic, copy) NSString     *latitude;          //纬度
@property(nonatomic, copy) NSString     *distance;          //距离
@property(nonatomic, copy) NSString     *descp;             //描述 图文详情
@property(nonatomic, copy) NSString     *perConsumption;    //人均消费
@property(nonatomic, copy) NSString     *score;             //评分 0,1,2,3,4,5;
@property(nonatomic, copy) NSString     *label;             //标签 以|分割
@property(nonatomic, copy) NSString     *reviewNumber;      //评价条数
@property(nonatomic, copy) NSString     *isVerified;        //是否认证会员 0-否；1-是

@end
