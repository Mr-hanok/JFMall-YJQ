//
//  HouseDetailModel.m
//  CommunityApp
//
//  Created by iss on 7/14/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseDetailModel.h"

@implementation HouseDetailModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _projectId = [dictionary objectForKey:@"projectId"];;
        _recordId     = [dictionary objectForKey:@"recordId"];
        _title		  = [dictionary objectForKey:@"title"];
        _projectName  = [dictionary objectForKey:@"projectName"];
        _roomTypeName = [dictionary objectForKey:@"roomTypeName"];
        _price        = [dictionary objectForKey:@"price"];
        _priceType	  = [dictionary objectForKey:@"priceType"];
        _houseSize    = [dictionary objectForKey:@"houseSize"];
        _recordTypeName	= [dictionary objectForKey:@"recordTypeName"];
        NSString* pathTemp  = [dictionary objectForKey:@"picPath"];
        if(pathTemp!=nil && pathTemp.length>1)
            _picPath = [pathTemp substringToIndex:pathTemp.length-1];
        else
            _picPath = pathTemp;
        
        _raleaseTime    = [dictionary objectForKey:@"raleaseTime"];
        _orientation    = [dictionary objectForKey:@"orientation"];
        _floor          = [dictionary objectForKey:@"floor"];
        _totalFloors    = [dictionary objectForKey:@"totalFloors"];
        _houseTypeName  = [dictionary objectForKey:@"houseTypeName"];
        _buildingYears  = [dictionary objectForKey:@"buildingYears"];
        _buildingAddress = [dictionary objectForKey:@"buildingAddress"];
        _houseDesc       = [dictionary objectForKey:@"houseDesc"];
        _houseLighting   = [dictionary objectForKey:@"houseLighting"];
        _houseDecoration = [dictionary objectForKey:@"houseDecoration"];
        _schoolArea      = [dictionary objectForKey:@"schoolArea"];
        _advantage       = [dictionary objectForKey:@"advantage"];
        _lookTime        = [dictionary objectForKey:@"lookTime"];
        _longitude       = [dictionary objectForKey:@"longitude"];
        _latitude        = [dictionary objectForKey:@"latitude"];
        
        
        _roomType        = [dictionary objectForKey:@"roomType"];
        _orientationName = [dictionary objectForKey:@"orientationName"];
        _propertyInhand  = [dictionary objectForKey:@"propertyInhand"];
        _propertyInhandeName = [dictionary objectForKey:@"propertyInhandeName"];
        _houseType       = [dictionary objectForKey:@"houseType"];
        _property        = [dictionary objectForKey:@"property"];
        _propertyName    = [dictionary objectForKey:@"propertyName"];
        _orderId         = [dictionary objectForKey:@"orderId"];
        _projectAdress   = [dictionary objectForKey:@"projectAdress"];
        
        _buildNo = [dictionary objectForKey:@"buildNo"];
        _linkPhone = [dictionary objectForKey:@"linkPhone"];
        _linkman = [dictionary objectForKey:@"linkMan"];
        _roomNo = [dictionary objectForKey:@"roomNo"];
    }
    return self;
}

@end
