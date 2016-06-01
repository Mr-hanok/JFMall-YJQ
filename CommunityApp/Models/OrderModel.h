//
//  UserModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

//订单支付状况模型
@interface OrderPayInfo:BaseModel
@property(nonatomic, copy) NSString     *ifPay;
@property(nonatomic, copy) NSString     *payment;
@property(nonatomic, copy) NSString     *money;
@property(nonatomic, copy) NSString     *asState;
@property(nonatomic, copy) NSString     *couponsId;
@property(nonatomic, copy) NSString     *couponsMoney;
@property(nonatomic, copy) NSString     *cpType;
@end

//订单用户信息模型
@interface OrderUserInfo:BaseModel
@property(nonatomic, copy) NSString     *address;
@property(nonatomic, copy) NSString     *remarks;
@property(nonatomic, copy) NSString     *linkTel;
@property(nonatomic, copy) NSString     *linkName;
@property(nonatomic, copy) NSString     *buildingId;
@end
//服务订单基本信息模型
@interface ServiceOrderBaseModel : BaseModel
@property(nonatomic, copy) NSString     *userId;
@property(nonatomic, copy) NSString     *createDate;
@property(nonatomic, copy) NSString     *serviceId;
@property(nonatomic, copy) NSString     *serviceName;
@property(nonatomic, copy) NSString     *orderId;
@property(nonatomic, copy) NSString     *orderNum;
@property(nonatomic, copy) NSString     *price;
@property(nonatomic, copy) NSString     *materials;
@property(nonatomic, copy) NSString     *appointmenTime;
@property(nonatomic, copy) NSString     *filePath;
@property(nonatomic, copy) NSString     *state;
@property(nonatomic, copy) NSString     *stateId ;
@property(nonatomic, copy) NSString     *type;//1 预约 2 立即

@property(nonatomic, copy) NSString     *reviews; //是否可以评价  0:不可以; 1:可以

@end

//服务订单信息模型
@interface ServiceOrderModel : BaseModel
@property(nonatomic, copy) ServiceOrderBaseModel *orderBase;
@property(nonatomic, copy) OrderUserInfo *userInfo;
@property(nonatomic, copy) OrderPayInfo *payInfo;
@end

@interface materialsModel:NSObject
@property(nonatomic, copy) NSString* CommodityId;
@property(nonatomic, copy) NSString* CommodityName;
@property(nonatomic, copy) NSString* CommodityNum;
@property(nonatomic, copy) NSString* CommodityReviews;
@property(nonatomic, copy) NSString* CommodityPrice;
@property(nonatomic, copy) NSString* CommodityPic;
@property(nonatomic, copy) NSString* CommodityState;
@property(nonatomic,copy)NSString*CommoditySpecialPrice;
@end

//商品订单基本信息模型
@interface CommodityOrderBaseModel : BaseModel
@property(nonatomic, assign) NSString*  isDetailMaterials;
@property(nonatomic, copy) NSString     *materials;
@property(nonatomic, strong) NSMutableArray     *materialsArray;
@property(nonatomic, copy) NSString     *goodsExchCodes;
@property(nonatomic, copy) NSString     *orderType;     //商品类型（1 实物商品， 2 虚拟商品）
@property(nonatomic, strong) NSMutableArray     *goodsExchCodesArray;
@property(nonatomic, copy) NSString     *createDate;
@property(nonatomic, copy) NSString     *orderId;
@property(nonatomic, copy) NSString     *state;
@property(nonatomic, copy) NSString     *stateId;
@property(nonatomic, copy) NSString     *userId;//?
@property(nonatomic, copy) NSString     *orderNum;
@property(nonatomic, copy) NSString     *money;//  订单总额
@property(nonatomic, copy) NSString     *sellerId;// 商家id，没有，表示为自营
@property(nonatomic, copy) NSString     *couponsMoney;//   优惠金额

@property(nonatomic, copy) NSString     *projectName; //项目名
@property(nonatomic, copy) NSString     *sellerName;  //商家名
@property(nonatomic, copy) NSString     *sendMoney;   //配送费
@property(nonatomic, copy) NSString     *reviews;//是否可评价

@end

//商品订单列表模型
@interface CommodityOrderListModel : BaseModel
@property(nonatomic, copy) CommodityOrderBaseModel  *orderBase;
@property(nonatomic, copy) OrderPayInfo     *payInfo;
@property(nonatomic, copy) OrderUserInfo    *userInfo;
@property(nonatomic, copy) NSString     *moduleType;
@end

//商品订单详细模型
@interface CommodityOrderDetailModel: BaseModel
@property(nonatomic, copy) CommodityOrderBaseModel* orderBase;
@property(nonatomic, copy) OrderUserInfo* userInfo;
@property(nonatomic, copy) OrderPayInfo* payInfo;
@end