//
//  NeighBorHoodModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "NeighBorHoodModel.h"

@implementation NeighBorHoodModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
//        _cityName = [dictionary objectForKey:@"cityName"];
        _projectId = [dictionary objectForKey:@"projectId"];
        _projectName = [dictionary objectForKey:@"projectName"];
        _qrCode = [dictionary objectForKey:@"qrCode"];

    }
    return self;
}

@end

//#pragma mark - GYZCityGroup
//@implementation GYZCityGroup
//
//- (NSMutableArray *) arrayProjects
//{
//    if (_arrayProjects == nil) {
//        _arrayProjects = [[NSMutableArray alloc] init];
//    }
//    return _arrayProjects;
//}
//
//@end
