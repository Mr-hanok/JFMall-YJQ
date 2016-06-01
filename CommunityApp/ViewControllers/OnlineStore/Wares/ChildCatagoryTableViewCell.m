//
//  ChildCatagoryTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ChildCatagoryTableViewCell.h"

@interface ChildCatagoryTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@end


@implementation ChildCatagoryTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//加载Cell数据
- (void)loadCellData:(GoodsCategoryModel *)model
{
    [self.title setText:model.categoryName];
}

@end
