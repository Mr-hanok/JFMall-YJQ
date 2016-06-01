//
//  AfterSaleReasonTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/8/4.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleReasonTableViewCell.h"

@interface AfterSaleReasonTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *afterSaleReasonLabel;

@end
@implementation AfterSaleReasonTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(AfterSalesReason *)model {
    [self.afterSaleReasonLabel setText:model.afterSalesReasonName];
}

@end
