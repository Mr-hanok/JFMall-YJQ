//
//  ExpressTypeTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressTypeTableViewCell.h"

@interface ExpressTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *expressTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTypeImageView;
@end

@implementation ExpressTypeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(ExpressTypeModel *)model {
    [self.expressTypeLabel setText:model.ExpressTypeName];
    CGFloat price = [model.ExpressTypePrice floatValue];
    [self.expressPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", price]];
}

@end
