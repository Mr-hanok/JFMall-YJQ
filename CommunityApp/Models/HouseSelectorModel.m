//
//  HouseSelectorModel.m
//  CommunityApp
//
//  Created by iss on 7/14/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseSelectorModel.h"

@implementation HouseSelectorModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self){
        _detailId = [dictionary objectForKey:@"detailId"];
        _detailName = [dictionary objectForKey:@"detailName"];
    }
    return self;

}
@end
