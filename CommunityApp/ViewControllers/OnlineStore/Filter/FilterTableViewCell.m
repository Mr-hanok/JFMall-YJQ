//
//  FilterTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *filterType;

@end

@implementation FilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 加载Cell数据
- (void)loadCellData:(NSString *)type
{
    [self.filterType setText:type];
}

@end
