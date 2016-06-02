//
//  QuestionnaireSurvey.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "QuestionnaireSurvey.h"

@implementation QuestionnaireSurvey

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _mpqid = [dictionary objectForKey:  @"mpqid"];
        _title = [dictionary objectForKey:  @"title"];
        _questionDescription = [dictionary objectForKey:  @"description"];
        _starttime = [dictionary objectForKey:  @"starttime"];
        _endtime = [dictionary objectForKey:  @"endtime"];
    }
    
    return self;
}
@end
