//
//  visitorsModel.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/24.
//  Copyright © 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface visitorsModel : NSObject
@property (nonatomic,assign)int driveCar;
@property (nonatomic,assign)long long int endTime;
@property (nonatomic,copy)NSString *keyUrl;
@property (nonatomic,copy)NSString *projectId;
@property (nonatomic,assign)long long int startTime;
@property (nonatomic,copy)NSString *target;
@property (nonatomic,assign)int times;
@property (nonatomic,assign)int total;
@property (nonatomic,copy)NSString *visitorName;

@end
