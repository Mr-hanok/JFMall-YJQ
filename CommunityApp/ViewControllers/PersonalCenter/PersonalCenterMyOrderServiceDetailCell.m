//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderServiceDetailCell.h"
#import "UIImageView+AFNetworking.h"

@interface   PersonalCenterMyOrderServiceDetailCell()

@property(strong,nonatomic)IBOutlet UIImageView* icon;
@property(strong,nonatomic)IBOutlet UILabel* service;
@property(strong,nonatomic)IBOutlet UILabel* num;
@property(strong,nonatomic)IBOutlet UIImageView* line;
@property(strong,nonatomic)IBOutlet UILabel* service1;

@end
@implementation   PersonalCenterMyOrderServiceDetailCell
-(void)setCell:(ServiceOrderModel*)data
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:data.orderBase.filePath]];
    [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
}

-(void)setCellText:(NSString*)icon service:(NSString*)service num:(NSString*)num
{
    [self setAutoresizesSubviews:FALSE];
    if([icon isEqualToString:@""])
    {
        [_icon setHidden:TRUE];
        [_line setHidden:TRUE];

        [_service setHidden:TRUE];
        [_service1 setHidden:FALSE];
    }
    else
    {
        [_icon setHidden:NO];
        [_line setHidden:NO];
        NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:icon]];
        [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        
               [_service setHidden:FALSE];
        [_service1 setHidden:TRUE];

    }
    [_service setText:service];
    [_service1 setText:service];
    [_num  setText:[NSString stringWithFormat:@"%@:%@",Str_MyOrder_Number,num]];
}

@end
