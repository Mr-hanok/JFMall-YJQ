//
//  BuildingDetailModel.h
//  CommunityApp
//
//  Created by iss on 7/14/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface BuildingDetailModel : BaseModel
@property (nonatomic, copy) NSString    *projectName;//                 名称
@property (nonatomic, copy) NSString    *averagePrice;//                 价格（1000元/㎡）
@property (nonatomic, copy) NSString    *houseSize;//                   	户型面积(平米)
@property (nonatomic, copy) NSString    *salesStatusName;//             销售（已售、待售）
@property (nonatomic, copy) NSString    *discount;//                   	优惠折扣
@property (nonatomic, copy) NSString    *openTime;//                   	开盘时间(yyyy-MM-dd)
@property (nonatomic, copy) NSString    *tradeTime;//                  	交易时间(yyyy-MM-dd)
@property (nonatomic, copy) NSString    *address;//            			楼盘地址
@property (nonatomic, copy) NSString    *buildingType;//                 建筑类型
@property (nonatomic, copy) NSString    *propertyType;//               	物业类型
@property (nonatomic, copy) NSString    *decorationStandard ;//       	装修标准
@property (nonatomic, copy) NSString    *propertyRight;//              	产权年限
@property (nonatomic, copy) NSString    *aroundConfig;//                 环线配置
@property (nonatomic, copy) NSString    *floorAreaRatio;//              	容积率
@property (nonatomic, copy) NSString    *greeningRate;//                 绿化率
@property (nonatomic, copy) NSString    *planningUsers;//                规划用户
@property (nonatomic, copy) NSString    *floorCondition;//               	楼层状况
@property (nonatomic, copy) NSString    *landArea;//                    	占地面积
@property (nonatomic, copy) NSString    *buildCountArea;//            	建筑面积
@property (nonatomic, copy) NSString    *projectSchedule;//           	工程进度
@property (nonatomic, copy) NSString    *propertyCost;//                	物业费
@property (nonatomic, copy) NSString    *propertyEnterprise;//        	物业公司
@property (nonatomic, copy) NSString    *projectDeveloper;//         	开发商
@property (nonatomic, copy) NSString    *projectInvestors;//        	投资商
@property (nonatomic, copy) NSString    *salesAddr;//                    售楼地址
@property (nonatomic, copy) NSString    *picPath;//                     	顶端图片(多张，以”,”分开)
@property (nonatomic, copy) NSString    *apartments;//                 	户型图集合（path-图路径，name-名称）
@end
