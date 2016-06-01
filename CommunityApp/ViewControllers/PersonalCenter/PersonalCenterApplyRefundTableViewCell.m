//
//  PersonalCenterApplyRefundTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterApplyRefundTableViewCell.h"
@interface PersonalCenterApplyRefundTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* title;
@property (strong,nonatomic) IBOutlet UILabel* desc;
@property (strong,nonatomic) IBOutlet UIImageView* selImg;
@end
@implementation PersonalCenterApplyRefundTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
    {
        [_selImg setHidden:FALSE];
    }
    else
    {
        [_selImg setHidden:TRUE];
    }
}
-(void)loadCellData:(NSArray*)array andIsSelect:(BOOL)isSelect
{
    if (array.count ==0) {
        return;
    }
    [_title setText:[array objectAtIndex:0]];
    if(array.count == 2)
    {
        [_desc setHidden:FALSE];
        [_desc setText:[array objectAtIndex:1]];
    }
    else
    {
        [_desc setHidden:TRUE];
    }
    
    [_selImg setHidden:!isSelect];
}
@end
