//
//  ExpressOrderTrackTableViewCell.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTrackModel.h"


@interface ExpressOrderTrackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *hLine;

-(void)loadCellData:(OrderTrackModel*)orderTrack;

@end
