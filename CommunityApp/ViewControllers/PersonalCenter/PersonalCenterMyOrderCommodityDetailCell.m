//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCommodityDetailCell.h"
#import "UIImageView+AFNetworking.h"

@interface   PersonalCenterMyOrderCommodityDetailCell()

@property(strong,nonatomic)IBOutlet UIImageView* icon;
@property(strong,nonatomic)IBOutlet UILabel* service;
@property(strong,nonatomic)IBOutlet UILabel* num;
@property(strong,nonatomic)IBOutlet UIImageView* line;
@property(strong,nonatomic)IBOutlet UIButton* customerServiceBtn;

@end
@implementation   PersonalCenterMyOrderCommodityDetailCell
-(void)awakeFromNib
{
    [_customerServiceBtn.layer  setCornerRadius:3];
    [_customerServiceBtn.layer setBorderWidth:0.5f];
    [_customerServiceBtn.layer setBorderColor:COLOR_RGB(235,114.0,25.0).CGColor];
}
-(void)setCellText:(NSString*)icon service:(NSString*)service num:(NSString*)num
{
    [_service setText:service];
    [_num  setText:[NSString stringWithFormat:@"X%@",num]];
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:icon]];
    [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
}
-(IBAction)clickService:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toCustomerService:)]) {
        [self.delegate toCustomerService:self];
    }
}
@end
