//
//  UITableViewCell+PersonCenterMeCell.m
//  CommunityApp
//
//  Created by iss on 6/4/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderTrackCell.h"


@interface   PersonalCenterMyOrderTrackCell()


@property(strong,nonatomic)IBOutlet UILabel* service;
@property(strong,nonatomic)IBOutlet UILabel* time;

@end

@implementation   PersonalCenterMyOrderTrackCell

-(void)setCellText:(OrderTrackModel*)orderTrack
{
    [_service setText:orderTrack.trackDesc];
    [_time setText:orderTrack.submitDate];
}

@end
