//
//  ResultModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel
-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.result = [dictionary objectForKey:@"result"];
        self.msg = [dictionary objectForKey:@"msg"];
    }
    
    return self;
}
@end
