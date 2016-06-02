//
//  GoodsComment.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsComment : BaseModel

@property (nonatomic, copy) NSString        *userPic;       //用户头像
@property (nonatomic, copy) NSString        *userName;      //评价人
@property (nonatomic, copy) NSString        *grade;         //评分
@property (nonatomic, copy) NSString        *goodsPrice;    //商品价格
@property (nonatomic, copy) NSString        *date;          //评价日期
@property (nonatomic, copy) NSString        *desc;          //评价内容
@property (nonatomic, copy) NSString        *goodsPic;      //评价图片

@end
