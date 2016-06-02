//
//  orderTrackModel.m
//  CommunityApp
//
//  Created by iss on 6/17/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "OrderTrackModel.h"

@implementation OrderTrackModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _trackDesc= [dictionary objectForKey:@"trackDesc"];
        _submitDate = [dictionary objectForKey:@"submitDate"];
        if (!_submitDate) {
            _submitDate = [dictionary objectForKey:@"updateTime"];
        }
    }
    return self;
}
@end
