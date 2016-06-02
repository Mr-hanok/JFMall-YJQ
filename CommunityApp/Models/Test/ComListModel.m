//
//  ComListModel.m
//  CommonApp
//
//  Created by lipeng on 16/3/30.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComListModel.h"

@implementation ComListModel

- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = 1;
    }
    return self;
}

- (NSUInteger)pageSize {
    return 20;
}

- (void)reload {
    self.currentPage = 1;
    [self load];
}

- (void)beforeLoad {
    [self addDataParam:[NSNumber numberWithInteger:(self.currentPage-1)*[self pageSize]] forKey:@"start"];
    [self addDataParam:[NSNumber numberWithInteger:[self pageSize]] forKey:@"count"];
    [super beforeLoad];
}

- (void)loadSucceed:(ComListModel *)response {
    if (_currentPage == 1) {
        self.listArray = [NSMutableArray array];
    }
    NSArray *array = [self constructDataArray];
    self.moreData = NO;
    if ([array count] > 0) {
        self.moreData = [array count] >= [self pageSize] ? YES : NO;
        self.currentPage ++;
        [self.listArray addObjectsFromArray:array];
    }
    [super loadSucceed:response];
}

- (NSArray*)constructDataArray
{
    return nil;
}

@end
