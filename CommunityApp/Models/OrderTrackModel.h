//
//  orderTrackModel.h
//  CommunityApp
//
//  Created by iss on 6/17/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface OrderTrackModel : BaseModel
@property(nonatomic,copy)NSString* trackDesc;
@property(nonatomic,copy)NSString* submitDate;

@end
