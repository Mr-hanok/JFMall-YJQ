//
//  SurroundBusinessModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "OrderModel.h"
 

//订单支付状况模型
@implementation OrderPayInfo
//asState = 0;
//couponsMoney = "0.0";
//createDate = "2015-11-12 16:46:33";
//ifPay = 0;
//materials = "\U626d\U626d\U8f661\U5728\U7ebf:89.0:1";
//moduleType = 7;
//money = "89.0";
//orderId = "9851c99c-8b3c-4c7a-a319-8efd192e6640";
//orderNum = S1511121646331250811;
//payment = 0;
//reviews = 1;
//sellerId = 589;
//state = "\U5f85\U4ed8\U6b3e";
//stateId = 5;
//userId = 125081;
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _ifPay = [dictionary objectForKey:@"ifPay"];
        _payment = [dictionary objectForKey:@"payment"];
        _money = [dictionary objectForKey:@"money"];
        _asState = [dictionary objectForKey:@"asState"];
        _couponsId = [dictionary objectForKey:@"couponsId"];
        _couponsMoney= [dictionary objectForKey:@"couponsMoney"];
        _cpType = [dictionary objectForKey:@"cpType"];
    }
    YjqLog(@"dictionary==========%@",dictionary);
    return self;
}
@end

//asState = 0;
//couponsMoney = "0.0";
//createDate = "2015-11-12 16:46:33";
//ifPay = 0;
//materials = "\U626d\U626d\U8f661\U5728\U7ebf:89.0:1";
//moduleType = 7;
//money = "89.0";
//orderId = "9851c99c-8b3c-4c7a-a319-8efd192e6640";
//orderNum = S1511121646331250811;
//payment = 0;
//reviews = 1;
//sellerId = 589;
//state = "\U5f85\U4ed8\U6b3e";
//stateId = 5;
//userId = 125081;
//订单用户信息模型
@implementation OrderUserInfo
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _address = [dictionary objectForKey:@"address"];
        _remarks = [dictionary objectForKey:@"remarks"];
        _linkTel = [dictionary objectForKey:@"linkTel"];
        _linkName = [dictionary objectForKey:@"linkName"];
        _buildingId = [dictionary objectForKey:@"buildingId"];
        
    }
    YjqLog(@"dictionary==========%@",dictionary);

    return self;
}

@end
//服务订单基本信息模型
@implementation ServiceOrderBaseModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _userId = [dictionary objectForKey:@"userId"];
        _appointmenTime = [dictionary objectForKey:@"appointmenTime"];
        _createDate = [dictionary objectForKey:@"createDate"];
        _filePath = [dictionary objectForKey:@"filePath"];
        _type = [dictionary objectForKey:@"type"];
        _serviceId = [dictionary objectForKey:@"serviceId"];
        _orderId = [dictionary objectForKey:@"orderId"];
        _orderNum = [dictionary objectForKey:@"orderNum"];
        _price = [dictionary objectForKey:@"price"];
        _materials = [dictionary objectForKey:@"materials"];
        _state = [dictionary objectForKey:@"state"];
        _stateId = [dictionary objectForKey:@"stateId"];
        _serviceName = [dictionary objectForKey:@"serviceName"];
        _reviews = [dictionary objectForKey:@"reviews"];
    }
    return self;
}
@end

//服务订单信息模型
@implementation ServiceOrderModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
         _orderBase = [[ServiceOrderBaseModel alloc]initWithDictionary:dictionary];
        _userInfo = [[OrderUserInfo alloc]initWithDictionary:dictionary];
        _payInfo = [[OrderPayInfo alloc]initWithDictionary:dictionary];
    }
    return self;
}

