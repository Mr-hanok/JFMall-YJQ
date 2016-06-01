//
//  PersonalCenterMyOrderCouponDetailViewCell.m
//  CommunityApp
//
//  Created by iss on 7/22/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCouponDetailCell.h"
@interface PersonalCenterMyOrderCouponDetailCell()
@property (strong,nonatomic) IBOutlet UIImageView* bg;
@property (strong,nonatomic) IBOutlet UIImageView* bg1;
@property (strong,nonatomic) IBOutlet UILabel* ticketId;
@property (strong,nonatomic) IBOutlet UILabel* ticketNo;
@property (strong,nonatomic) IBOutlet UILabel* state;//   状态(0未使用  1已使用)
@end
@implementation PersonalCenterMyOrderCouponDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(ticketModel*)ticketData atIndex:(NSInteger)atIndex isButtom:(BOOL)isButtom

{
    if(isButtom)
    {
        [_bg setHidden:TRUE];
        [_bg1 setHidden:FALSE];
    }
    else
    {
        [_bg setHidden:FALSE];
        [_bg1 setHidden:TRUE];
    }
    
    [_ticketId setText:[NSString stringWithFormat:@"团购券%ld",(long)atIndex]];
    [_ticketNo setText:ticketData.ticketNo];

    NSInteger state = [ticketData.ticketStatus integerValue];
    switch (state) {
        case 0:
            [_state setText:@"未使用"];
            break;
        case 1:
            [_state setText:@"已使用"];
            break;
        case 2:
            [_state setText:@"已过期"];
            break;
        case 3:
            [_state setText:@"退款中"];
            break;
        case 4:
            [_state setText:@"已退款"];
            break;
        default:
            break;
    }
    if (state != 0) {
        [_checkBoxBtn setHidden:YES];
        _checkBoxWidth.constant = 0;
    }
}


#pragma mark - 优惠券选择按钮点击事件处理函数
- (IBAction)checkBoxBtnClickHandler:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    
    if (self.selectGrouponsBlock) {
        self.selectGrouponsBlock(sender.selected);
    }
}


@end
