//
//  SurroundBusinessModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CustomPropertyModel.h"

@implementation CustomPropertyModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _propertyName  = [dictionary objectForKey:@"propertyName"];
        _propertyId  = [dictionary objectForKey:@"propertyId"];
        
    }
    return self;
}

@end
