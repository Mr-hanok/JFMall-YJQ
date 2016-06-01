//
//  SXNSObjectAdditions.h
//  TPO
//
//  Created by SunX on 14-5-14.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据校验
 */
NSString* comToString(id obj);

NSArray* comToArray(id obj);

NSDictionary* comToDictionary(id obj);

NSMutableArray* comToMutableArray(id obj);

NSMutableDictionary* comToMutableDictionary(id obj);

@interface NSObject (ComNSObjectAdditions)

- (NSString*)comJsonEncode;

- (id)comObjectFortKeySafe:(NSString*)key;

- (id)comObjectIndexSafe:(NSUInteger)index;

@end
