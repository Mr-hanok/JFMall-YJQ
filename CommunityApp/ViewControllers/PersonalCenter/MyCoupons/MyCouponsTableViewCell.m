//
//  MyGrouponTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/20/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsTableViewCell.h"
@interface MyCouponsTableViewCell()
@property (strong,nonatomic) IBOutlet UIImageView* bgImg;
@property (strong,nonatomic) IBOutlet UIImageView* buttomLine;
@property (strong,nonatomic) IBOutlet UILabel* ticketId;
@property (strong,nonatomic) IBOutlet UILabel* ticketNo;
@property (strong,nonatomic) IBOutlet UILabel* state;//   状态(0未使用  1已使用)
@end
@implementation MyCouponsTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_buttomLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadCellData:(ticketModel*)ticketData atIndex:(NSInteger)atIndex isButtom:(BOOL)isButtom
{
    [_buttomLine setHidden:isButtom];
    [_ticketId setText:[NSString stringWithFormat:@"团购券%ld",(long)atIndex]];
    [_ticketNo setText:ticketData.ticketNo];
    
    [_bgImg setImage:isButtom?[UIImage imageNamed:Img_MyCouponList_Buttom]:[UIImage imageNamed:Img_MyCouponList_Mid]];
    
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
}
@end
