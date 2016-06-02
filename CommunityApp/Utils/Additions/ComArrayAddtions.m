//
//  TDDArrayAddtions.m
//  TDDManager
//
//  Created by SunX on 15/5/20.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

#import "ComArrayAddtions.h"

@implementation NSArray (ComArrayAddtions)

- (id)objectAtIndexSafe:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

@end