@end
@implementation materialsModel
-(id)init{
    self = [super init];
    if (self) {
        //init
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        //init
        _CommodityId = [dictionary objectForKey:@"goodsId"];
        _CommodityName = [dictionary objectForKey:@"goodsName"];
        _CommodityReviews = [dictionary objectForKey:@"reviews"];
        _CommodityNum = [dictionary objectForKey:@"numbers"];
        _CommodityPic = [dictionary objectForKey:@"goodsUrl"];
        _CommodityPrice = [dictionary objectForKey:@"unitPrice"];
        _CommodityState =  [dictionary objectForKey:@"asState"];
    }
    return self;
}
@end
//商品订单基本信息模型
@implementation CommodityOrderBaseModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    _isDetailMaterials = @"0";
    self = [super initWithDictionary:dictionary];
    if (self) {
        _materialsArray = [[NSMutableArray alloc]init];
        _materials = [dictionary objectForKey:@"materials"];
        _goodsExchCodesArray = [[NSMutableArray alloc]init];
        _goodsExchCodes = [dictionary objectForKey:@"goodsExchCodes"];
        _orderType = [dictionary objectForKey:@"orderType"];
        _createDate = [dictionary objectForKey:@"createDate"];
        _orderId = [dictionary objectForKey:@"orderId"];
        _state = [dictionary objectForKey:@"state"];
        _stateId = [dictionary objectForKey:@"stateId"];
        _userId = [dictionary objectForKey:@"userId"];
        _orderNum = [dictionary objectForKey:@"orderNum"];
        _money = [dictionary objectForKey:@"money"];
        _sellerId = [dictionary objectForKey:@"sellerId"];
        _couponsMoney = [dictionary objectForKey:@"couponsMoney"];
        _isDetailMaterials = [dictionary objectForKey:@"isDetailMaterials"];
        _reviews =  [dictionary objectForKey:@"reviews"];
        if(_isDetailMaterials==nil || [_isDetailMaterials isEqualToString:@"0"]==TRUE)
        {
          [self paraseMaterials];
        }
        else
        {
            [self paraseDetailMaterials];
        }
        
        if (_goodsExchCodes && _goodsExchCodes.length > 0) {
            [self paraseGoodsExchCodes];
        }
        _projectName = [dictionary objectForKey:@"projectName"];
        _sellerName = [dictionary objectForKey:@"sellerName"];
        _sendMoney = [dictionary objectForKey:@"sendMoney"];
    }
    return self;
}
-(void)paraseDetailMaterials
{
    NSRange rang = {1,_materials.length-2};
    YjqLog(@"%@",_materials);
    NSString* materialString  = [[_materials substringWithRange:rang] copy];//remove"[]"
    NSArray* materialArray = [materialString componentsSeparatedByString:@"}"];
    for (NSString* material in materialArray) {
        if([material isEqualToString:@""])
            break;
        NSMutableDictionary* materialDic = [[NSMutableDictionary alloc]init];
        NSString *strTemp = [material stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSRange strRange = [strTemp rangeOfString:@"{"];
        materialString = [strTemp substringFromIndex:strRange.location+1];//remove"{}"
        
        NSArray* materials = [materialString componentsSeparatedByString:@","];
        for (NSString * string in materials) {
            NSArray* dic = [string componentsSeparatedByString:@":"] ;
            YjqLog(@"%@",dic);
            NSString* key = [dic objectAtIndex:0];
            NSString* value = [dic objectAtIndex:1];
            [materialDic setObject:value.copy forKey:key.copy];
            
        }
        materialsModel*  materialModel = [[materialsModel alloc]initWithDictionary:materialDic];
//        materialModel.CommodityId = [materials objectAtIndex:0];
//        materialModel.CommodityName = [materials objectAtIndex:1];
//        materialModel.CommodityNum = [materials objectAtIndex:2];
//        materialModel.CommodityPrice = [materials objectAtIndex:3];
//        materialModel.CommodityPic = [materials objectAtIndex:4];
        [_materialsArray addObject:materialModel];
    }
}
-(void) paraseMaterials
{
    NSString* materialString  = [NSString stringWithFormat:@"%@",_materials];
    NSArray* materialArray = [materialString componentsSeparatedByString:@","];
    YjqLog(@"%@",_materials);
    for (NSString* material in materialArray) {
        NSArray* materials = [material componentsSeparatedByString:@":"];
        materialsModel*  materialModel = [[materialsModel alloc]init];
        materialModel.CommodityName = [materials objectAtIndex:0];
        materialModel.CommodityPrice = [materials objectAtIndex:1];
        materialModel.CommodityNum = [materials objectAtIndex:2];
        YjqLog(@"%ld",materials.count);
        if (materials.count>3) {
        materialModel.CommoditySpecialPrice=[materials objectAtIndex:3];//首件特价
        }
        YjqLog(@"materialModel.CommoditySpecialPrice===%@",materialModel.CommoditySpecialPrice);
        [_materialsArray addObject:materialModel];
    }
}

-(void)paraseGoodsExchCodes {
    [_goodsExchCodesArray removeAllObjects];
    NSArray *codesArray = [_goodsExchCodes componentsSeparatedByString:@","];
    for (NSString *codeString in codesArray) {
        NSArray *goods = [codeString componentsSeparatedByString:@":"];
        if (goods.count > 0) {
            NSString *codeStr = goods[0];
            NSString *priceStr = @"";
            if (goods.count > 1) {
                priceStr = [NSString stringWithFormat:@"￥%@", goods[1]];
            }
            if (codeStr && codeStr.length > 0) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:codeStr, @"code", priceStr, @"price", nil];
                [_goodsExchCodesArray addObject:dic];
            }
        }
    }
}

@end

//商品订单列表模型
@implementation CommodityOrderListModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _orderBase = [[CommodityOrderBaseModel alloc]initWithDictionary:dictionary];
        _payInfo = [[OrderPayInfo alloc]initWithDictionary:dictionary];
        _userInfo = [[OrderUserInfo alloc]initWithDictionary:dictionary];
        _moduleType = [dictionary objectForKey:@"moduleType"];
    }
    return self;
}

@end

//商品订单详细模型
@implementation CommodityOrderDetailModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
   self = [super initWithDictionary:dictionary];
    if (self) {
        _orderBase = [[CommodityOrderBaseModel alloc]initWithDictionary:dictionary];
        _userInfo = [[OrderUserInfo alloc]initWithDictionary:dictionary];
        _payInfo = [[OrderPayInfo alloc]initWithDictionary:dictionary];
    }
    return self;
}

@end
