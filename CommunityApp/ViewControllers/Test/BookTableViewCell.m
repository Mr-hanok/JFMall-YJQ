//
//  BookTableViewCell.m
//  CommonApp
//
//  Created by lipeng on 16/4/1.
//  Copyright © 2016年 common. All rights reserved.
//

#import "BookTableViewCell.h"
#import "BookModel.h"

@implementation BookTableViewCell

- (void)setItem:(BookModel *)item {
    [super setItem:item];
    
    self.textLabel.text = item.title;
}

@end
