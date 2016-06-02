//
//  DoorToDoorServiceTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"

@interface DoorToDoorServiceTableViewCell : UITableViewCell
- (void)loadCellData:(ServiceList *)model;
@end
