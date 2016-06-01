//
//  SXNSObjectAdditions.m
//  TPO
//
//  Created by SunX on 14-5-14.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "ComNSObjectAdditions.h"
#import <objc/runtime.h>

@implementation NSObject (ComNSObjectAdditions)

- (NSString*)comJsonEncode {
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSMutableArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSMutableDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)comObjectFortKeySafe:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
        return [(NSDictionary*)self objectForKey:key];
    }
    return nil;
}

- (id)comObjectIndexSafe:(NSUInteger)index {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
        if (index < [(NSArray*)self count]) {
            return [(NSArray*)self objectAtIndex:index];
        }
        return nil;
    }
    return nil;
}

@end


/**
 *  数据校验
 */
NSString* comToString(id obj) {
    return [obj isKindOfClass:[NSObject class]]?[NSString stringWithFormat:@"%@",obj]:@"";
}

NSArray* comToArray(id obj)  {
    return [obj isKindOfClass:[NSArray class]]?obj:nil;
}

NSDictionary* comToDictionary(id obj) {
    return [obj isKindOfClass:[NSDictionary class]]?obj:nil;
}

NSMutableArray* comToMutableArray(id obj)   {
    return [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]] ? [NSMutableArray arrayWithArray:obj] :nil;
}

NSMutableDictionary* comToMutableDictionary(id obj)  {
    return [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]] ? [NSMutableDictionary dictionaryWithDictionary:obj] : nil;
}



