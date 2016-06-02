//
//  BaseModel.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

// 初始化方法一
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        //init
    }
    return self;
}

// 初始化方法二
- (id)initWithDDXMLElement:(DDXMLElement *)element
{
    self = [super init];
    if (self) {
        //init
    }
    return self;
}

// 初始化方法三
-(id)initWithMutableDictionary:(NSMutableDictionary*)dic
{
    self = [super init];
    if (self) {
        //init
    }
    
    return self;
}

// 初始化方法四
-(id)initWithFMResultSet:(FMResultSet *)rs
{
    self = [super init];
    if (self) {
        //init
    }
    
    return self;
}


- (NSDictionary *)convertToDictionary
{
    //change to your code
    return nil;
}



@end
