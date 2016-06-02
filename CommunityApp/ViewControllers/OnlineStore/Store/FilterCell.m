//
//  FilterCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/21.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FilterCell.h"
@interface FilterCell()
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *filterSelectedImageView;
@end
@implementation FilterCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(NSString *)filterName isSelected:(BOOL)isSel {
    [_filterNameLabel setText:filterName];
    [self setCellSelected:isSel];
}

- (void)setCellSelected:(BOOL)isSel {
    [_filterSelectedImageView setHidden:(!isSel)];
    if (isSel) {
        _filterNameLabel.textColor = Color_Orange_RGB;
    }
    else {
        _filterNameLabel.textColor = Color_Dark_Gray_RGB;
    }
}

@end
