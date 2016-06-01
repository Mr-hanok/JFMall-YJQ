//
//  SubmitOrderTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SubmitOrderTableViewCell.h"

@interface SubmitOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation SubmitOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 加载Cell数据
- (void)loadCellData:(NSArray *)array
{
    [self.icon setImage:[UIImage imageNamed:[array objectAtIndex:0]]];
    [self.title setText:[array objectAtIndex:1]];
}


@end
