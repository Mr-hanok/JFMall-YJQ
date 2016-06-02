//
//  SurroundBusinessReviewModel.m
//  CommunityApp
//
//  Created by iss on 7/13/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "SurroundBusinessReviewModel.h"

@implementation SurroundBusinessReviewModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _reviewId = [dictionary objectForKey:@"reviewId"];
        _submitName = [dictionary objectForKey:@"submitName"];
        _submitUserId= [dictionary objectForKey:@"submitUserId"];
        _submitDate= [dictionary objectForKey:@"submitDate"];
        _score = [dictionary objectForKey:@"score"];
        _perConsumption = [dictionary objectForKey:@"perConsumption"];
        _desc = [dictionary objectForKey:@"desc"];
        _submitUserAccount = [dictionary objectForKey:@"submitUserAccount"];
        _filePath = [dictionary objectForKey:@"filePath"];
    }
    return self;
}

@end
