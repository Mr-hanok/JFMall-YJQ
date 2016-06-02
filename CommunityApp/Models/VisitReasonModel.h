//
//  VisitReasonModel.h
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface VisitReasonModel : BaseModel
@property (nonatomic,copy) NSString* reasonId;
@property (nonatomic,copy) NSString* reasonName;
@end
