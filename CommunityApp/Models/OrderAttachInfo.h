//
//  OrderAttachInfo.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"
#import "Coupon.h"
#import "ExpressTypeModel.h"

@interface OrderAttachInfo : BaseModel

@property (nonatomic, copy) NSString        *deliverMethod;
@property (nonatomic, copy) NSString        *coupon;
@property (nonatomic, copy) NSString        *remark;

@property (nonatomic, copy) NSString        *couponIds;

@property (nonatomic, assign) NSInteger     goodsCount;
@property (nonatomic, assign) float       totalPrice;
@property (nonatomic, assign) float       allPrice;

@property (nonatomic, copy) NSString        *deliverPrice;

@property (nonatomic, retain) Coupon            *useCoupon;
@property (nonatomic, retain) ExpressTypeModel  *useExpress;

@property (nonatomic, assign) BOOL isUseCoupon;
@property (nonatomic, assign) BOOL isUseSpecialOffer;
@property (nonatomic, assign) CGFloat specialOfferDiscountPrice;


-(id)initWithGoodsCount:(NSInteger)goodsCount andTotalPrice:(float)totalPrice;
-(id)initWithGoods:(NSArray *)waresArray;

@end
