//
//  DistinctModel.h
//  CommunityApp
//
//  Created by iss on 7/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface DistinctModel : BaseModel
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *level;
@end
