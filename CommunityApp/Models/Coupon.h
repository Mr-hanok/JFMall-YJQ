//
//  Coupon.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface Coupon : BaseModel

@property (nonatomic, copy) NSString *result;        //优惠券是否有效，1、有效  0、该优惠券无效或已被使用
@property (nonatomic, copy) NSString *startDate;     //优惠券有效开始时间
@property (nonatomic, copy) NSString *endDate;       //优惠券有效结束时间
@property (nonatomic, copy) NSString *ticketstype;   //优惠券类型 （'1':'现金券','2':'折扣券','3':'满减券','4':'买赠券', '5':福利券）
@property (nonatomic, copy) NSString *preferentialPrice; //优惠金额
@property (nonatomic, copy) NSString *discount;          //折扣比例
@property (nonatomic, copy) NSString *conditionsPrice;   //减免条件
@property (nonatomic, copy) NSString *buyNumber;         //购买数量
@property (nonatomic, copy) NSString *givenNumber;       //赠送数量
@property (nonatomic, copy) NSString *cpNo;              //优惠券编号
@property (nonatomic, copy) NSString *state;             //1.未使用2.已使用3.已过期
@property (nonatomic, copy) NSString *cpId;              //优惠券ID
@property (nonatomic, copy) NSString *sellerName;        //商家名称
@property (nonatomic, copy) NSString *cpModule;          //支持栏目
@property (nonatomic, copy) NSString *property;          //属性
@property (nonatomic, copy) NSString *logo;              //优惠券图标
@property (nonatomic, copy) NSString *supportGoodsIds;   //支持的商品id 以“,”分隔

@property (nonatomic, assign) BOOL  isSelected;          // 0:未选择   1:选择
//@property(nonatomic,assign)BOOL checkBt;

/*优惠券算法*/
-(CGFloat)billByCouponWithNum:(NSInteger)num price:(CGFloat)price;

- (CGFloat)getDiscountMoneyWithPrice:(CGFloat)price;

@end
