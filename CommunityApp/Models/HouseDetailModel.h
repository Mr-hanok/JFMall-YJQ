//
//  HouseDetailModel.h
//  CommunityApp
//
//  Created by iss on 7/14/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface HouseDetailModel : BaseModel
@property (nonatomic, copy) NSString    *recordId;              //ID
@property (nonatomic, copy) NSString    *title;                 //标题
@property (nonatomic, copy) NSString    *projectId;             //小区ID
@property (nonatomic, copy) NSString    *projectName;           //小区名称
@property (nonatomic, copy) NSString    *roomTypeId;            //户型ID
@property (nonatomic, copy) NSString    *roomTypeName;          //户型名称
@property (nonatomic, copy) NSString    *price;                 //价格（按天、按月等）
@property (nonatomic, copy) NSString    *minPrice;              //最低价格
@property (nonatomic, copy) NSString    *maxPrice;              //最高价格
@property (nonatomic, copy) NSString    *priceType;             //价格类型 1-按天  2-按月 买房时为空
@property (nonatomic, copy) NSString    *houseSize;             //面积(平米)
@property (nonatomic, copy) NSString    *recordType;            //类型(1:租房,2:买房)
@property (nonatomic, copy) NSString    *recordTypeName;        //类型(0:长租1:短租,2:二手房)
@property (nonatomic, copy) NSString    *picPath ;              //图片(多张，以”,”分开)
@property (nonatomic, copy) NSString    *raleaseTime;           //发布时间（yyyy-MM-dd）
@property (nonatomic, copy) NSString    *orientation;           //朝向
@property (nonatomic, copy) NSString    *floor;                 //楼层
@property (nonatomic, copy) NSString    *totalFloors;           //总楼层
@property (nonatomic, copy) NSString    *houseTypeName;         //楼型
@property (nonatomic, copy) NSString    *buildingYears;         //年代
@property (nonatomic, copy) NSString    *buildingAddress;       //地址
@property (nonatomic, copy) NSString    *houseDesc;             //房屋状况
@property (nonatomic, copy) NSString    *houseLighting;         //采光状况
@property (nonatomic, copy) NSString    *houseDecoration;       //装修介绍
@property (nonatomic, copy) NSString    *schoolArea;            //学区情况
@property (nonatomic, copy) NSString    *advantage;             //特别优势
@property (nonatomic, copy) NSString    *lookTime;              //看房时间
@property (nonatomic, copy) NSString    *longitude;             //经度
@property (nonatomic, copy) NSString    *latitude;              //纬度 （用于gps定位）

@property (nonatomic, copy) NSString    *roomType;              //户型
@property (nonatomic, copy) NSString    *orientationName;       //朝向名称
@property (nonatomic, copy) NSString    *propertyInhand;        //产证在手
@property (nonatomic, copy) NSString    *propertyInhandeName;   //产证在手名称
@property (nonatomic, copy) NSString    *houseType;             //房屋类型
@property (nonatomic, copy) NSString    *property;              //产权年限
@property (nonatomic, copy) NSString    *propertyName;          //产权年限名称
@property (nonatomic, copy) NSString    *orderId;              //图片Id
@property (nonatomic, copy) NSString    *projectAdress;         //项目地址
@property (nonatomic, copy) NSString    *buildNo;
@property (nonatomic, copy) NSString    *linkPhone;
@property (nonatomic, copy) NSString    *linkman;
@property (nonatomic, copy) NSString    *roomNo;
@end
