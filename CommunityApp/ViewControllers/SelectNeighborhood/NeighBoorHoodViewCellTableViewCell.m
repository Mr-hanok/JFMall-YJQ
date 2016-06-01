//
//  NeighBoorHoodViewCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "NeighBoorHoodViewCellTableViewCell.h"

@interface NeighBoorHoodViewCellTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *title;

@end

@implementation NeighBoorHoodViewCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

// 加载Cell数据
- (void)loadCellData:(NeighBorHoodModel *)model
{
    [self.title setText: model.projectName];
}


@end
