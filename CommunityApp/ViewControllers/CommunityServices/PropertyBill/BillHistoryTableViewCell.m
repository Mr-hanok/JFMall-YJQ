//
//  BillHistoryTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BillHistoryTableViewCell.h"

@interface BillHistoryTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *payType;
@property (retain, nonatomic) IBOutlet UILabel *money;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UILabel *state;
@end

@implementation BillHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 装载Cell数据
- (void)loadCellData:(PaymentHistoryModel *)model
{
    [self.payType setText:model.paymentTypeName];
    [self.money setText:[NSString stringWithFormat:@"￥%@",model.payMentAmount]];
    [self.date setText:model.payMentDate];
    NSString* stateString;
    UIColor* stateColor =[UIColor redColor];
    if([model.state isEqualToString:@"1"])      // 状态（1：未确认 2：已确认 3：已结算）
    {
        stateString = @"未确认";
        
    }
    else if([model.state isEqualToString:@"2"])
    {
        stateString = @"已确认";
        stateColor =[UIColor darkGrayColor];
    }
    else{
        stateString = @"已结算";
    }
    [_state setText:stateString];
    [_state setTextColor:stateColor];
}

@end
