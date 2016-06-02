//
//  AddressModel.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/27.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(id)initWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude andAddrName:(NSString *)addrName
{
    self = [super init];
    if(self)
    {
        _latitude = latitude;
        _longitude = longitude;
        _addrName = addrName;
    }
    return self;
}


@end
