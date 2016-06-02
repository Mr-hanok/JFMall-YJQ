//
//  BookRequest.m
//  CommonApp
//
//  Created by lipeng on 16/3/12.
//  Copyright © 2016年 common. All rights reserved.
//

#import "BookRequest.h"
#import "BookModel.h"

@implementation BookRequest

- (NSString *)requestPath {
    return [NSString stringWithFormat:@"%@%@", Book_Url, Book_Path];
}

- (Class)modelClass {
    return [BookModel class];
}

@end
