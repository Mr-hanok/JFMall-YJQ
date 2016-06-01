
//
//  BuildingSelectTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BuildingSelectTableViewCell.h"
@interface BuildingSelectTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* text;
@property (strong,nonatomic) IBOutlet UIImageView* selImg;
@end

@implementation BuildingSelectTableViewCell

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
-(void) loadCellData:(BuildingListModel*)model
{
    [_text setText:model.buildAddress];
}

@end
