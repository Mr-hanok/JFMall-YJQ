//
//  CSPRMyPostRepairCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPostRepair.h"

@interface MyPostRepairCellTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;
@property(strong,nonatomic) IBOutlet UILabel *orderLabel;
@property(strong,nonatomic) IBOutlet UILabel *delStatusLabel;
@property(strong,nonatomic) IBOutlet UILabel *serviceNameLabel;
@property(strong,nonatomic) IBOutlet UIButton *dealButton;
@property(strong,nonatomic) IBOutlet UIButton *cancelButton;
@property(strong,nonatomic) IBOutlet UIButton *delProgressButtonOfComplatePage;

-(void) loadCellData:(MyPostRepair *)myPostRepair;

-(void) addTrackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void) addCancelTrackTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void) addDelProgressButtonOfComplatePageTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end
