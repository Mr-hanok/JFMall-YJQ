//
//  UserModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface CustomPropertyModel : BaseModel
@property(nonatomic, copy) NSString     *propertyId;
@property(nonatomic, copy) NSString     *propertyName;
@end
