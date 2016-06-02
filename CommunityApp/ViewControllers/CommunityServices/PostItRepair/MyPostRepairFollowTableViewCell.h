//
//  MyPostRepairFollowTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTrackModel.h"

@interface MyPostRepairFollowTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *postRepairDetail;
@property (strong,nonatomic) IBOutlet UILabel *postRepairDate;

-(void) loadCellData:(OrderTrackModel *)orderTrackModel;

@end
