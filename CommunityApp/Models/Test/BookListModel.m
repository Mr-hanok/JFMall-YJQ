//
//  BookListModel.m
//  CommonApp
//
//  Created by lipeng on 16/3/30.
//  Copyright © 2016年 common. All rights reserved.
//

#import "BookListModel.h"
#import "BookModel.h"

@implementation BookListModel

#pragma mark - build
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : [BookModel class]};
}

#pragma mark - request
- (NSString *)requestPath {
    return [NSString stringWithFormat:@"%@%@", Book_Url, BookSearch_Path];
}

- (NSDictionary*)dataParams {
    return @{
             @"q" : @"我的老家"
             };
}

- (NSArray *)constructDataArray
{
    return self.books;
}

@end
