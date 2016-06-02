//
//  HousesServicesHouseDescTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesHouseDescTableViewCell.h"
@interface HousesServicesHouseDescTableViewCell()

@property (strong,nonatomic) IBOutlet UILabel* title1;
@property (strong,nonatomic) IBOutlet UILabel* text1;
@property (strong,nonatomic) IBOutlet UILabel* title2;
@property (strong,nonatomic) IBOutlet UILabel* text2;

@end
@implementation HousesServicesHouseDescTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(NSDictionary*)dic
{
    if([dic allKeys].count<1)
        return;
    NSString* title = [[dic allKeys]objectAtIndex:0];
    [_title1 setText:[NSString stringWithFormat:@"%@:",title]];
    [_text1 setText:[dic objectForKey:title]];
    if([dic allKeys].count<2)
    {
        [_title2 setHidden:TRUE];
        [_text2 setHidden:TRUE];
        return;
    }
    title = [[dic allKeys]objectAtIndex:1];
    [_title2 setText:[NSString stringWithFormat:@"%@:",title]];
    [_text2 setText:[dic objectForKey:title]];
}
@end
