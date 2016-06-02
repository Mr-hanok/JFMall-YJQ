//
//  DistinctModel.m
//  CommunityApp
//
//  Created by iss on 7/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "DistinctModel.h"

@implementation DistinctModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self == nil)
        return self;
    _cityId = [dictionary objectForKey:@"cityId"];
    _cityName = [dictionary objectForKey:@"cityName"];
    _level = [dictionary objectForKey:@"level"];
    return self;
}
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DistinctModel *model = [[DistinctModel alloc]init];
    
    model.cityId = [self.cityId copy];
    model.cityName = [self.cityName copy];
    model.level = [self.level copy];
    
    return model;
}
@end
