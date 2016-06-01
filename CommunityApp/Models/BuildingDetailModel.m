//
//  BuildingDetailModel.m
//  CommunityApp
//
//  Created by iss on 7/14/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BuildingDetailModel.h"

@implementation BuildingDetailModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _projectName = [dictionary objectForKey:@"projectName"];
        _averagePrice= [dictionary objectForKey:@"averagePrice"];
        _houseSize = [dictionary objectForKey:@"houseSize"];
        _salesStatusName = [dictionary objectForKey:@"salesStatusName"];
        _discount = [dictionary objectForKey:@"discount"];
        _openTime = [dictionary objectForKey:@"openTime"];
        _tradeTime = [dictionary objectForKey:@"tradeTime"];
        _address   = [dictionary objectForKey:@"address"];
        _buildingType = [dictionary objectForKey:@"buildingType"];
        _propertyType = [dictionary objectForKey:@"propertyType"];
        _decorationStandard = [dictionary objectForKey:@"decorationStandard"];
        _propertyRight = [dictionary objectForKey:@"propertyRight"];
        _aroundConfig  = [dictionary objectForKey:@"aroundConfig"];
        _floorAreaRatio = [dictionary objectForKey:@"floorAreaRatio"];
        _greeningRate   = [dictionary objectForKey:@"greeningRate"];
        _planningUsers  = [dictionary objectForKey:@"planningUsers"];
        _floorCondition   = [dictionary objectForKey:@"floorCondition"];
        _landArea      = [dictionary objectForKey:@"landArea"];
        _buildCountArea  = [dictionary objectForKey:@"buildCountArea"];
        _projectSchedule  = [dictionary objectForKey:@"projectSchedule"];
        _propertyCost   = [dictionary objectForKey:@"propertyCost"];
        _propertyEnterprise  = [dictionary objectForKey:@"propertyEnterprise"];
        _projectDeveloper   = [dictionary objectForKey:@"projectDeveloper"];
        _projectInvestors = [dictionary objectForKey:@"projectInvestors"];
        _salesAddr  = [dictionary objectForKey:@"salesAddr"];
        _picPath   = [dictionary objectForKey:@"picPath"];
        _apartments = [dictionary objectForKey:@"apartments"];
    }
    return self;
}
@end
