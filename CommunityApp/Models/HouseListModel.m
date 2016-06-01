//
//  HouseListModel.m
//  CommunityApp
//
//  Created by iss on 7/15/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseListModel.h"

@implementation HouseListModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _recordId       = [dictionary objectForKey:@"recordId"];    // 记录Id
        _projectName    = [dictionary objectForKey:@"projectName"]; // 小区名称(如中环品悦、馨康花园等)
        _areaName       = [dictionary objectForKey:@"areaName"];    // 区域名称(如越秀等)
        _title          = [dictionary objectForKey:@"title"];       // 标题
        NSString* pathTemp  = [dictionary objectForKey:@"picPath"];
        if(pathTemp!=nil && pathTemp.length>1)
            _picPath = [pathTemp substringToIndex:pathTemp.length-1];
        else
            _picPath = pathTemp;
        
        _price          = [dictionary objectForKey:@"price"];       // 售价(如￥120万、￥80万等)
        _roomTypeName   = [dictionary objectForKey:@"roomTypeName"];// 户型
        _propertyInhandeName = [dictionary objectForKey:@"propertyInhandeName"]; //产证在手名称
        _houseSize      = [dictionary objectForKey:@"houseSize"];   // 大小(平米)
        _recordType     = [dictionary objectForKey:@"recordType"];  // 类型(0:长租1:短租,2:二手房)
        _priceType	  = [dictionary objectForKey:@"priceType"];
        _state        = [dictionary objectForKey:@"state"];
        _raleaseTime  = [dictionary objectForKey:@"raleaseTime"];
    }
    
    return self;
}

@end
