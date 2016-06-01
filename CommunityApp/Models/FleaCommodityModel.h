//
//  FleaCommodityModel.h
//  CommunityApp
//
//  Created by iss on 8/13/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface FleaCommodityListModel : BaseModel
@property (nonatomic, copy) NSString        *stId;//id
@property (nonatomic, copy) NSString        *stNo;//编号
@property (nonatomic, copy) NSString        *title;//标题
@property (nonatomic, copy) NSString        *price;//价格
@property (nonatomic, copy) NSString        *positionName;//地区名称
@property (nonatomic, copy) NSString        *createTime;//发布时间
@property (nonatomic, copy) NSString        *picture;//封面图片
@property (nonatomic, copy) NSString        *hasNext;//有无下一条(Y或N)
@end

@interface FleaCommodityDetailModel : BaseModel
@property (nonatomic, copy) NSString        *stNo;//编号
@property (nonatomic, copy) NSString        *title;//标题
@property (nonatomic, copy) NSString        *price;//价格
@property (nonatomic, copy) NSString        *degree;//新旧程度
@property (nonatomic, copy) NSString        *person;//发布人
@property (nonatomic, copy) NSString        *phone;//发布人电话
@property (nonatomic, copy) NSString        *positionName;//地区层级名称（如：江苏省>无锡市>江阴市）
@property (nonatomic, copy) NSString        *cityId;//地区ID（地区层级名称中最底级的地区ID，如：江阴市ID）
@property (nonatomic, copy) NSString        *createTime;//发布时间
@property (nonatomic, copy) NSString        *desc;//详情描述
@property (nonatomic, copy) NSString        *classifyName;//商品分类层级名称（如：产品>电子产品>手机）
@property (nonatomic, copy) NSString        *gcId;//商品分类ID（分类名称中最底级的分类ID，如：手机ID）
@property (nonatomic, copy) NSString        *picture;//图片ID
@property (nonatomic, copy) NSString        *state;//状态（1-已审核,0-未审核）
@end