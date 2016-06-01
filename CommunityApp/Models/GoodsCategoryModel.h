//
//  GoodsCategoryModel.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsCategoryModel : BaseModel


@property (nonatomic, copy) NSString    *categoryId;        //分类id
@property (nonatomic, copy) NSString    *categoryName;      //分类名
@property (nonatomic, copy) NSString    *categoryFlag;      //分类标示（判断是一级分类还是二级分类：0、一级分类；1、二级分类）
@property (nonatomic, copy) NSString    *parentId;          //父分类id（一级分类父分类id为null）
@property (nonatomic, copy) NSString    *categoryPicUrl;    //分类图标（一级分类才有图标、二级分类没有图标为null）

@end
