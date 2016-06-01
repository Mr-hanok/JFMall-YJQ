//
//  GrouponListTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/7/27.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponList.h"

@interface GrouponListTableViewCell : UITableViewCell
- (void)loadCellData:(GrouponList *)model;

@property (nonatomic, retain) NSTimer *timer;
@property (copy,nonatomic) void (^clearTimer)(NSTimer* timer);
@property (nonatomic, copy) void(^dialBuyNowBlock)(void);
@end
