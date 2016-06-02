//
//  BuildingSnapModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BuildingSnapModel.h"

@implementation BuildingSnapModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _projectId      = [dictionary objectForKey:@"projectId"];       //ID
        _projectName    = [dictionary objectForKey:@"projectName"];     //名称
        _averagePrice   = [dictionary objectForKey:@"averagePrice"];    //均价
        _areaName       = [dictionary objectForKey:@"areaName"];        //区域名称
        _plate          = [dictionary objectForKey:@"plate"];           //板块名称
        _pic            = [dictionary objectForKey:@"pic"];             //图片
        _salesStatusName = [dictionary objectForKey:@"salesStatusName"];//销售状态名称（已售、待售）
    }
    return self;
}
@end
