//
//  LimitBuySelectorTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "LimitBuySelectorTableViewCell.h"
@interface LimitBuySelectorTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeSelected;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@end

@implementation LimitBuySelectorTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(LimitBuySelector *)model {
    [_categoryNameLabel setText:model.categoryName];
    if ([model.isSelected isEqual:@"0"]) {
        [self categorySelected:NO];
        [_categoryNameLabel setTextColor:Color_Dark_Gray_RGB];
    }
    else if ([model.isSelected isEqual:@"1"]) {
        [self categorySelected:YES];
        [_categoryNameLabel setTextColor:Color_Orange_RGB];
    }
}

- (void)categorySelected:(BOOL)isSel {
    _typeSelected.hidden = (isSel ? NO : YES);
}

@end
