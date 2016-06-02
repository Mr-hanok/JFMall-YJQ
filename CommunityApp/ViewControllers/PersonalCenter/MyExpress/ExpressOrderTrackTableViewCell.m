//
//  ExpressOrderTrackTableViewCell.m
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressOrderTrackTableViewCell.h"

@implementation ExpressOrderTrackTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_hLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCellData:(OrderTrackModel*)orderTrack
{
    [_descLabel setText:orderTrack.trackDesc];
    [_timeLabel setText:orderTrack.submitDate];
}

@end
