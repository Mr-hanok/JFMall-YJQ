//
//  LimitBuySelector.h
//  CommunityApp
//
//  Created by issuser on 15/8/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface LimitBuySelector : BaseModel
@property (nonatomic, copy) NSString    *categoryId;        //分类id
@property (nonatomic, copy) NSString    *categoryName;      //分类名
@property (nonatomic, copy) NSString    *isSelected;        //是否被选中
@end
