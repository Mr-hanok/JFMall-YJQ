//
//  JFStoreInfoMode.h
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFGoodsInfoModel.h"
@interface JFStoreInfoMode : NSObject
@property(strong,nonatomic)NSString *storeid;//商店名
@property(strong,nonatomic)NSString *storeName;//商品标题
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property(assign,nonatomic)NSInteger goodsNum;//商品个数

@property(assign,nonatomic)BOOL isSelect;//是否选中状态
@property(assign,nonatomic)BOOL isEdite;//是编辑状态

+ (JFStoreInfoMode *)initModelWithDic:(NSDictionary *)dic;
+ (JFStoreInfoMode *)initModelWithDic:(NSDictionary *)dic isEdite:(BOOL)isEdite;
@end
