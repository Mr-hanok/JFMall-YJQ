//
//  AddressModel.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/27.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel

@property (nonatomic, assign) CGFloat   latitude;
@property (nonatomic, assign) CGFloat   longitude;
@property (nonatomic, copy)   NSString  *addrName;


-(id)initWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude andAddrName:(NSString *)addrName;

@end
