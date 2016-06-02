//
//  UILabel+Price.m
//
//  Created by Andrew on 15/7/24.
//  Copyright (c) 2015年 com.iss. All rights reserved.
//

#import "NSURL+Helper.h"

@implementation NSURL (Helper)

- (NSDictionary *)parseURLParams:(NSString *)query{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}



@end
