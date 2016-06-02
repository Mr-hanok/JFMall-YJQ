//
//  HouseListModel.h
//  CommunityApp
//
//  Created by iss on 7/15/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface HouseListModel : BaseModel

@property (nonatomic, copy) NSString  *recordId;             // 记录Id
@property (nonatomic, copy) NSString  *projectName;          // 小区名称(如中环品悦、馨康花园等)
@property (nonatomic, copy) NSString  *areaName;             // 区域名称(如越秀等)
@property (nonatomic, copy) NSString  *title;                // 标题
@property (nonatomic, copy) NSString  *picPath;              // 预览图片
@property (nonatomic, copy) NSString  *price;                // 售价(如￥120万、￥80万等)
@property (nonatomic, copy) NSString  *roomTypeName;         // 户型
@property (nonatomic, copy) NSString  *propertyInhandeName;  // 产证在手名称
@property (nonatomic, copy) NSString  *houseSize;            // 大小(平米)
@property (nonatomic, copy) NSString  *recordType;           // 类型(0:长租1:短租,2:二手房)
@property (nonatomic, copy) NSString  *priceType;            //价格类型 1-按天  2-按月 买房时为空
@property (nonatomic, copy) NSString  *state; 				 //审核状态 0:未审核 1:已审核 2:未通过
@property (nonatomic, copy) NSString  *raleaseTime; 		 //发布时间
@end
