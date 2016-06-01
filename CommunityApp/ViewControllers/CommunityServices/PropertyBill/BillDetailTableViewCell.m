//
//  BillDetailTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillDetailTableViewCell.h"

@interface BillDetailTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *currentCost;
@property (retain, nonatomic) IBOutlet UILabel *paidCost;

@end

@implementation BillDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 加载Cell数据
- (void)loadCellData:(BillListModel *)model
{
    [self.title setText:[NSString stringWithFormat:@"%@ %@",model.fiName,model.billDate]];
    [self.currentCost setText:[NSString stringWithFormat:@"￥%@",model.receivable]];
    if([model.settlementStatus isEqualToString:@"1"])
    {
       [self.paidCost setText:[NSString stringWithFormat:@"￥%@",model.receivable]];
    }
    else
    {
        [self.paidCost setText:@"￥0"];
    }
}


@end
