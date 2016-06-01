//
//  MyVisitorTableViewCell.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/14.
//  Copyright © 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVisitorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *VisitorName;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *YorNlabel;

@end
