//
//  VisitReasonModel.m
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "VisitReasonModel.h"

@implementation VisitReasonModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _reasonId = [dictionary objectForKey:@"reasonId"];
        _reasonName = [dictionary objectForKey:@"reasonName"];
    }
    
    return self;
}
@end
