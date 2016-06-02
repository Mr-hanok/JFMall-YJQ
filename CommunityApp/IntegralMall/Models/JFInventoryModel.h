//
//  JFInventoryModel.h
//  CommunityApp
//
//  Created by yuntai on 16/5/12.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
/**库存模型*/
@interface JFInventoryModel : NSObject
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *kcnum;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *store_price;
@property (nonatomic, copy) NSString *kctype;
@end
