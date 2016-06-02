//
//  AdImgSlideInfo.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AdImgSlideInfo.h"

@implementation AdImgSlideInfo

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
//        _slideInfoId = [dictionary objectForKey:@"slideInfoId"];
        _picPath = [dictionary objectForKey:@"picPath"];
        _gmId = [dictionary objectForKey:@"gmId"];
        _relatetype = [dictionary objectForKey:@"relatetype"];
        _url = [dictionary objectForKey:@"url"];
        _title = [dictionary objectForKey:@"title"];
    }
    
    return self;
}

@end
