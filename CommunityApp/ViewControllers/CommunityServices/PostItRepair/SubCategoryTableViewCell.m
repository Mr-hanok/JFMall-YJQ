//
//  SubCategoryTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SubCategoryTableViewCell.h"

@interface SubCategoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@end

@implementation SubCategoryTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

//加载Cell数据
- (void)loadCellData:(PostItRepairCategoryModel *)model
{
    [self.title setText:model.serviceName];
}

@end
