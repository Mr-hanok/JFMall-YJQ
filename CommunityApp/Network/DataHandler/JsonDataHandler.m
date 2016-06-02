//
//  JsonDataHandler.m
//  CommonApp
//
//  Created by lipeng on 16/4/4.
//  Copyright © 2016年 common. All rights reserved.
//

#import "JsonDataHandler.h"

@implementation JsonDataHandler

- (NSDictionary *)handleResponse:(id)responseData {
    if (responseData){
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error)
            return nil;
        return dic;
    }
    return nil;
}

@end
