//
//  BuildingSelectTableViewCell.h
//  CommunityApp
//
//  Created by iss on 7/17/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingListModel.h"

@interface BuildingSelectTableViewCell : UITableViewCell
-(void) loadCellData:(BuildingListModel*)model;
@end
