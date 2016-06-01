//
//  MyPostRepairFollowTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "MyPostRepairFollowTableViewCell.h"

@implementation MyPostRepairFollowTableViewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) loadCellData:(OrderTrackModel *)orderTrackModel
{
    [self.postRepairDetail setText:orderTrackModel.trackDesc];
    [self.postRepairDate setText:orderTrackModel.submitDate];
}

@end
