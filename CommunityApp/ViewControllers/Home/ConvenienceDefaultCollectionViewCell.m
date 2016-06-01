//
//  ConvenienceDefaultCollectionViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/7/1.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ConvenienceDefaultCollectionViewCell.h"

@interface ConvenienceDefaultCollectionViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation ConvenienceDefaultCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载Cell数据
- (void)loadCellData:(NSArray *)array
{
    self.bgView.backgroundColor = [array objectAtIndex:0];
    [self.icon setImage:[UIImage imageNamed:[array objectAtIndex:1]]];
    [self.title setText:[array objectAtIndex:2]];
}


@end
