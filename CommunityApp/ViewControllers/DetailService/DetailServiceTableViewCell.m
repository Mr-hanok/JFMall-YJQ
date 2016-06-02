//
//  DetailServiceTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DetailServiceTableViewCell.h"

@interface DetailServiceTableViewCell()

@property (retain, nonatomic) IBOutlet UILabel *title;

@end

@implementation DetailServiceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 装载Cell数据
- (void)loadCellData:(NSString *)title
{
    [self.title setText:title];
}

@end
