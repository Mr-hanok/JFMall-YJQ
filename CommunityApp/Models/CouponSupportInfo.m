//
//  CouponSupportInfo.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponSupportInfo.h"

@implementation CouponSupportInfo

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _spSupport = [dictionary objectForKey:@"spSupport"];
        if (_spSupport == nil) {
            _spSupport = @"";
        }
        
        _fwSupport = [dictionary objectForKey:@"fwSupport"];
        if (_fwSupport == nil) {
            _fwSupport = @"";
        }
        
        _tgSupport = [dictionary objectForKey:@"tgSupport"];
        if (_tgSupport == nil) {
            _tgSupport = @"";
        }
    }
    
    return self;
}
@end
