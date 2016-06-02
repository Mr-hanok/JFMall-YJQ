//
//  BookModel.m
//  CommonApp
//
//  Created by lipeng on 16/3/30.
//  Copyright © 2016年 common. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

- (NSString *)requestPath {
    return [NSString stringWithFormat:@"%@%@", Book_Url, Book_Path];
}

@end
