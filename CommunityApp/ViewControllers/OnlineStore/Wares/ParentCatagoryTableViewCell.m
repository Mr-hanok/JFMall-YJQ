//
//  ParentCatagoryTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/13.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ParentCatagoryTableViewCell.h"

@interface ParentCatagoryTableViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *checkBox;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@end

@implementation ParentCatagoryTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

//选中事件
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.checkBox setHidden:NO];
    }
    else{
        [self.checkBox setHidden:YES];
    }
    
}

//加载Cell数据
- (void)loadCellData:(GoodsCategoryModel *)model
{
    [self.title setText:model.categoryName];
}


@end
