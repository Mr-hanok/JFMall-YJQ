//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"

@implementation ChartMessage

-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;

    self.icon=dict[@"icon"];
    self.time=dict[@"CreateTime"];
    self.content=dict[@"content"];
    self.title  =dict[@"title"];
    self.messageType=[dict[@"type"] intValue];
}
@end
