//
//  integralRulesModel.m
//  CommunityApp
//
//  Created by iss on 8/26/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "integralRulesModel.h"

@implementation integralRulesModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self)
    {
        _irId = [dictionary objectForKey:@"irId"];
        _membersLevel = [dictionary objectForKey:@"membersLevel"];
        _minimumScore = [dictionary objectForKey:@"minimumScore"];
    }
    return self;
}
@end
