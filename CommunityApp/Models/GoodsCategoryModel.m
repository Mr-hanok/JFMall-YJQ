//
//  GoodsCategoryModel.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsCategoryModel.h"

@implementation GoodsCategoryModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _categoryId = [dictionary objectForKey:@"gcId"];
        _categoryName = [dictionary objectForKey:@"gcName"];
        _categoryFlag = [dictionary objectForKey:@"clientShow"];
        _parentId = [dictionary objectForKey:@"parentId"];
        _categoryPicUrl = [dictionary objectForKey:@"goodsUrl"];
    }
    
    return self;
}

@end
