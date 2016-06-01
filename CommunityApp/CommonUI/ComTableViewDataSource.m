//
//  ComTableViewDataSource.m
//  CommonApp
//
//  Created by lipeng on 16/4/3.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComTableViewDataSource.h"
#import "ComTableViewCell.h"

@interface ComTableViewDataSource()

@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, strong) ConfigureCell configureCellBlock;

@end

@implementation ComTableViewDataSource

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(ConfigureCell)configureCellBlock
{
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = configureCellBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return _items[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
    }
    if (_configureCellBlock) {
        id item = [self itemAtIndexPath:indexPath];
        _configureCellBlock(cell, item, indexPath);
    }
    
    return cell;
}

@end
