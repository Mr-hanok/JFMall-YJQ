//
//  ConnectMode.h
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface ConnectMode : BaseModel

@property (nonatomic, copy) NSString    *callId;
@property (nonatomic, copy) NSString    *address;
@property (nonatomic, copy) NSString    *telNo;
@property (nonatomic, copy) NSString    *detailAddress;

@end


